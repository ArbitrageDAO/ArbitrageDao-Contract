pragma solidity ^0.8.0;

interface IERC20Permit {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address _owner) external view returns (uint256);

    function transferWithPermit(address _to, uint256 _value, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) external returns (bool);

    function transferFromWithPermit(address _from, address _to, uint256 _value, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) external returns (bool);

    function approveWithPermit(address _spender, uint256 _value, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) external returns (bool);

    function allowance(address _owner, address _spender) external view returns (uint256);

    function nonces(address _owner) external view returns (uint256);

    function permit(address _owner, address _spender, uint256 _value, uint256 _deadline,uint8 v,bytes32 r,bytes32 s) external view returns (bool);

    event transfer(address indexed _from, address indexed _to, uint256 _value);

    event approval(address indexed _owner, address indexed _spender, uint256 _value);

}
