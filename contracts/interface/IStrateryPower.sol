pragma solidity ^0.8.0;
interface StrategyPowerInterface {
    function resolve(uint256 proposal) external  returns (bool);

    function vote(uint256 proposal) external returns (bool);

    function injectPower(address user, uint256 power) external;

}

        