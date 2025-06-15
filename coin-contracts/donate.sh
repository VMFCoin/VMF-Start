#!/bin/bash
set -ex

contract_address="0xf5830633702c707fB494b40C1DA783bbF6E06c02"
charity_address="0xB697C8b4bCaE454d9dee1E83f73327D7a63600a1"
source .env
rpc_url="localhost:8485"
amount=10

usdc_address="0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238"
cast send $usdc_address \
  "approve(address,uint256)" \
  $contract_address \
  $amount \
  --private-key "$PRIVATE_KEY" \
  --rpc-url $rpc_url
cast send $contract_address "handleUSDC(uint256,address)" 10 $charity_address \
    --rpc-url $rpc_url --private-key "$PRIVATE_KEY"
