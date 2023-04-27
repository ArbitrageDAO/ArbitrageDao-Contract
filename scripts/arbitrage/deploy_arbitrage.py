from brownie import ArbitrageDaoFactory,accounts, config, network
from brownie.network import priority_fee
priority_fee("2 gwei")
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
  
    print("deploy ArbitrageDaoFactory")
    router = get_contract_address("router")
    
    arbitrage_dao_factory = ArbitrageDaoFactory.deploy(
        router,
        {"from": account},
    )
    
    if (config["networks"][network.show_active()].get("verify", False)):
        arbitrage_dao_factory.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        ArbitrageDaoFactory.publish_source(arbitrage_dao_factory)
    else: 
        arbitrage_dao_factory.tx.wait(1)

    json_contract["ArbitrageDaoFactory"] = arbitrage_dao_factory.address
    pool = get_contract_address("pool")
    stock_index = get_params("stock_index")
    module = get_params("module")
    tx = arbitrage_dao_factory.deploy(pool, stock_index, module)
    tx.wait(1)



def main():
    deploy_All()
    save_file = get_params("save")
    with open(save_file, "w") as f:
        json.dump(json_contract, f, indent=4)
    return 0
