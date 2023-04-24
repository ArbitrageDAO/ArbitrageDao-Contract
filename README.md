# build
pip install eth-brownie
## init package
uniswap v3
chainlink


# deploy
## weshare-dev
brownie.exe  run .\scripts\arbitrage\deploy_arbitrage.py --network=eth-dev
brownie.exe  run .\scripts\arbitrage\deploy_arbitrage_mock.py --network=eth-dev
## weshare-ploy
brownie.exe  run .\scripts\arbitrage\deploy_arbitrage.py --network=polygon-weshare

## goerli-weshare
brownie.exe  run .\scripts\arbitrage\deploy_arbitrage.py --network=goerli-weshare
brownie.exe  run .\scripts\arbitrage\deploy_arbitrage_mock.py --network=goerli-weshare
# test
## all
brownie.exe test  --network eth-dev
## single
brownie.exe test  .\tests\test_process.py  -s  --network eth-dev
brownie.exe test  .\tests\test_process.py::test_dao -s --network eth-dev
## mark
-s is printed