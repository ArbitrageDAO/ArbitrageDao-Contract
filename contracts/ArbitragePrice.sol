pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapQuoter.sol";
import './extern/Manageable.sol';

contract ArbitragePrice is ArbitragePriceInterface, Ownable {
    struct Pool {
        address tokenA;
        address tokenB;
    }
     // UNISWAP V3 的 SwapRouter 
    //address public constant uniswapV3SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    // PANCANKESWAP V3 的 SwapRouter 
    //address public constant pancakeswapV3SwapRouter = 0x1C232F01118CB8B424793ae03F870aa7D0ac7f77;
    mapping(address => Pool) public prices;
    address public univ3_router; 
    address public aggregator;
    constructor(address _univ3_router, address _aggregator)Ownable(msg.sender)
    {
        univ3_router = _univ3_router;
        aggregator = _aggregator;
    }

    function setPool(address strategy, address tokenA, address tokenB) external onlyOwner {
        require(strategy != address(0), "ArbitragePrice: strategy cann't be zero address");
        require(tokenA != address(0), "ArbitragePrice: tokenA cann't be zero address");
        require(tokenB != address(0), "ArbitragePrice: tokenB cann't be zero address");
        Pool new_pool;
        new_pool.tokenA = tokenA;
        new_pool.tokenB = tokenB;
        prices[strategy] = new_pool;
    }


    function getLinkPrice(address strategy) external override returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(aggregator);

    }

    function getUniV3Price(address strategy) external override returns(uint256) {

    }


   
}
