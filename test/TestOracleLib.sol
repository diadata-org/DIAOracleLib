// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { IntegrationExample } from "./../src/IntegrationExample.sol";
import { DIAOracleLib } from "./../src/libraries/DIAOracleLib.sol";

/**
* @title DIAOracle tests
* @dev Tests that the DIALibrary library contract functions as expected
* aswell as testing of a simple contract that integrates the library
*/

interface IDIAOracleV2{
    function getValue(string memory) external returns (uint128, uint128);
}

contract TestOracleLib is Test {
    address immutable ORACLE = 0xa93546947f3015c986695750b8bbEa8e26D65856;

    function setUp() public {
    }

    /**
    * @dev Test that the price returned from using the library and directly
    * calling the oracle are equal.
    * */
    function testGetPrice() public {
        uint128 priceFromLib = DIAOracleLib.getPrice(ORACLE, "ETH/USD");

        (uint128 priceFromOracle, ) = IDIAOracleV2(ORACLE).getValue("ETH/USD");

        assertEq(priceFromLib, priceFromOracle);
    }

    /**
     * @dev Fuzzy test that checks if the bool returned from getPriceIfNotOlderThan is correct.
     * random sample of 256 values between 1 and 10000000 are tested.
     */
    function testGetPriceIfNotOlderThan(uint256 maxTimePassed256) public {
        maxTimePassed256 = bound(maxTimePassed256, 1, 10000);
        uint128 maxTimePassed = uint128(maxTimePassed256);

        (uint128 priceFromLib, bool inTime) =
            DIAOracleLib.getPriceIfNotOlderThan(ORACLE, "ETH/USD", maxTimePassed);

         (uint128 priceFromOracle, uint128 oracleTimestamp) =
            IDIAOracleV2(ORACLE).getValue("ETH/USD");

         bool inTimeOracle;

         if((block.timestamp - oracleTimestamp) < maxTimePassed){
             inTimeOracle = true;
         } else {
             inTimeOracle = false;
         }

         assertEq(inTimeOracle, inTime);
    }

    /**
    * @dev Test that the IntegraionExample contract reverts with the expected error
    * if maxTimePassed is smaller than time passed since last price update.
    */
    function testIntegrationExample() public {

        IntegrationExample iExample = new IntegrationExample();

        vm.expectRevert(IntegrationExample.PriceTooOld.selector);
        iExample.exampleCheckPrice("ETH/USD", 1);

    }

    /**
    * @dev Test that the IntegrationExample contract returns the correct price.
    */
    function testIntegrationExampleGetPrice() public {
        IntegrationExample iExample = new IntegrationExample();
        uint128 priceFromIExample = iExample.exampleGetPrice("ETH/USD");
        (uint128 priceFromOracle, ) = IDIAOracleV2(ORACLE).getValue("ETH/USD");

        assertEq(priceFromIExample, priceFromOracle);
    }
}
