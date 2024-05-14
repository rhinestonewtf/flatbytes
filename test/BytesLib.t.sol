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
    }

    function test_mapping() public {
        bytes memory d = hex"424141414141414141414141414141414141414141414141414141414141414141414143";
        vm.record();
        data.store(address(this), d);
        (bytes32[] memory reads, bytes32[] memory writes) = vm.accesses(address(this));

        console.log("writes");
        for (uint256 i = 0; i < writes.length; i++) {
            console.logBytes32(writes[i]);
        }

        bytes memory _d = data.load(address(this));

        assertEq(_d, d);
    }
}
