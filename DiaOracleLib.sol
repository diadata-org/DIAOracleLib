// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.7 <0.9.0;

interface IDiaOracleV2{
    function getValue(string memory) external returns (uint128, uint128);
}

library DiaOracleLib  {
    address immutable ORACLE = 0xa93546947f3015c986695750b8bbEa8e26D65856;

    function getPrice(string memory key) internal returns (uint128 price){
        (price, ) = IDiaOracleV2(ORACLE).getValue(key);
    }

    function getPriceIfNotOlderThan(
        string memory key,
        uint128 _timeConstraint
        )
        internal
        returns (uint128 price, bool inTime)
    {

        uint128 lastTimestamp;
        (price, lastTimestamp ) = IDiaOracleV2(ORACLE).getValue(key);
        inTime = ( (block.timestamp - _timeConstraint) > lastTimestamp) ? true : false;
    }

}
