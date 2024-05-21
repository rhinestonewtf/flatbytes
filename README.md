# Associated Bytes Library

**A library to use `bytes storage` in an ERC-4337 compliant way**

> This repository is a work in progress and is not yet ready for production use.

## Using the library

In a contract, you can use the `AssociatedBytes` library to store bytes in a way that is compliant with the ERC-4337 standard:

```solidity
contract Example {
    using AssociatedBytesLib for AssociatedBytesLib.Bytes;

    AssociatedBytesLib.Bytes data;

    function set(bytes memory _data) external {
        data.store(_data);
    }

    function get() external view returns (bytes memory) {
        return data.load();
    }
}
```

## Using this repo

To install the dependencies, run:

```bash
forge install
```

To build the project, run:

```bash
forge build
```

To run the tests, run:

```bash
forge test
```

## Contributing

For feature or change requests, feel free to open a PR, start a discussion or get in touch with us.
