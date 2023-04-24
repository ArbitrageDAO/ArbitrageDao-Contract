from scripts.helpful_scripts import find_contract
from brownie import network

def test_check_contract():
    # Arrange
    find, price_oracle = find_contract("MockPriceOracleUniswapV3")
    print(find)
    print("price oracle")
    print(price_oracle)
    assert find == True
    assert price_oracle != None

    find, bpt = find_contract("BPT", True)
    print("price BPT")
    print(find)
    assert find == True
    assert bpt != None

    find, yield_uniswapv3 = find_contract("YieldUniswapV3")
    print(find)
    print("price yield uniswapv3")
    print(yield_uniswapv3)
    assert find == True
    assert yield_uniswapv3 != None

