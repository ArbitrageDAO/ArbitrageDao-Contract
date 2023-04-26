pragma solidity ^0.8.0;
interface IArbitrage {
    function deposit(uint256 amount) external payable  returns (uint256);

    function withdraw() external returns (uint256);

    function openPostion(uint256 amountOutMinimum, uint160 sqrtPriceLimitX96) external ;

    function closePostion(uint256 amountOutMinimum, uint160 sqrtPriceLimitX96) external ;
}

        