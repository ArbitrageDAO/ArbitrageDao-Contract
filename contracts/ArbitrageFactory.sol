pragma solidity ^0.8.0;

import "./ArbitrageUniV3.sol";
import "./Government.sol";
import "./ArbitrageStorage.sol";

contract ArbitrageDaoFactory {

    address public price_oracle;
    address public router;

    struct Arbitrage{
        address[] all_arbitrage;

    }
    
    struct DAO{
        address[] all_dao;
    }

    mapping(address => Arbitrage) public  arbitrage_info;

    mapping(address => DAO) public dao_info;

    mapping(address => address) public arbitrageddao_owner;

    mapping(address => uint256) public arbitrage_index;

    mapping(address => uint256) public dao_index;
    
    address public  arbitrage_storage;

    constructor(address _router)
    {
        router = _router;
    }

    function setArbitrageStorage(address _arbitrage_storage) external {
        arbitrage_storage = _arbitrage_storage;
    }

    function deployUniV3(address _pool, uint _stock_index, address dao) public returns (address) {
        address arbitrage;
        arbitrage = address(new ArbitrageUniV3(dao, router, _pool, _stock_index));
        arbitrageddao_owner[arbitrage] = msg.sender;
        Arbitrage storage user_arbitrage =  arbitrage_info[msg.sender];
        user_arbitrage.all_arbitrage.push(arbitrage);
        arbitrage_info[msg.sender] = user_arbitrage;
        return arbitrage;
    }
}
