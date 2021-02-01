/* Maze
 * Author: Chanuka Nimsara
 * Creation date: 12/11/2020
 */
MACHINE
    //Define Machine for Maze
    Maze

SETS
    STATES = { CANNOT_MOVE_WALL_DETECTED, 
               CANNOT_MOVE_OUT_OF_MAZE, 
               TELEPORTED, 
               CANNOT_IMMEDIATELY_TELEPORT_TO_EXIT, 
               MOVED_NORTH, 
               MOVED_SOUTH, 
               MOVED_EAST, 
               MOVED_WEST };
            
    RESPONSES = { YES, NO }
    
CONSTANTS
    height,
    width,
    x_Maze,
    y_Maze,
    wall,
    exit_Square,
    entrance_Square

PROPERTIES
    height = 5 & 
    width = 7 & 
    x_Maze = 1..width & 
    y_Maze = 1..height & 
    entrance_Square = (1 |-> 1) &
    exit_Square = (1 |-> 5) & 
    wall : x_Maze <-> y_Maze &
    wall = {(1 |-> 3), (2 |-> 1), (2 |-> 3), (2 |-> 5), (3 |-> 3), (4 |-> 2), (4 |-> 3), (4 |-> 4), (6 |-> 1), (6 |-> 2), (6 |-> 4), (7 |-> 4)}
    
END
