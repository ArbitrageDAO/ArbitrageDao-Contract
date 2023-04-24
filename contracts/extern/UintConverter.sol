pragma solidity ^0.8.0;

library UintConverter {

    function toUint32Array(uint160 value) public pure returns (uint32[] memory) {
        uint32[] memory result = new uint32[](5);

        uint32 first = uint32(value >> 128);
        result[0] = first;

        uint32 second = uint32(value >> 96);
        result[1] = second;

        uint32 third = uint32(value >> 64);
        result[2] = third;

        uint32 fourth = uint32(value >> 32);
        result[3] = fourth;

        uint32 fifth = uint32(value);
        result[4] = fifth;

        return result;
    }

    function convertToInt(int56[] memory intArray) public pure returns (uint256 result) {
        bytes memory encodedInts = abi.encodePacked(intArray);
        assembly {
          result := mload(add(encodedInts, 32))
        }
    }



}
