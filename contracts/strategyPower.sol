pragma solidity ^0.8.0;
import './interface/IStrategyPower.sol';
import './extern/Manageable.sol';
contract StrategyPower is Manageable {
    mapping(address=>uint256) public address_power;
    mapping(uint256=>uint256) public vote_power;
    mapping(uint256=>mapping(address=>uint256)) public address_proposal_power;
    uint256 public pass = 5000;
    uint256 public total_power;
    constructor(address owner, address manager) Ownable(owner) Manageable(manager){
        
    }

    function resolve(uint256 proposal) external
    {   
       uint256 propuse_power = vote_power[proposal];
       uint rate = total_power*10000/propuse_power;
       require(propuse_power > rate, "StrategyPower: propuse power power must bigger than pass"); 
    }

    function vote(uint256 proposal) external 
    {
        uint256  power = address_power[msg.sender];
        require(power > 0, "StrategyPower: user power must bigger than zero");
        uint256 voted_power = address_proposal_power[proposal][msg.sender];
        require(voted_power == 0, "StrategyPower: voted power must be not used");
        address_proposal_power[proposal][msg.sender] = address_power[msg.sender];
        vote_power[proposal] = address_power[msg.sender];
    }

    function injectPower(address user, uint256 power) external onlyManager 
    {
        address_power[user] += power;
        total_power += power;
    }
    
}
