#!/usr/bin/env python3

import curses
import socket
import json

def main(stdscr):
    server_host = 'localhost'
    server_port = 5555

    curses.curs_set(1)  # Set the cursor to be visible
    stdscr.timeout(-1)  # Block for user input
    stdscr.scrollok(True)

    while True:
        # Get user input
        stdscr.addstr('> ')
        input_str = stdscr.getstr().decode('utf-8')

        if input_str.lower() == 'exit':
            break

        if not input_str:
            continue

        try:
            # Create a socket connection to the server
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.connect((server_host, server_port))

                # Send the message to the server
                s.sendall(input_str.encode('utf-8'))

                # Receive the response from the server
                data = s.recv(1024)

            # Decode the JSON response and print it
            response = json.loads(data.decode('utf-8'))
            response_message = response['request']
            stdscr.addstr(response_message, '\n')
        except Exception as e:
            stdscr.addstr(f"\nError: {e}\n")

        stdscr.refresh()

if __name__ == "__main__":
    curses.wrapper(main)

