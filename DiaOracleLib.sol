// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.7 <0.9.0;

interface IDiaOracleV2{
    function getValue(string memory) external returns (uint128, uint128);
}

interface IDiaOracleV1 {
    function getCoinInfo(string memory) external returns (uint256, uint256, uint256, string memory);
}

library DiaOracleLib  {

    function getPriceV1(address _oracle, string memory key) internal returns (uint256 price){
        (price, , , ) = IDiaOracleV1(_oracle).getCoinInfo(key);
    }

    function getPriceIfNotOlderThanV1(
        address _oracle,
        string memory key,
        uint256 _timeConstraint
        )
        internal
        returns (uint256 price, bool inTime)
    {
        uint256 lastTimestamp;
        (price, lastTimestamp, , ) = IDiaOracleV1(_oracle).getCoinInfo(key);
        inTime = ( (block.timestamp - _timeConstraint) > lastTimestamp) ? true : false;
    }

    function getPriceV2(address _oracle, string memory key) internal returns (uint128 price){
        (price, ) = IDiaOracleV2(_oracle).getValue(key);
    }

    function getPriceIfNotOlderThanV2(address _oracle, string memory key, uint128 _timeConstraint) internal returns (uint128 price, bool inTime){
        uint128 lastTimestamp;
        (price, lastTimestamp ) = IDiaOracleV2(_oracle).getValue(key);
        inTime = ( (block.timestamp - _timeConstraint) > lastTimestamp) ? true : false;
    }
}
