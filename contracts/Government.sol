pragma solidity ^0.8.0;
import './interface/IArbitrage.sol';
import './interface/IStrategy.sol';
import './extern/Manageable.sol';
contract GovDao is Manageable {
    address public arbitrage;
    address public strategy;
    uint256 public propurse;
    constructor(address _strategy, address onwer, address manager)Ownable(onwer) Manageable(manager){
        strategy = _strategy;
    }

    function setArbitrage(address _arbitrage) external onlyManager{
        arbitrage = _arbitrage;
    }

    function openPostion(
        uint256 amountOutMinimum,
        uint160 sqrtPriceLimitX96
    ) external 
    {
        IStrategy(strategy).active(propurse);
        IArbitrage(arbitrage).openPostion(amountOutMinimum, sqrtPriceLimitX96);
        propurse = propurse+1;
    }

    function closePostion(
        uint256 amountOutMinimum,
        uint160 sqrtPriceLimitX96
    ) external 
    {
        IStrategy(strategy).active(propurse);
        IArbitrage(arbitrage).closePostion(amountOutMinimum, sqrtPriceLimitX96);
        propurse = propurse+1;
    }


}
