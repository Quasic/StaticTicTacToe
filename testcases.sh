#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")/tictactoe"&&
bash testcases.sh&&
cd c&&
true
#bash testcases.sh
