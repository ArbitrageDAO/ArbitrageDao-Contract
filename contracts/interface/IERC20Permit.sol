pragma solidity ^0.8.0;

interface IERC20Permit {
    // 获取代币的名称
    function name() external view returns (string memory);

    // 获取代币的符号
    function symbol() external view returns (string memory);

    // 获取代币的小数位数
    function decimals() external view returns (uint8);

    // 获取代币的总发行量
    function totalSupply() external view returns (uint256);

    // 获取指定地址的余额
    function balanceOf(address _owner) external view returns (uint256);

    // 从调用者的地址向指定地址转移指定数量的代币，支持permit签名
    function transferWithPermit(address _to, uint256 _value, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) external returns (bool);

    // 从指定地址向另一个地址转移指定数量的代币，支持permit签名
    function transferFromWithPermit(address _from, address _to, uint256 _value, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) external returns (bool);

    // 授权指定地址可以从调用者的地址转移指定数量的代币，支持permit签名
    function approveWithPermit(address _spender, uint256 _value, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) external returns (bool);

    // 获取指定地址可以从调用者的地址转移的代币数量
    function allowance(address _owner, address _spender) external view returns (uint256);

    // 获取指定地址的nonce值
    function nonces(address _owner) external view returns (uint256);

    // 签名方法
    function permit(address _owner, address _spender, uint256 _value, uint256 _deadline,uint8 v,bytes32 r,bytes32 s) external view returns (bool);

    // 代币转移时触发的事件
    event transfer(address indexed _from, address indexed _to, uint256 _value);

    // 授权时触发的事件
    event approval(address indexed _owner, address indexed _spender, uint256 _value);

}
