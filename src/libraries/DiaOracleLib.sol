// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

interface IDiaOracleV2{
    function getValue(string memory) external returns (uint128, uint128);
}

/**
* @title Integration Library contract for DiaOracleV2
* @dev This Library contract can be used on all EVM
* chains with a deployed DiaOracleV2 contract. See
* doc.diadata.org for supported chains.
*/

library DiaOracleLib  {

    /**
    * @dev Returns the oracle data price
    * @param oracle - The oracle address. 
    * @param key - A string specifying the asset.
    * @return price - The price of the asset specified. 
    */
    function getPrice(address oracle, string memory key) internal returns (uint128 price){
        (price, ) = IDiaOracleV2(oracle).getValue(key);
    }

    /**
    * @dev A function that chekcs if the oracle price is too old.
    * @param oracle - The oracle address. 
    * @param key - A string specifying the asset.
    * @param maxTimePassed - The max acceptable amount of time passed since the
    * oracle price was last updated.
    * @return price - The price returned by the oracle. 
    * @return inTime - A boolian that is true if the price was updated
    * at most maxTimePassed seconds ago, otherwise false.
    */
    function getPriceIfNotOlderThan(
        address oracle,
        string memory key,
        uint128 maxTimePassed
        )
        internal
        returns (uint128 price, bool inTime)
    {
        uint128 oracleTimestamp;
        (price, oracleTimestamp ) = IDiaOracleV2(oracle).getValue(key);
        inTime = ((block.timestamp - oracleTimestamp) < maxTimePassed) ? true : false;

    }
}
