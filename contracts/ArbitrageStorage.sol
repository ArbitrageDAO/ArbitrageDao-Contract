pragma solidity ^0.8.0;

// 引入其他智能合约
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapQuoter.sol";

contract ArbitrageStorage {
    // 存储价格的结构体
    struct Price {
        uint256 price;  // 价格
        uint256 timestamp;  // 时间戳
    }

    // 价格映射表
    mapping(address => mapping(address => Price)) public prices;

    // UNISWAP V3 的 SwapRouter 合约地址
    address public constant uniswapV3SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    // PANCANKESWAP V3 的 SwapRouter 合约地址
    address public constant pancakeswapV3SwapRouter = 0x1C232F01118CB8B424793ae03F870aa7D0ac7f77;

    // 设置 UNISWAP V3 或 PANCANKESWAP V3 的价格
    function setPrice(address tokenA, address tokenB) external {
        // 获取 SwapQuoter 实例
        ISwapQuoter quoter = ISwapQuoter(ISwapRouter(uniswapV3SwapRouter).quoteExactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: tokenA,
                tokenOut: tokenB,
                fee: 3000, // 0.3%
                recipient: address(this),
                deadline: block.timestamp + 300,
                amountIn: 1000,
                sqrtPriceLimitX96: 0
            })
        ).router);

        // 获取价格和时间戳
        (uint256 price, uint256 timestamp) = (quoter.getExactInputSingle(
            ISwapQuoter.ExactInputSingleParams({
                tokenIn: tokenA,
                tokenOut: tokenB,
                fee: 3000, // 0.3%
                recipient: address(this),
                deadline: block.timestamp + 300,
                amountIn: 1,
                sqrtPriceLimitX96: 0
            })
        ).amountOut, block.timestamp);

        // 存储价格
        prices[tokenA][tokenB] = Price(price, timestamp);
    }

    // 设置chainLink价格
    function setChainlinkPrice(address tokenA, address tokenB, address aggregator) external {
        // 获取 AggregatorV3Interface 实例
        AggregatorV3Interface priceFeed = AggregatorV3Interface(aggregator);

        // 获取价格和时间戳
        (uint256 price, uint256 timestamp, , ) = priceFeed.latestRoundData();

        // 存储价格
        prices[tokenA][tokenB] = Price(price, timestamp);
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
