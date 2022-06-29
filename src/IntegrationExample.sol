// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import {DIAOracleLib} from "./libraries/DIAOracleLib.sol";

/**
* @title Example contract showing how DIAOracleLib can be used
*/
contract IntegrationExample{
    error PriceTooOld();

    address immutable ORACLE = 0xa93546947f3015c986695750b8bbEa8e26D65856;

    /**
    * @dev To get the price of an asset use the getPrice function in
    * the DIAOracleLib Library with an oracle address and a key.
    */
    function exampleGetPrice(string memory key) external returns (uint128){
        return DIAOracleLib.getPrice(ORACLE, key);
    }

    /**
    * @dev To assess if the price has been updated recently use the 
    * getPriceNotOlderThan function in the DIAOracleLib Library. 
    *
    * In this example we chose to revert if the price was updated
    * longer than maxTimePassed seconds ago.
    */
    function exampleCheckPrice(string memory key, uint128 maxTimePassed)
        external
        returns (uint128 price)
    {

        bool inTime;
        (price, inTime) = DIAOracleLib.getPriceIfNotOlderThan(ORACLE, key, maxTimePassed);

        if (!inTime) revert PriceTooOld();

        return price;

    }
}
