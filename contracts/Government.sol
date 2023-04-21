pragma solidity ^0.8.0;
import './interface/IArbitrage.sol';
import './extern/Manageable.sol';
contract GovDao is Ownable {
    address public arbitrage;
    address public strategy;
    constructor(address _strategy, address onwer)Ownable(onwer){
        strategy = _strategy;
    }

    function setArbitrage(address _arbitrage) external onlyOwner{
        arbitrage = _arbitrage;
    }

    function openPostion(
        int256 amountOutMinimum,
        uint160 sqrtPriceLimitX96
    ) external 
    {
        ArbitrageInterface(arbitrage).openPostion(amountOutMinimum, sqrtPriceLimitX96);
    }

    function closePostion(
        int256 amountOutMinimum,
        uint160 sqrtPriceLimitX96
    ) external 
    {
        ArbitrageInterface(arbitrage).closePostion(amountOutMinimum, sqrtPriceLimitX96);
    }

}
