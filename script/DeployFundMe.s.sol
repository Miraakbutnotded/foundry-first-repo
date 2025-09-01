// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script{
    function run() external returns (FundMe) {
    HelperConfig helperConfig = new HelperConfig();
    (address priceFeed, ) = helperConfig.activeNetworkConfig(); // get the first value

    vm.startBroadcast();
    FundMe fundMe = new FundMe(priceFeed); // Pass priceFeed to the constructor
    vm.stopBroadcast();
    return fundMe;
}
}

