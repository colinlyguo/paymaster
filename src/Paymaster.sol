// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.20;

/* solhint-disable reason-string */

import "@account-abstraction/core/BasePaymaster.sol";

/**
 * A paymaster that pays for the user operations.
 */
contract Paymaster is BasePaymaster {
    using UserOperationLib for UserOperation;

    constructor(IEntryPoint _entryPoint) BasePaymaster(_entryPoint) {
        require(address(_entryPoint).code.length > 0, "Paymaster: passed _entryPoint is not currently a contract");
    }

    function _validatePaymasterUserOp(UserOperation calldata userOp, bytes32 /*userOpHash*/, uint256 /*requiredPreFund*/)
    internal view override returns (bytes memory context, uint256 validationData) {
        (uint48 validUntil, uint48 validAfter, bytes calldata signature) = parsePaymasterAndData(userOp.paymasterAndData);
        require(msg.sender == address(_entryPoint), "Paymaster: only entryPoint can call this function");
        return ("", _packValidationData(false, 0, 0));
    }

    receive() external payable {
        // use address(this).balance rather than msg.value in case of force-send
        (bool callSuccess, ) = payable(address(entryPoint)).call{value: address(this).balance}("");
        require(callSuccess, "Deposit failed");
    }
}
