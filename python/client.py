#!/usr/bin/env python3

import socket
import json

def main():
    server_host = 'localhost'
    server_port = 5555

    while True:
        try:
            # Accept user input from the terminal
            message = input('Enter your message (type "exit" to quit): ')

            if message.lower() == 'exit':
                break

            # Create a socket connection to the server
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.connect((server_host, server_port))

                # Send the message to the server
                s.sendall(message.encode('utf-8'))

                # Receive the response from the server
                data = s.recv(1024)

            # Decode the JSON response and print it
            response = json.loads(data.decode('utf-8'))
            print(f"Server response: {response['request']}")
        except KeyboardInterrupt:
            print("\nExiting...")
            break
        except Exception as e:
            print(f"Error: {e}")

if __name__ == '__main__':
    main()

