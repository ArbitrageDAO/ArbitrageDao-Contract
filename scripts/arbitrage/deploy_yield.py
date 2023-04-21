from brownie import PriceOracleUniswapV3, YieldUniswapV3, accounts, config, network
from scripts.helpful_scripts import (
    get_account,
    get_contract_address,
    get_params,
    find_contract
)
import time,json
json_contract = {}
def deploy_All():
    account = get_account()
    print("deploy Mock Price Oracle")
    factory = get_contract_address("factory")
    price_oracle = PriceOracleUniswapV3.deploy(
        factory,
        {"from": account},
    )
    
    if (config["networks"][network.show_active()].get("verify", False)):
        price_oracle.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        PriceOracleUniswapV3.publish_source(price_oracle)
    else: 
        price_oracle.tx.wait(1)
    json_contract["PriceOracleUniswapV3"] = price_oracle.address

    print("deploy Yield Uniswap V3")
    block_time = get_params("block_time")
    discount_token = get_params("BPT")
    yield_uniswapv3 =  YieldUniswapV3.deploy(
        price_oracle,
        discount_token,
        block_time,
        account.address,
        {"from": account},
    )

    if (config["networks"][network.show_active()].get("verify", False)):
        yield_uniswapv3.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        YieldUniswapV3.publish_source(yield_uniswapv3)
    else: 
        yield_uniswapv3.tx.wait(1)

    json_contract["YieldUniswapV3"] = yield_uniswapv3.address

    print("init market price oracle")
    share = get_params("BTC")
    money = get_params("USDC")
    fee = get_params("fee")
    tx = price_oracle.addMarket(share, money, fee, {"from": account})
    tx.wait(1) 
   
    print("init market yield")
    market = price_oracle.getMarketHash(share, money)
    begin_block = network.chain.height + 10
    interval = get_params("interval")
    valuation = 1000000000
    #initMarket(bytes32 market, uint begin_block, uint interval, uint128 valuation)
    tx = yield_uniswapv3.initMarket(market, 
                                    begin_block,
                                    interval,
                                    valuation, 
                                    {"from": account})
    tx.wait(1) 
    

    find, bpt_token = find_contract("BPT", True)
    minterAmount = get_params("minterAmount")
    tx = bpt_token.transfer(yield_uniswapv3, minterAmount,{"from": account})
    tx.wait(1)

def main():
    deploy_All()
    save_file = get_params("save")
    with open(save_file, "w") as f:
        json.dump(json_contract, f, indent=4)
    return 0
