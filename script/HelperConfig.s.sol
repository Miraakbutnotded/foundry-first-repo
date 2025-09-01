//SPDX: License-Identifier: MIT
pragma solidity ^0.8.18;

//1. Deploy mock when we are on local anvil chain
//2. Keep track of contract addresses across different chains

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "@chainlink/contracts/contracts/src/v0.8/tests/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //If we are on local chain use mock, otherwise use the real price feed address

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
        }


            struct NetworkConfig {
        address priceFeed; //ETH/USD price feed addres
        address mockFeed;
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        //price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed : 0x694AA1769357215DE4FAC081bf1f309aDC325306, mockFeed: address(0)});
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        //deploy the mocks
        //return mock address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8); // 2000 USD in 8 decimals
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed),
            mockFeed: address(mockPriceFeed) //Is this neccesary? Yes, if you want to use the mock in tests

        });
        return anvilConfig;
    }

    
    }

