from scripts.helpful_scripts import find_contract, get_params,get_account, filter_event_log,buile_filter_event
import sys

def test_contract_event():
    print("event")
    find, price_oracle = find_contract("PriceOracle")
    filter_event_log(price_oracle, "updatePrice",1229718 ,"latest")
    
  
def test_contract_log():
   # print("test ")
   print("log")

    
