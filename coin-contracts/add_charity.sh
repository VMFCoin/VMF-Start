#!/bin/bash

contract_address="0x70Ff52ff9AA492390fFE09dc1521dcA76fE28811"
charity_address="0xB697C8b4bCaE454d9dee1E83f73327D7a63600a1"
source .env
rpc_url="localhost:8485"
cast send $contract_address "addAllowedReceivers(address)" $charity_address \
    --rpc-url $rpc_url --private-key "$PRIVATE_KEY"
