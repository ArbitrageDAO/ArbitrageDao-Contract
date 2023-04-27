pragma solidity ^0.8.0;

import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol';
import '@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol';
import './interface/IArbitrage.sol';
import './extern/Manageable.sol';
import "./extern/SafeMath.sol";
import "./extern/SafeERC20.sol";

contract ArbitrageUniV3 is IArbitrage, Manageable{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    address public  router;
    address public pool;
    mapping(address => uint256) public shares;
    uint256 public close_stock;
    uint256 public org_stock;
    uint256 public stock_index;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event Swap(address indexed user, address indexed fromToken, address indexed toToken, uint256 amountIn, uint256 amountOut);

    constructor(
        address _manager,
        address _router,
        address _pool,
        uint256 _stock_index
    )Ownable(msg.sender)
      Manageable(_manager)
    {
        require(_stock_index == 0 || _stock_index == 0, "stock in pool must be zero or one.");
        router = _router;
        pool = _pool;
        stock_index = _stock_index;
        /*if (_stock_index == 0 )
        {
            stock_token = IUniswapV3Pool(pool).token0();
        }
        else
        {
            stock_token = IUniswapV3Pool(pool).token1();
        }*/
    }

    function getStock() private view returns(address ){
        address stock = IUniswapV3Pool(pool).token0();
        if (stock_index == 1 )
        {
            stock = IUniswapV3Pool(pool).token1();
        }   
        return stock;
    } 

    function getMoney() private view returns(address){
        address money = IUniswapV3Pool(pool).token1();
        if (stock_index == 1 )
        {
            money = IUniswapV3Pool(pool).token0();
        }   
        return money;
    } 

    function deposit(uint256 amount) external override payable returns (uint256 depositAmount) {
        shares[msg.sender] += amount;
        org_stock += msg.value;
        address stock = getStock();
        IERC20(stock).approve(address(this), amount);
        IERC20(stock).safeTransferFrom(msg.sender, address(this), amount);
        emit Deposit(msg.sender, amount);
        return amount;
    }

    function withdraw() external override returns (uint256 withdrawAmount){
        uint256 share = shares[msg.sender];
        require(share > 0, 'Arbitrage: insufficient balance');
        uint256 amount = share.mul(close_stock).div(org_stock);
        address stock = getStock();
        IERC20(stock).safeTransfer(msg.sender, amount);
        emit Withdraw(msg.sender, amount);

        return amount;
    }

    function openPostion(
        uint256 amountOutMinimum,
        uint160 sqrtPriceLimitX96
    ) external override onlyManager {
        
        require(amountOutMinimum > 0, "Invalid minimum output amount");
        address stock = getStock();
        address money = getStock();
        uint24 fee = IUniswapV3Pool(pool).fee();

        // Perform swap
        ISwapRouter(router).exactInputSingle(
            ISwapRouter.ExactInputSingleParams(
                stock,
                money,
                fee,
                address(this),
                block.timestamp,
                uint256(org_stock),
                uint256(amountOutMinimum),
                sqrtPriceLimitX96
            )
        );
    }

    function closePostion(
        uint256 amountOutMinimum,
        uint160 sqrtPriceLimitX96
    ) external override onlyManager {
        
        require(amountOutMinimum > 0, "Invalid minimum output amount");
        address stock = getStock();
        address money = getStock();
        uint24 fee = IUniswapV3Pool(pool).fee();
        // Perform swap
        ISwapRouter(router).exactInputSingle(
            ISwapRouter.ExactInputSingleParams(
                money,
                stock,
                fee,
                address(this),
                block.timestamp,
                uint256(IERC20(money).balanceOf(address(this))),
                uint256(amountOutMinimum),
                sqrtPriceLimitX96
            )
        );
    }

}

        