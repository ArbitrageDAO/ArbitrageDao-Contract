pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol";
import "./extern/UintConverter.sol";
import './interface/IArbitrageOracle.sol';
import './extern/Manageable.sol';

contract ArbitragePrice is IArbitrageOracle, Ownable {
    struct Pool {
        address tokenA;
        address tokenB;
        address aggregator;
        uint24 fee;
    }
    address public constant uniswapV3SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address public constant pancakeswapV3SwapRouter = 0x1C232F01118CB8B424793ae03F870aa7D0ac7f77;
    mapping(address => Pool) public prices;
    address public univ3_router; 
    address public aggregator;
    constructor(address _univ3_router, address _aggregator)Ownable(msg.sender)
    {
        univ3_router = _univ3_router;
        aggregator = _aggregator;
    }

    function setPool(address strategy, address tokenA, address tokenB, uint24 fee) external onlyOwner {
        require(strategy != address(0), "ArbitragePrice: strategy cann't be zero address");
        require(tokenA != address(0), "ArbitragePrice: tokenA cann't be zero address");
        require(tokenB != address(0), "ArbitragePrice: tokenB cann't be zero address");
        Pool memory new_pool;
        new_pool.tokenA = tokenA;
        new_pool.tokenB = tokenB;
        new_pool.fee = fee;
        prices[strategy] = new_pool;
    }

    function getLinkPrice(address strategy) external override returns(uint256) {
        Pool memory pool = prices[strategy];
        AggregatorV3Interface priceFeed = AggregatorV3Interface(pool.aggregator);
        (uint80 price, int256 timestamp, , , ) = priceFeed.latestRoundData();
        return uint256(price);
    }

    function getUniV3Price(address strategy) external override returns(uint256) {
        Pool memory pool = prices[strategy];
        address tokenA = pool.tokenA;
        address tokenB = pool.tokenB;
        uint24 fee = pool.fee;

        IUniswapV3Pool v3Pool = IUniswapV3Pool(IUniswapV3Factory(uniswapV3SwapRouter).getPool(tokenA, tokenB, fee));
        (uint160 sqrtRatioX96, , , , , , ) = v3Pool.slot0();
        uint32[] memory convertedSqrtRatioX96 = UintConverter.toUint32Array(sqrtRatioX96);
        (int56[] memory originprice, ) = v3Pool.observe(convertedSqrtRatioX96);
        uint256 price = UintConverter.convertToInt(originprice);

        return price;
    }

    function getPancakeV3Price(address strategy) external override returns(uint256) {
        Pool memory pool = prices[strategy];
        address tokenA = pool.tokenA;
        address tokenB = pool.tokenB;

        IUniswapV3Pool v3Pool = IUniswapV3Pool(IUniswapV3Factory(pancakeswapV3SwapRouter).getPool(tokenA, tokenB, 3000));
        (uint160 sqrtRatioX96, , , , , , ) = v3Pool.slot0();
        uint32[] memory convertedSqrtRatioX96 = UintConverter.toUint32Array(sqrtRatioX96);
        (int56[] memory originprice, ) = v3Pool.observe(convertedSqrtRatioX96);
        uint256 price = UintConverter.convertToInt(originprice);

        return price;
    }

}