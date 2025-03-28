// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { DIAOracleLib } from "./libraries/DIAOracleLib.sol";

/**
 * @title Example contract showing how DIAOracleLib can be used
 */
contract DIAOracleSample {
    error PriceTooOld();

    address diaOracle;

    constructor(address _oracle) {
        diaOracle = _oracle;
    }

    /**
     * @dev To get the price of an asset use the getPrice function in
     * the DIAOracleLib Library with an oracle address and a key (e.g. "BTC/USD").
     */
    function getPrice(
        string memory key
    ) external view returns (uint128 latestPrice) {
        (latestPrice, ) = DIAOracleLib.getPrice(diaOracle, key);
    }

    /**
     * @dev To assess if the price has been updated recently use the
     * getPriceNotOlderThan function in the DIAOracleLib Library.
     *
     * In this example we chose to revert if the price was updated
     * longer than maxTimePassed seconds ago.
     */
    function checkPriceAge(
        string memory key,
        uint128 maxTimePassed
    ) external view returns (uint128 price) {
        bool inTime;
        (price, inTime) = DIAOracleLib.getPriceIfNotOlderThan(
            diaOracle,
            key,
            maxTimePassed
        );

        if (!inTime) revert PriceTooOld();
    }
}
