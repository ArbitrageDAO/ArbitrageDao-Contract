pragma solidity ^0.8.0;
import './interface/IStrategyInterface.sol';
import './interface/IStrategyPowerInterface.sol';
import './extern/Manageable.sol';
contract Strategy is Ownable {
    int public module;
    address public power;
    uint256 public price;
    bool public long;
    address oracle;
    constructor(int _module, address owner)Ownable(onwer){
        module = _module;
    }


    function setPower(address _power) external onlyOnwer {
        power = _power;
    }

    function setPrice(uint _price, bool _long, address _oracle) external onlyOnwer {
        price = _price;
        long = _long;
        oracle = _oracle;
    }


    function active(int  proposal) external override returns (bool){
        if (module == 0)
        {
            require(msg.sender == owner(),"StrategyPower: module one must be owner");
        }
        
        if (module == 1)
        {
            StrategyPowerInterface(power).resolve();
        }

        if (module == 2)
        {
            uint link_price;//= orcle.getPrice(address(this));
            require(link_price >= price && long=true,"StrategyPower: link price must bigger than price in long" ); 
            require(link_price <= price && long=false,"StrategyPower: link price must smaller than price in short" );     
        }
        return true;
    }



}
