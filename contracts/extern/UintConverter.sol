pragma solidity ^0.8.0;

library UintConverter {
    // 将uint160转化为uint32数组
    function toUint32Array(uint160 value) public pure returns (uint32[] memory) {
        uint32[] memory result = new uint32[](5);

        // 将uint160值的前4个字节转化为uint32
        uint32 first = uint32(value >> 128);
        result[0] = first;

        // 将uint160值的第5-8个字节转化为uint32
        uint32 second = uint32(value >> 96);
        result[1] = second;

        // 将uint160值的第9-12个字节转化为uint32
        uint32 third = uint32(value >> 64);
        result[2] = third;

        // 将uint160值的第13-16个字节转化为uint32
        uint32 fourth = uint32(value >> 32);
        result[3] = fourth;

        // 将uint160值的最后4个字节转化为uint32
        uint32 fifth = uint32(value);
        result[4] = fifth;

        return result;
    }

    // 将int56转化为uint256数组
    function convertToInt(int56[] memory intArray) public pure returns (uint256 result) {
        bytes memory encodedInts = abi.encodePacked(intArray);
        assembly {
          result := mload(add(encodedInts, 32))
        }
    }



}
