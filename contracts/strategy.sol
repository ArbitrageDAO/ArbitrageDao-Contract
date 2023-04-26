pragma solidity ^0.8.0;
import './interface/IStrategy.sol';
import './interface/IStrategyPower.sol';
import './extern/Manageable.sol';
contract Strategy is Ownable {
    uint256 public module;
    address public power;
    uint256 public price;
    bool public long;
    address oracle;

    constructor(uint256 _module, address _owner)Ownable(_owner) {
        module = _module;
    }


    function setPower(address _power) external onlyOwner {
        power = _power;
    }

    function setPrice(uint _price, bool _long, address _oracle) external onlyOwner {
        price = _price;
        long = _long;
        oracle = _oracle;
    }


    function active(uint proposal) external returns (bool){
        if (module == 0)
        {
            require(msg.sender == owner(),"StrategyPower: module one must be owner");
        }
        
        if (module == 1)
        {
            IStrategyPower(power).resolve(proposal);
        }

        if (module == 2)
        {
            //uint link_price = orcle.getPrice(address(this));
            uint link_price;
            require(link_price >= price && long==true,"StrategyPower: link price must bigger than price in long" ); 
            require(link_price <= price && long==false,"StrategyPower: link price must smaller than price in short" );     
        }
        return true;
    }



}
