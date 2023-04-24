pragma solidity ^0.8.0;
interface IStrategy {
   function active(uint256 proposal) external returns (bool);
}

        