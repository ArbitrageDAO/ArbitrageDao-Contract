from scripts.helpful_scripts import find_contract, get_params,get_account,contract_from_abi,get_wallet
import sys
from brownie import network

def test_createdao():
    # Arrange
    print("test factory create ", file=sys.stderr)
    owner_account = get_account()
    find, factory = find_contract("ArbitrageDaoFactory")
    btc = "0x1C2f71a40E7448Dd578C752b570D676284004048"
    usdc = "0x9191806b17D80546013bB6dAB6e9709e778Bb130"
    pool = ""
    stock_index = get_params("stock_index")
    find, gov_dao = find_contract("GovDao")
    tx = factory.deployUniV3(pool, stock_index, gov_dao, {"from": owner_account})
    tx.wait(1)

    arbitrage_univ3_btc_usdc_address = ""
    arbitrage_univ3_btc_usdc = contract_from_abi("ArbitrageUniV3", arbitrage_univ3_btc_usdc_address)

    amount = 10000000
    tx = arbitrage_univ3_btc_usdc.deposit(amount, {"from": owner_account})
    tx.wait(1)




