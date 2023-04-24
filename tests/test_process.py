from scripts.helpful_scripts import find_contract, get_params,get_account,contract_from_abi,get_wallet
import sys
from brownie import network

def get_period(market_yield):
    height = network.chain.height
    print("current block height: %d"%height)
    begin_block = market_yield[1]
    interval = market_yield[0]
    bet_period = 1
    if height > begin_block :
        bet_period = int((height - begin_block)/interval) + 2
    settle_period = bet_period - 1
    return settle_period, bet_period

def set_period_price(market, yield_uniswapv3, yield_storage, period):
    market_yield = yield_uniswapv3.market_yield(market)  
    owner_account = get_account()
    find, bpt = contract_from_abi("BPT", get_params("BPT"))
    owner_balance = bpt.balanceOf(owner_account)
    print(owner_balance)
    flushReward = yield_uniswapv3.flushReward()
    print(flushReward)
    print(bpt.balanceOf(yield_uniswapv3))
    end_block = period*market_yield[0] + market_yield[1]
    price = yield_storage.getPrice(end_block)
    # check price is zero
    ret = True
    if price == 0:
        try:
            tx = yield_uniswapv3.flushPrice(market, 
                                        end_block,
                                        {"from": owner_account})
            tx.wait(1)
            assert end_block < network.chain.height
            update_reward = bpt.balanceOf(owner_account)
            print(update_reward)
        except Exception as err:
            ret = True
            print(err)
        #assert update_reward == owner_balance + flushReward
    else :
    # check price is not zero
        try:
            tx = yield_uniswapv3.flushPrice(market, 
                                        end_block,
                                        {"from": owner_account})
            assert False
            tx.wait(1)
        except Exception as err:
          ret = False
          print(err)
    return ret

def test_contract_priceOracle():
    # Arrange
    print("test price oracle", file=sys.stderr)
    owner_account = get_account()
    find, price_oracle = find_contract("MockPriceOracleUniswapV3")
    find, yield_uniswapv3 = find_contract("YieldUniswapV3")

    btc = get_params("BTC")
    usdc = get_params("USDC")
    market = price_oracle.getMarketHash(btc, usdc)
    btc_usdc_yield = yield_uniswapv3.market_yield(market)  
    find, yield_storage = contract_from_abi("YieldStorage", btc_usdc_yield[3])

    price = yield_storage.getPrice(btc_usdc_yield[1])
    # check price is zero
    if price == 0:
        tx = yield_uniswapv3.flushPrice(market, 
                                        btc_usdc_yield[1],
                                        {"from": owner_account})
        tx.wait(1)
        update_price = yield_storage.getPrice(btc_usdc_yield[1])
        assert(update_price > 0 )
    else :
    # check price is not zero
        try:
            tx = yield_uniswapv3.flushPrice(market, 
                                        btc_usdc_yield[1],
                                        {"from": owner_account})
            assert False
            tx.wait(1)
        except Exception as err:
          print(err)
    
    # check future price 
    try: 
        tx = yield_uniswapv3.flushPrice(market, 
                                        network.chain.height + 1,
                                        {"from": owner_account})
        assert False
        tx.wait(1)
    except Exception as err:
          print(err)
    # check period price
    try: 
        tx = yield_uniswapv3.flushPrice(market, 
                                        network.chain.height,
                                        {"from": owner_account})
        assert False
        tx.wait(1)
    except Exception as err:
          print(err)
    btc_usdc_yield = yield_uniswapv3.market_yield(market)
    settle_period,bet_period = get_period(btc_usdc_yield)
    assert network.chain.height < settle_period*btc_usdc_yield[0] + btc_usdc_yield[1]
    assert network.chain.height >= (settle_period-1)*btc_usdc_yield[0] + btc_usdc_yield[1]
    for i in range (bet_period):
        print("\nflush price period: %d "% (bet_period - i - 1))
        print(bet_period)
        ret = set_period_price(market, yield_uniswapv3, yield_storage, bet_period - i - 1)
        if ret == False:
            break;

def bet_period_process(market, yield_uniswapv3, yield_storage, period):
    bet_account = get_wallet("test_key")
    find, bpt = contract_from_abi("BPT", get_params("BPT"))
    bet_balance = bpt.balanceOf(bet_account)
    print("\n\nbet pervious btp:  %d "%(bet_balance))
    ''' mapping(uint256=>mapping(address=>uint256)) public address_long_chip;
  mapping(uint256=>mapping(address=>uint256)) public address_short_chip;
  mapping(uint256=>uint256) public block_price;
  mapping(uint256=>mapping(bool=>uint256)) public total_chip;
  mapping(uint256=>mapping(bool=>uint256)) public total_balance;
  '''

    long_total_chip = yield_storage.total_chip(period, True)
    short_total_chip = yield_storage.total_chip(period, False)
    print("total chip long: %d, short: %d"%(long_total_chip, short_total_chip))

    long_total_balance = yield_storage.total_balance(period, True)
    short_total_balance = yield_storage.total_balance(period, False)
    print("total balance long: %d, short: %d"%(long_total_balance, short_total_balance))

    long_total_chip_address = yield_storage.address_long_chip(period, bet_account)
    short_total_chip_address = yield_storage.address_short_chip(period, bet_account)
    print("%s chip long: %d, short: %d"%(bet_account, long_total_chip_address, short_total_chip_address))

    try: 
        tx = yield_uniswapv3.bet(market, period, 10, True,{"from": bet_account, "value":100000})
        bet_balance = bpt.balanceOf(bet_account)
        print("\n\nbet after long btp: %d "%(bet_balance))
        tx.wait(1)
    except Exception as err:
        print(err)

    long_total_chip = yield_storage.total_chip(period, True)
    short_total_chip = yield_storage.total_chip(period, False)
    print("total chip long: %d, short: %d"%(long_total_chip, short_total_chip))

    long_total_balance = yield_storage.total_balance(period, True)
    short_total_balance = yield_storage.total_balance(period, False)
    print("total balance long: %d, short: %d"%(long_total_balance, short_total_balance))

    long_total_chip_address = yield_storage.address_long_chip(period, bet_account)
    short_total_chip_address = yield_storage.address_short_chip(period, bet_account)
    print("%s chip long: %d, short: %d"%(bet_account, long_total_chip_address, short_total_chip_address))

    try: 
        tx = yield_uniswapv3.bet(market, period, 10, False,{"from": bet_account, "value":200000})
        bet_balance = bpt.balanceOf(bet_account)
        print("\n\nbet after short btp: %d "%(bet_balance))
        tx.wait(10)
    except Exception as err:
        print(err)
    long_total_chip = yield_storage.total_chip(period, True)
    short_total_chip = yield_storage.total_chip(period, False)
    print("total chip long: %d, short: %d"%(long_total_chip, short_total_chip))

    long_total_balance = yield_storage.total_balance(period, True)
    short_total_balance = yield_storage.total_balance(period, False)
    print("total balance long: %d, short: %d"%(long_total_balance, short_total_balance))

    long_total_chip_address = yield_storage.address_long_chip(period, bet_account)
    short_total_chip_address = yield_storage.address_short_chip(period, bet_account)
    print("%s chip long: %d, short: %d"%(bet_account, long_total_chip_address, short_total_chip_address))

    try: 
        tx = yield_uniswapv3.claim(market, period, {"from": bet_account})
        bet_balance = bpt.balanceOf(bet_account)
        print("\n\nclaim after btp: %d "%(bet_balance))
        tx.wait(1)
    except Exception as err:
        print(err)

    long_total_chip = yield_storage.total_chip(period, True)
    short_total_chip = yield_storage.total_chip(period, False)
    print("total chip long: %d, short: %d"%(long_total_chip, short_total_chip))

    long_total_balance = yield_storage.total_balance(period, True)
    short_total_balance = yield_storage.total_balance(period, False)
    print("total balance long: %d, short: %d"%(long_total_balance, short_total_balance))

    long_total_chip_address = yield_storage.address_long_chip(period, bet_account)
    short_total_chip_address = yield_storage.address_short_chip(period, bet_account)
    print("%s chip long: %d, short: %d"%(bet_account, long_total_chip_address, short_total_chip_address))


def test_claim():
    print("test contract optionYield", file=sys.stderr)
    # Arrange
    print("test contract onwer", file=sys.stderr)
    owner_account = get_account()
    find, price_oracle = find_contract("MockPriceOracleUniswapV3")
    find, yield_uniswapv3 = find_contract("YieldUniswapV3")

    btc = get_params("BTC")
    usdc = get_params("USDC")
    market = price_oracle.getMarketHash(btc, usdc)
    btc_usdc_yield = yield_uniswapv3.market_yield(market)
    print(btc_usdc_yield)
 
    find, yield_storage = contract_from_abi("YieldStorage", btc_usdc_yield[3])
    #chip = yield_storage.address_long_chip(owner_account, True)

    #settle_period,bet_period = get_period(btc_usdc_yield)

    try: 
        tx = yield_uniswapv3.claim(market, 1773, {"from": owner_account})
        tx.wait(1)
    except Exception as err:
          print(err)



def test_contract_YieldUniswapV3():
    print("test contract optionYield", file=sys.stderr)
    # Arrange
    print("test contract onwer", file=sys.stderr)
    owner_account = get_account()
    find, price_oracle = find_contract("MockPriceOracleUniswapV3")
    find, yield_uniswapv3 = find_contract("YieldUniswapV3")

    btc = get_params("BTC")
    usdc = get_params("USDC")
    market = price_oracle.getMarketHash(btc, usdc)
    btc_usdc_yield = yield_uniswapv3.market_yield(market)
    print(btc_usdc_yield)
 
    find, yield_storage = contract_from_abi("YieldStorage", btc_usdc_yield[3])

    settle_period,bet_period = get_period(btc_usdc_yield)
    print(settle_period)
    print(bet_period)
    #bet(bytes32 market, uint256 period, uint discount, bool long) 
    
    try: 
        tx = yield_uniswapv3.bet(market, settle_period, 10, True,{"from": owner_account, "value":100000})
        assert False
        tx.wait(1)
    except Exception as err:
          print(err)

    try: 
        tx = yield_uniswapv3.bet(market, settle_period - 1, 10, True,{"from": owner_account, "value":100000})
        assert False
        tx.wait(1)
    except Exception as err:
          print(err)

    try: 
        tx = yield_uniswapv3.bet(market, bet_period, 10, True,{"from": owner_account, "value":100000})
        tx.wait(1)
    except Exception as err:
          print(err)
          assert False
          
    try: 
        tx = yield_uniswapv3.bet(market, bet_period + 1, 10, True,{"from": owner_account, "value":100000})
        assert False
        tx.wait(1)
    except Exception as err:
          print(err)


    bet_period_process(market, yield_uniswapv3, yield_storage, bet_period)
         

def test_reset_market():
    print("test contract onwer", file=sys.stderr)
    owner_account = get_account()
    find, price_oracle = find_contract("MockPriceOracleUniswapV3")
    find, yield_uniswapv3 = find_contract("YieldUniswapV3")

    btc = get_params("BTC")
    usdc = get_params("USDC")
    market = price_oracle.getMarketHash(btc, usdc)
    btc_usdc_yield = yield_uniswapv3.market_yield(market)
    print(btc_usdc_yield)
    print("init market yield")
    begin_block = network.chain.height + 10
    #interval = get_params("interval")
    valuation = 1000000000
    #initMarket(bytes32 market, uint begin_block, uint interval, uint128 valuation)
    tx = yield_uniswapv3.resetMarket(market, 
                                    begin_block,
                                    20,
                                    valuation, 
                                    {"from": owner_account})
    tx.wait(1) 
 

