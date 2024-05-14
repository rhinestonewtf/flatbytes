// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "forge-std/console2.sol";

library AssociatedBytesLib {
    using AssociatedBytesLib for *;

    struct Data {
        bytes32 slot1;
        bytes32 slot2;
        bytes32 slot3;
        bytes32 slot4;
        bytes32 slot5;
        bytes32 slot6;
        bytes32 slot7;
        bytes32 slot8;
        bytes32 slot9;
        bytes32 slot10;
    }

    struct Bytes {
        uint256 totalLength;
        Data data;
    }

    function toArray(bytes memory data) internal pure returns (uint256 totalLength, bytes32[] memory dataList) {
        // Find 32 bytes segments nb
        totalLength = data.length;
        uint256 dataNb = totalLength / 32 + 1;

        // Create an array of dataNb elements
        dataList = new bytes32[](dataNb);

        // Loop all 32 bytes segments
        for (uint256 i = 0; i < dataNb; i++) {
            bytes32 temp;
            // Get 32 bytes from data
            assembly {
                temp := mload(add(data, mul(add(i, 1), 32)))
            }
            // Add extracted 32 bytes to list
            dataList[i] = temp;
        }
    }

    function toBytes(Bytes storage self) internal view returns (bytes memory data) {
        uint256 totalLength = self.totalLength;
        uint256 slotsCnt = totalLength / 32 + 1;

        Data storage _data = self.data;

        bytes32[] memory entries = new bytes32[](slotsCnt);
        for (uint256 i; i < slotsCnt; i++) {
            bytes32 tmp;
            assembly {
                tmp := sload(add(_data.slot, i))
            }
            entries[i] = tmp;
        }

        data = abi.encodePacked(entries);
        assembly {
            mstore(data, totalLength)
        }
    }

    function store(Bytes storage self, bytes memory data) internal {
        if (data.length > 32 * 10) revert();
        bytes32[] memory entries;
        (self.totalLength, entries) = data.toArray();

        uint256 length = entries.length;

        Data storage _data = self.data;

        for (uint256 i; i < length; i++) {
            bytes32 value = entries[i];
            assembly {
                sstore(add(_data.slot, i), value)
            }
        }
    }

    function store(mapping(address => Bytes) storage associatedBytes, address account, bytes memory data) internal {
        Bytes storage _bytes = associatedBytes[account];

        if (data.length > 32 * 10) revert();
        bytes32[] memory entries;
        (_bytes.totalLength, entries) = data.toArray();

        uint256 length = entries.length;

        Data storage _data = _bytes.data;

        for (uint256 i; i < length; i++) {
            bytes32 value = entries[i];
            uint256 slot = i;
            assembly {
                sstore(add(_data.slot, slot), value)
            }
        }
    }

    function load(Bytes storage self) internal view returns (bytes memory data) {
        return self.toBytes();
    }

    function load(mapping(address => Bytes) storage associatedBytes, address account)
        internal
        view
        returns (bytes memory)
    {
        return associatedBytes[account].toBytes();
    }
}
