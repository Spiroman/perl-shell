#!/bin/bash

perl perl/server.pl &

server_pid=$!

python3 python/curses_terminal.py

kill $server_pid
