#!/usr/bin/python

#######################
# Author: Jochem Douw #
#######################

# Note: contains some Dutch:
# Weergave = Display
# ververs = refresh
# objectenRij = object Array
# regel = line
# begintijd/eindtijd = beginning time/end time
# toets = test

import curses
import curses.wrapper
import time
import random

class Weergave:

    def ververs(self, stdscr, GAME_HEIGHT, GAME_WIDTH):
        # Make sure the cursor is not displayed in a weird place
        stdscr.addstr(GAME_HEIGHT,GAME_WIDTH+2,"")
        stdscr.refresh()

def main(stdscr):
    # Initialize weergave object
    weergave = Weergave()

    # Curses must always be initialised
    stdscr.clear()

    # Don't display user input by default
    curses.noecho()

    # Don't wait for enters before processing input
    curses.cbreak()

    # Ease the use of processing arrows etc. (by e.g. using curses.KEY_LEFT)
    stdscr.keypad(1)

    # Game settings
    GAME_HEIGHT = 15
    GAME_WIDTH = 10

    # Initialize the player
    currentCol = 5
    oldCol = 5
    stdscr.addstr(GAME_HEIGHT,currentCol,"A", curses.A_REVERSE)

    # Initialize objects
    objectenRij = [[0,3,0,3,"V"]]

    # Start with 0 points
    points = 0

    # Initialize borders
    for regel in xrange(0,GAME_HEIGHT+1):
        stdscr.addstr(regel, 0, "|")
        stdscr.addstr(regel, GAME_WIDTH+1, "|")

    stdscr.refresh()

    t = 0
    while True:
        t = t + 1
        # Catch the key
        curses.halfdelay(2)
        begintijd = time.time()
        toets = stdscr.getch()
        eindtijd = time.time()
        resttijd = eindtijd - begintijd

        # Process key input
        if toets == curses.KEY_LEFT:
            if currentCol > 1:
                oldCol = currentCol
                currentCol = currentCol - 1
        if toets == curses.KEY_RIGHT:
            if currentCol < GAME_WIDTH:
                oldCol = currentCol
                currentCol = currentCol + 1
        # Register q key (=113)
        if toets == 113:
            break
        stdscr.addstr(0, GAME_WIDTH+3, "-------")
        stdscr.addstr(1, GAME_WIDTH+3, "CARGAME")
        stdscr.addstr(2, GAME_WIDTH+3, "-------")
        stdscr.addstr(3, GAME_WIDTH+3, "Time: "+str(t))
        stdscr.addstr(3, GAME_WIDTH+3, "Points: "+str(points))
        stdscr.addstr(GAME_HEIGHT, GAME_WIDTH+3, "Press 'q' to quit")

        # Display the objects in the new position
        for objectje in objectenRij:
            if objectje[4] == "V":
                kleur = curses.A_REVERSE
            if objectje[4] == "O":
                kleur = curses.A_BOLD
            stdscr.addstr(objectje[0],objectje[1],objectje[4], kleur)
            stdscr.addstr(objectje[2],objectje[3]," ")

        # Display the car in the new position
        stdscr.addstr(GAME_HEIGHT,currentCol,"A",curses.A_REVERSE)
        if currentCol != oldCol:
            stdscr.addstr(GAME_HEIGHT,oldCol," ")

        # See whether we crashed or gained a point
        crash = False
        for objectje in objectenRij:
            if currentCol == objectje[1]:
                if objectje[0] == GAME_HEIGHT:
                    if objectje[4] == "V":
                        stdscr.addstr(GAME_HEIGHT+1, 0, "--- CRASH!! ---")
                        weergave.ververs(stdscr, GAME_HEIGHT, GAME_WIDTH)
                        crash = True
                    if objectje[4] == "O":
                        points = points + 1

        if crash:
            break

        # Make progress for objects
        for objectje in objectenRij:
            objectje[2] = objectje[0]
            objectje[3] = objectje[1]
            if objectje[0] < GAME_HEIGHT :
                objectje[0] = objectje[0] + 1
            else:
                objectje[0] = 0
                objectje[1] = int(random.uniform(1,GAME_WIDTH+1))

        if len(objectenRij) < GAME_HEIGHT:
            startCol = int(random.uniform(1,GAME_WIDTH+1))
            objectenRij.append([0, startCol, 0, startCol,
                    random.choice(["V","O"])])

        # Make a hard pause to 'sit out' the rest of the 10th of a second
        curses.nocbreak()
        stdscr.addstr(GAME_HEIGHT-2, GAME_WIDTH+3, "BR")
        time.sleep(resttijd)
        stdscr.addstr(GAME_HEIGHT-2, GAME_WIDTH+3, str(resttijd))

        # Make sure the cursor is not displayed in a weird place
        stdscr.addstr(GAME_HEIGHT,GAME_WIDTH+2,"")
        # Refresh the screen
        stdscr.refresh()

    # Wait a split sec
    time.sleep(.5)
    curses.cbreak()
    stdscr.addstr(GAME_HEIGHT+2, 0, "Press a key to end")
    stdscr.refresh()
    # Avoid stopping the game with left-right key presses
    while True:
        toets = stdscr.getch()
        if toets != curses.KEY_LEFT and toets != curses.KEY_RIGHT:
            break

    # The end. Restore original settings
    curses.nocbreak();
    #screen.keypad(0);
    curses.echo()
    # and end
    curses.endwin()

curses.wrapper(main)

