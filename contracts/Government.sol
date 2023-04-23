pragma solidity ^0.8.0;
import './interface/IArbitrage.sol';
import './interface/StrategyInterface.sol';
import './extern/Manageable.sol';
contract GovDao is Ownable {
    address public arbitrage;
    address public strategy;
    uint256 public propurse;
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
        StrategyInterface(strategy).active(propurse);
        ArbitrageInterface(arbitrage).openPostion(amountOutMinimum, sqrtPriceLimitX96);
        propurse = propurse+1;
    }

    function closePostion(
        int256 amountOutMinimum,
        uint160 sqrtPriceLimitX96
    ) external 
    {
        StrategyInterface(strategy).active(propurse);
        ArbitrageInterface(arbitrage).closePostion(amountOutMinimum, sqrtPriceLimitX96);
        propurse = propurse+1;
    }

}
