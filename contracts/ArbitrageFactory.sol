pragma solidity ^0.8.0;

import "./ArbitrageUniV3.sol";
import "./Government.sol";
import "./ArbitrageStorage.sol";
import "./strategy.sol";

contract ArbitrageDaoFactory {

    address public price_oracle;
    address public router;
    struct ArbitrageDao
    {
        address dao;
        address arbitrage;
    }
        
    mapping(address => uint) public user_index;
    mapping(address => mapping(uint256 => ArbitrageDao)) public user_arbitragedao;
    
    uint256 public factory_count;
    mapping(uint256 => ArbitrageDao) public factory_arbitragedao;
    
    address public  arbitrage_storage;

    constructor(address _router)
    {
        router = _router;
    }

    function setArbitrageStorage(address _arbitrage_storage) external {
        arbitrage_storage = _arbitrage_storage;
    }

    function deploy(address _pool, uint _stock_index, uint256 _module) external {
        
        address strategy = address(new Strategy(_module, msg.sender)); 
        GovDao dao = new GovDao(strategy, msg.sender, address(this));
        address arbitrage = address(new ArbitrageUniV3(address(dao), router, _pool, _stock_index));
        
        ArbitrageDao memory arbitrage_info = ArbitrageDao(address(dao), arbitrage) ;

        dao.setArbitrage(arbitrage);
        uint256 index = user_index[msg.sender];
        index = index + 1;
        user_index[msg.sender] = index;
        user_arbitragedao[msg.sender][index] = arbitrage_info;
        factory_count = factory_count +1;
        factory_arbitragedao[factory_count] = arbitrage_info; 
    }
}
