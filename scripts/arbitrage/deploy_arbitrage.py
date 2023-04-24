from brownie import StrategyPower, Strategy, GovDao, ArbitrageUniV3,ArbitrageDaoFactory,accounts, config, network
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
    print("deploy StrategyPower")
    factory = get_contract_address("factory")
    strategy_power = StrategyPower.deploy(
        account.address,
        account.address,
        {"from": account},
    )
    
    if (config["networks"][network.show_active()].get("verify", False)):
        strategy_power.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        StrategyPower.publish_source(strategy_power)
    else: 
        strategy_power.tx.wait(1)
    json_contract["StrategyPower"] = strategy_power.address


    print("deploy Strategy")
    module = get_params("module")
  
    strategy =  Strategy.deploy(
        module,
        account.address,
        {"from": account},
    )

    if (config["networks"][network.show_active()].get("verify", False)):
        strategy.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        Strategy.publish_source(strategy)
    else: 
        strategy.tx.wait(1)

    json_contract["Strategy"] = strategy.address

    print("deploy GovDao ")
    gov_dao =  GovDao.deploy(
        strategy.address,
        account.address,
        {"from": account},
    )

    if (config["networks"][network.show_active()].get("verify", False)):
        gov_dao.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        GovDao.publish_source(gov_dao)
    else: 
        gov_dao.tx.wait(1)

    json_contract["GovDao"] = strategy.address

    print("deploy ArbitrageUniV3")
    router = get_contract_address("router")
    pool = get_contract_address("pool")
    stock_index = get_params("stock_index")
    arbitrage_univ3 = ArbitrageUniV3.deploy(
        account.address,
        router,
        pool,
        stock_index,
        {"from": account},
    )
    
    if (config["networks"][network.show_active()].get("verify", False)):
        arbitrage_univ3.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        ArbitrageUniV3.publish_source(arbitrage_univ3)
    else: 
        arbitrage_univ3.tx.wait(1)

    json_contract["ArbitrageUniV3"] = arbitrage_univ3.address

    print("deploy ArbitrageDaoFactory")
    router = get_contract_address("router")
    pool = get_contract_address("pool")
    stock_index = get_params("stock_index")
    arbitrage_univ3 = ArbitrageDaoFactory.deploy(
        {"from": account},
    )
    
    if (config["networks"][network.show_active()].get("verify", False)):
        arbitrage_univ3.tx.wait(BLOCK_CONFIRMATIONS_FOR_VERIFICATION)
        ArbitrageUniV3.publish_source(arbitrage_univ3)
    else: 
        arbitrage_univ3.tx.wait(1)

    json_contract["ArbitrageDaoFactory"] = arbitrage_univ3.address


def main():
    deploy_All()
    save_file = get_params("save")
    with open(save_file, "w") as f:
        json.dump(json_contract, f, indent=4)
    return 0
