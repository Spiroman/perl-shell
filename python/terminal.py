#!/usr/bin/env python3

import curses

def main(stdscr):
    curses.curs_set(1)  # Set the cursor to be visible
    stdscr.timeout(-1)  # Block for user input
    stdscr.scrollok(True)

    stdscr.addstr("> ")
    while True:
        # Get user input
        key = stdscr.getch()

        # Exit on Ctrl+C or Ctrl+D
        if key in (3, 4):
            break

        # Print input character to the screen
        stdscr.addch(key)

        # Scroll the window if needed
        if stdscr.getyx()[0] == curses.LINES - 1:
            stdscr.scroll(1)
            stdscr.move(stdscr.getyx()[0] - 1, 0)

if __name__ == "__main__":
    curses.wrapper(main)

