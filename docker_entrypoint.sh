#!/bin/sh
set -e

cd /home/tester/bitcoin-testnet-box && bitcoind -datadir=1 -daemon &&bitcoind -datadir=2 -daemon

exec "$@"
