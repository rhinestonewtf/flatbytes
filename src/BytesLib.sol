// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

library AssociatedBytesLib {
    using AssociatedBytesLib for *;

    struct Bytes {
        uint256 totalLength;
        bytes32[] entries;
    }

    function toArray(bytes memory data) internal pure returns (uint256 totalLength, bytes32[] memory dataList) {
        // Find 32 bytes segments nb
        totalLength = data.length;
        uint256 dataNb = totalLength / 32 + 1;

        // Create an array of dataNb elements
        dataList = new bytes32[](dataNb);
        // Start array index at 0
        uint256 index = 0;
        // Loop all 32 bytes segments
        uint256 foo = dataNb * 32;
        for (uint256 i = 32; i <= foo; i = i + 32) {
            bytes32 temp;
            // Get 32 bytes from data
            assembly {
                temp := mload(add(data, i))
            }
            // Add extracted 32 bytes to list
            dataList[index] = temp;

            index++;
        }
    }

    function toBytes(Bytes storage self) internal view returns (bytes memory data) {
        uint256 totalLength = self.totalLength;
        data = abi.encodePacked(self.entries);
        assembly {
            mstore(data, totalLength)
        }
    }

    function store(Bytes storage self, bytes memory data) internal {
        (self.totalLength, self.entries) = data.toArray();
    }

    function load(Bytes storage self) internal view returns (bytes memory) {
        return self.toBytes();
    }
}
