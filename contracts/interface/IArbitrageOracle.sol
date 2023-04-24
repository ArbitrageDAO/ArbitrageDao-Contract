pragma solidity ^0.8.0;
interface IArbitrageOracle {
    function getLinkPrice(address strategy) external returns(uint256);

    function getUniV3Price(address strategy) external returns(uint256);
}

        