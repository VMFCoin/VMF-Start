#!/bin/bash
set -ex
usdc_address="0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913"
initCharityAddress="0xf521a4fE5910b4fb4A14C9546C2837D33bEc455d"
initTeamAddress="0xf521a4fE5910b4fb4A14C9546C2837D33bEc455d"
source .env
rpc_url=$BASE_RPC_URL
forge create --broadcast --rpc-url "$rpc_url" --private-key "$PRIVATE_KEY" \
    src/VmfCoin.sol:VmfCoin --constructor-args $usdc_address $initCharityAddress $initTeamAddress
