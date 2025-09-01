//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {FundMe} from "../FundMe.sol";
import {PriceConverter} from "../PriceConverter.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {MockV3Aggregator} from "@chainlink/contracts/contracts/src/v0.8/tests/MockV3Aggregator.sol";
import {Test, console} from "forge-std/Test.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    uint256 constant SEND_VALUE = 0.1 ether; // 100000000000000000 wei, or 0.1 ETH
    address USER;
    uint256 constant STARTING_BALANCE = 10 ether; // 10000000000000000000 wei, or 10 ETH
    uint256 constant GAS_PRICE = 1;
    function setUp() external {
        USER = makeAddr("user");
        vm.deal(USER, STARTING_BALANCE);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarisFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeeVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 0); // Assuming the version is 0, adjust as necessary. 0 is mock version,
        // the real Chainlink ETH/USD feed on mainnet returns 4 for version(), meaning it’s AggregatorV3 version 4.
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); //next line should revert
        fundMe.fund(); // Should revert if not enough ETH is sent
    }


    //Doesnt work cant find aggregater mock
    function testFundUpdatesDataStructure() public {
        vm.prank(USER); // Simulate USER as the sender
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public{
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded{
        vm.prank(USER);
        
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithASingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;

        uint256 startingFundMeBalance = address(fundMe).balance;

        //act
        uint256 gasStart = gasleft(); // 1000
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner()); // 200
        fundMe.withdraw(); //SHOULD HAVE SPENT GAS?


        uint256 gasEnd = gasleft(); //800
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);
        //Assert

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );

    }

    function testWithdrawFromMultipleFundersCheaper() public funded{
        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
            //vm.prank new address
            //vm.deal
            hoax(address(i), SEND_VALUE); // creates an address with balance
            fundMe.fund{value: SEND_VALUE}();
            // fund the fundMe
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //Act
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();
        //Assert
     
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance
        );

    }

    function testWithdrawFromMultipleFunders() public funded{
        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
            //vm.prank new address
            //vm.deal
            hoax(address(i), SEND_VALUE); // creates an address with balance
            fundMe.fund{value: SEND_VALUE}();
            // fund the fundMe
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        //Assert
     
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance
        );

    }
}
