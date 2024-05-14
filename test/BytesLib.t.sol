// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {AssociatedBytesLib} from "../src/BytesLib.sol";

contract CounterTest is Test {
    using AssociatedBytesLib for AssociatedBytesLib.Bytes;
    using AssociatedBytesLib for mapping(address => AssociatedBytesLib.Bytes);

    mapping(address account => AssociatedBytesLib.Bytes) internal data;

    function setUp() public {}

    function test_store() public {

        bytes32 baseSlot;
        AssociatedBytesLib.Bytes storage bytesData = data[address(this)];
        assembly {
            baseSlot := bytesData.slot
        }
        bytes memory d = hex"424141414141414141414141414141414141414141414141414141414141414141414143";
        vm.record();
        data[address(this)].store(d);
        (bytes32[] memory reads, bytes32[] memory writes) = vm.accesses(address(this));

        console.log("writes");
        for (uint256 i = 0; i < writes.length; i++) {
            console.logBytes32(writes[i]);
        }

        bytes memory _d = data[address(this)].load();

        assertEq(_d, d);
        assertEq(writes[0], baseSlot);

    }

    function test_mapping() public {
        bytes memory d = hex"424141414141414141414141414141414141414141414141414141414141414141414143";
        vm.record();
        data.store(address(this), d);

        bytes memory _d = data.load(address(this));
        (bytes32[] memory reads, bytes32[] memory writes) = vm.accesses(address(this));
        console.log("writes");
        for (uint256 i = 0; i < writes.length; i++) {
            console.logBytes32(writes[i]);
        }

        console.log("reads");
        for (uint256 i = 0; i < reads.length; i++) {
            console.logBytes32(reads[i]);
        }

        assertEq(_d, d);
    }
}
