pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "./extern/UintConverter.sol";
import "./extern/Manageable.sol";

contract ArbitrageStorage {

    using UintConverter for uint256;
    using UintConverter for uint32[];

    struct Price {
        uint256 price; 
        uint256 timestamp;  
    }

    mapping(address => mapping(address => Price)) public prices;

    function setPrice(address tokenA, address tokenB,address dexContractAddress) external {
        IUniswapV3Pool pool = IUniswapV3Pool(IUniswapV3Factory(dexContractAddress).getPool(tokenA, tokenB, 3000));
        (uint160 sqrtRatioX96, , , , , , ) = pool.slot0();
        uint32[] memory convertedSqrtRatioX96 = UintConverter.toUint32Array(sqrtRatioX96);
        (int56[] memory originprice, ) = pool.observe(convertedSqrtRatioX96);
        uint256 price = UintConverter.convertToInt(originprice);
        uint256 timestamp = block.timestamp;

        prices[tokenA][tokenB] = Price(price, timestamp);
    }

    function setChainlinkPrice(address tokenA, address tokenB, address aggregator) external {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(aggregator);

        (uint80 price, int256 timestamp, , , ) = priceFeed.latestRoundData();

        prices[tokenA][tokenB] = Price(uint256(price), uint256(timestamp));
    }

    function getPrice(address tokenA, address tokenB) external view returns (uint256, uint256) {
        Price memory price = prices[tokenA][tokenB];
        require(price.timestamp > 0, "Price not found");

        return (price.price, price.timestamp);
    }

}
