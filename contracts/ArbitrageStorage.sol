pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "./extern/UintConverter.sol";
import "./extern/Manageable.sol";
import "./interface/IArbitrageStorage.sol";

contract ArbitrageStorage is Manageable, ArbitrageStorageInterface {

    
   constructor(address owner, address manager)
   Ownable(owner)
   Manageable(manager)
   {

   }

    function addArbitrage(address issuer,  address arbitrage) external override
    {
        
    }

    function addDao(address issuer,  address dao) external override
    {

    }

}
