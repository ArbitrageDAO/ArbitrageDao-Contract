pragma solidity ^0.8.0;
interface ArbitrageOracleInterface {
    function getLinkPrice(address strategy) external returns(uint256);

    unction getUniV3Price(address strategy) external returns(uint256);
}

        