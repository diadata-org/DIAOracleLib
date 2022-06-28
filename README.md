# DiaOracleLib

A Library to facilitate integration of DIA oracles in your own
contracts. The library consists of two functions, ```getPrice``` and ```getPriceIfNotOlderThan```.

## getPrice

```
function getPrice(address oracle, string memory key) internal returns (uint128 price)
```

Returns the price of a specified asset.

Parameters:

| Name   | Type    | Description                                  |
|--------|---------|----------------------------------------------|
| oracle | address | Address of the oracle that we want to use    |
| key    | string  | The asset that we want to use e.g. "ETH/USD" |

Return Values:

| Name  | Type   | Description                                            |
|-------|--------|--------------------------------------------------------|
| Price | uin128 | Price of the specified asset returned by the DiaOracle |


## getPriceIfNotOlderThan
```
function getPriceIfNotOlderThan(
        address oracle,
        string memory key,
        uint128 maxTimePassed
        )
        internal
        returns (uint128 price, bool inTime)
    {
```
Checks if the oracle price is older than ```maxTimePassed```

Parameters:

| Name   | Type    | Description                                  |
|--------|---------|----------------------------------------------|
| oracle | address | Address of the oracle that we want to use    |
| key    | string  | The asset that we want to use e.g. "ETH/USD" |
| maxTimePassed | uint128 | The maximum acceptable time passed in seconds since the the price was updated |

Return Values:

| Name  | Type   | Description                                            |
|-------|--------|--------------------------------------------------------|
| Price | uin128 | Price of the specified asset returned by the DiaOracle |
| inTime| uin128 |  A boolian that is ```true``` if the price was updated at most maxTimePassed seconds ago, otherwise ```false```|
