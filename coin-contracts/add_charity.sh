#!/bin/bash

contract_address="0xf5830633702c707fB494b40C1DA783bbF6E06c02"
charity_address="0xB697C8b4bCaE454d9dee1E83f73327D7a63600a1"
source .env
rpc_url="localhost:8485"
cast send $contract_address "addAllowedReceivers(address)" $charity_address \
    --rpc-url $rpc_url --private-key "$PRIVATE_KEY"
