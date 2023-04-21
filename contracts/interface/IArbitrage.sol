pragma solidity ^0.8.0;
interface ArbitrageInterface {
    function deposit(uint256 amount) external  returns (uint amount);

    function withdraw() external returns (uint);

    function openPostion(int256 amountOutMinimum, uint160 sqrtPriceLimitX96) external returns (uint);

    function closePostion(int256 amountOutMinimum, uint160 sqrtPriceLimitX96) external returns (uint);
}

        