//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {MockV3Aggregator} from "@chainlink/contracts/contracts/src/v0.8/tests/MockV3Aggregator.sol";
import {FundMe} from "../../src/FundMe.sol"; // Was "../FundMe.sol"
import {PriceConverter} from "../../src/PriceConverter.sol"; // Was "../PriceConverter.sol"
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {Test} from "forge-std/Test.sol";
import {WithdrawFundMe} from "../../script/Interactions.s.sol";
contract Interactions is Test {

    uint256 constant SEND_VALUE = 0.1 ether; // 100000000000000000 wei, or 0.1 ETH
    address USER;
    uint256 constant STARTING_BALANCE = 10 ether; // 10000000000000000000 wei, or 10 ETH
    uint256 constant GAS_PRICE = 1;
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        vm.deal(address(fundFundMe), 1 ether); // Give the script contract ETH
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
        assert(address(fundMe).balance == 0);
    }
    
}
