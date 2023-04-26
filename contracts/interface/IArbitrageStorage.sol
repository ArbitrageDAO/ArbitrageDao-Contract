pragma solidity ^0.8.0;
interface ArbitrageStorageInterface {
    
    function addArbitrage(address issuer,  address arbitrage) external;

    function addDao(address issuer,  address dao) external;
}

        