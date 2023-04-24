pragma solidity ^0.8.0;

// 引入其他智能合约
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "./extern/UintConverter.sol";

contract ArbitrageStorage {
    using UintConverter for uint256;
    using UintConverter for uint32[];

    // 存储价格的结构体
    struct Price {
        uint256 price;  // 价格
        uint256 timestamp;  // 时间戳
    }

    // 价格映射表
    mapping(address => mapping(address => Price)) public prices;

    // 设置 UNISWAP V3 或 PANCANKESWAP V3 的价格
    function setPrice(address tokenA, address tokenB,address dexContractAddress) external {
        IUniswapV3Pool pool = IUniswapV3Pool(IUniswapV3Factory(dexContractAddress).getPool(tokenA, tokenB, 3000));
        (uint160 sqrtRatioX96, , , , , , ) = pool.slot0();
        uint32[] memory convertedSqrtRatioX96 = UintConverter.toUint32Array(sqrtRatioX96);
        (int56[] memory originprice, ) = pool.observe(convertedSqrtRatioX96);
        uint256 price = UintConverter.convertToInt(originprice);
        uint256 timestamp = block.timestamp;

        // 存储价格
        prices[tokenA][tokenB] = Price(price, timestamp);
    }

    // 设置chainLink价格
    function setChainlinkPrice(address tokenA, address tokenB, address aggregator) external {
        // 获取 AggregatorV3Interface 实例
        AggregatorV3Interface priceFeed = AggregatorV3Interface(aggregator);

        // 获取价格和时间戳
        (int256 price, int256 timestamp, , , ) = priceFeed.latestRoundData();

        // 存储价格
        prices[tokenA][tokenB] = Price(uint256(price), uint256(timestamp));
    }

    // 获取价格
    function getPrice(address tokenA, address tokenB) external view returns (uint256, uint256) {
        // 获取价格
        Price memory price = prices[tokenA][tokenB];
        require(price.timestamp > 0, "Price not found");

        // 返回价格和时间戳
        return (price.price, price.timestamp);
    }
}
