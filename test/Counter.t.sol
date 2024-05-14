// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {AssociatedBytesLib} from "../src/BytesLib.sol";

contract CounterTest is Test {
    using AssociatedBytesLib for AssociatedBytesLib.Bytes;

    mapping(address account => AssociatedBytesLib.Bytes) internal data;

    function setUp() public {}

    function test_store(bytes memory d) public {
        data[address(this)].store(d);

        bytes memory _d = data[address(this)].load();

        assertEq(_d, d);
    }
}
