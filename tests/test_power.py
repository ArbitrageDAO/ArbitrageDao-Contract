from scripts.helpful_scripts import find_contract, get_params,get_account, contract_from_abi
import sys

def test_contract_owner():
    # Arrange
    print("test contract onwer", file=sys.stderr)
    owner_account = get_account()
    find, price_oracle = find_contract("MockPriceOracleUniswapV3")
    assert price_oracle.owner() == owner_account.address

    find, yield_uniswapv3 = find_contract("YieldUniswapV3")
    assert yield_uniswapv3.owner() == owner_account.address

    btc = get_params("BTC")
    usdc = get_params("USDC")

    market = price_oracle.getMarketHash(btc, usdc)
    btc_usdc_yield = yield_uniswapv3.market_yield(market)

    print(btc_usdc_yield)
    print(btc_usdc_yield[3])
    
    find, yield_storage = contract_from_abi("YieldStorage", btc_usdc_yield[3])
    print(yield_storage)
    assert yield_storage.owner() == owner_account.address
    assert yield_storage.manager() == yield_uniswapv3.address
 


     
    

    
