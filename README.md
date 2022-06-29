# DIAOracleLib

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
| Price | uint128 | Price of the specified asset returned by the DIAOracle |


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
| Price | uint128 | Price of the specified asset returned by the DIAOracle |
| inTime| uint128 |  A boolian that is ```true``` if the price was updated at most maxTimePassed seconds ago, otherwise ```false```|

# Integration Example 

A contract, IntegrationExample, is provided to show you how to integrate DIAOracleLib in your own contracts. 

Start by importing the library in your own contract:

```
import {DIAOracleLib} from "./libraries/DIAOracleLib.sol";
```

To get the price of an asset use the ```getPrice```. In this example we simply return the retrieved price.

```
function exampleGetPrice(string memory key) external returns (uint128){
        return DIAOracleLib.getPrice(ORACLE, key);
    }
```

With the ```getPriceIfNotOlderThan``` function we can check if the price of an asset has been updated recently. In this example we revert if the price is older than the provided threshold. 

```
    function exampleCheckPrice(string memory key, uint128 maxTimePassed)
        external
        returns (uint128 price)
    {
        bool inTime;
        (price, inTime) = DIAOracleLib.getPriceIfNotOlderThan(ORACLE, key, maxTimePassed);

        if (!inTime) revert PriceTooOld();

        return price;
    }
```

# Running Tests

To run the tests provided in /test on DIAOracleLib and IntegrationExample first install [foundry](https://book.getfoundry.sh/getting-started/installation.html) and then run the following commands:

```
git clone git@github.com:tajobin/DIAOracleLib.git
cd DIAOracle
forge test --fork-url <RCP_URL> --fork-block-number 15045231
```

Provide your own RCP_URL to fork mainnet, you can get one from a provider such as Infura. 

In the tests provided we are forking Ethereum mainnet. If you wish to run these tests on another network, change the ORACLE address in TestOracleLib and IntegrationExample to an address of a deployed DIAOracleV2 contract and provide a RCP_URL to the network. 

