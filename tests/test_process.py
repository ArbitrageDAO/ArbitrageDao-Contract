from scripts.helpful_scripts import find_contract, get_params,get_account,contract_from_abi,get_wallet
import sys


def test_createdao():
    # Arrange
    from brownie.network import priority_fee
    priority_fee("2 gwei")
    print("test factory create ", file=sys.stderr)
    owner_account = get_account()
    find, factory = find_contract("ArbitrageDaoFactory")
    btc = "0x1C2f71a40E7448Dd578C752b570D676284004048"
    usdc = "0x9191806b17D80546013bB6dAB6e9709e778Bb130"
    pool = "0x1C2f71a40E7448Dd578C752b570D676284004048"
    stock_index = 0
    module = 0
    tx = factory.deploy(pool, stock_index, module, {"from": owner_account})
    tx.wait(1)


def test_listArbitrageDao():
    from brownie.network import priority_fee
    priority_fee("2 gwei")
    print("test factory create ", file=sys.stderr)
    owner_account = get_account()
    find, factory = find_contract("ArbitrageDaoFactory")
    index = factory.user_index(owner_account)
    for step in range(0,index):
        print("user index: %d"%(step))
        arbitrage_dao = factory.user_arbitragedao(owner_account,step)
        print(arbitrage_dao)
    for step in range(0,index):
        index = factory.factory_count()
        print("factory index: %d"%(step))
        arbitrage_dao = factory.factory_arbitragedao(step)
        print(arbitrage_dao)

def test_listPart():
    from brownie.network import priority_fee
    priority_fee("2 gwei")
    print("test factory create ", file=sys.stderr)
    owner_account = get_account()
    find, factory = find_contract("ArbitrageDaoFactory")
    index = factory.user_index(owner_account)
    for step in range(1,index):
        print("user index: %d"%(step))
        arbitrage_dao = factory.user_arbitragedao(owner_account,step)
        print(arbitrage_dao)
        find, arbitrage_univ3 = contract_from_abi("ArbitrageUniV3", arbitrage_dao[1])
        print(arbitrage_univ3.router())

def test_listUnPart():
    from brownie.network import priority_fee
    priority_fee("2 gwei")
    print("test factory create ", file=sys.stderr)
    owner_account = get_account()
    find, factory = find_contract("ArbitrageDaoFactory")
    index = factory.user_index(owner_account)
    for step in range(1,index):
        print("user index: %d"%(step))
        arbitrage_dao = factory.user_arbitragedao(owner_account,step)
        print(arbitrage_dao)
        find,arbitrage_univ3 = contract_from_abi("ArbitrageUniV3", arbitrage_dao[1])
        print(arbitrage_univ3.router())

