// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Paymaster.sol";
import "@account-abstraction/interfaces/IEntryPoint.sol";

// This script deploys a Paymaster
contract DeployPaymaster is Script {
    address entryPoint = 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789;

    function run() public {
        Paymaster paymaster = new Paymaster(IEntryPoint(entryPoint));
    }
}
