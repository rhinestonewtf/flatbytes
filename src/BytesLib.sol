// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

library AssociatedBytesLib {
    using AssociatedBytesLib for *;

    /*//////////////////////////////////////////////////////////////////////////
                                    DATA STRUCTURES
    //////////////////////////////////////////////////////////////////////////*/

    struct Data {
        bytes32[10] slot1;
    }

    struct Bytes {
        uint256 totalLength;
        Data data;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                    FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

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

    function clear(Bytes storage self) internal {
        self.totalLength = 0;
        Data storage _data = self.data;
        for (uint256 i; i < 10; i++) {
            assembly {
                sstore(add(_data.slot, i), 0)
            }
        }
    }

    function load(Bytes storage self) internal view returns (bytes memory data) {
        return self.toBytes();
    }

    /*//////////////////////////////////////////////////////////////////////////
                                    INTERNAL
    //////////////////////////////////////////////////////////////////////////*/

    function toArray(bytes memory data)
        internal
        pure
        returns (uint256 totalLength, bytes32[] memory dataList)
    {
        // Find 32 bytes segments nb
        totalLength = data.length;
        if (totalLength > 32 * 10) revert();
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
}
