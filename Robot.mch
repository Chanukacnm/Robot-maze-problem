/* Robot
 * Author: Chanuka Nimsara
 * Creation date: 12/12/2020
 */
MACHINE
    Robot
    
SEES
    Maze
    
SETS
    DIRECTIONS = {
        North, 
        South, 
        East, 
        West
    }
    
VARIABLES
    robot_X_Position, 
    robot_Y_Position,
    robot_Visited_Path,
    robot_Visited_Direction
    
INVARIANT
    robot_X_Position : NATURAL1 & 
    robot_Y_Position : NATURAL1 &   
    robot_Visited_Path : seq(x_Maze * y_Maze) &
    robot_Visited_Direction : seq(DIRECTIONS)
    
INITIALISATION    
    robot_Visited_Direction, robot_Visited_Path, robot_X_Position, robot_Y_Position := [], [], 1, 1
    
DEFINITIONS
    // These functions will be used to create the graph
    ANIMATION_FUNCTION == ({ row, col, img | col:1..7 & row:1..5 & img=0 });
    ANIMATION_FUNCTION1 == ({ row, col, img | col:1..7 & row:1..5  & img=1 & (col, 6-row) : wall });
    ANIMATION_FUNCTION2 == ({ row, col, img | col:1..7 & row:1..5 & img=2 & col=robot_X_Position & row=(6-robot_Y_Position) });
    
    // Images for animations
    ANIMATION_IMG0 == "images/emptycell.gif";
    ANIMATION_IMG1 == "images/wall.gif";
    ANIMATION_IMG2 == "images/robot.gif";
    
OPERATIONS
    //Move to Robot to North direction
    //Do validations and assign result to result
    message <-- moveNorth =
    BEGIN
            IF
                (robot_Y_Position + 1 : y_Maze)                
            THEN
                IF
                    (robot_X_Position |-> (robot_Y_Position + 1) /: wall)
                THEN
                    robot_Visited_Direction, robot_Visited_Path, robot_Y_Position := robot_Visited_Direction <- North, robot_Visited_Path <- (robot_X_Position, robot_Y_Position), robot_Y_Position + 1 ||
                    message := MOVED_NORTH
                ELSE
                    message := CANNOT_MOVE_WALL_DETECTED
                END
            ELSE
                message := CANNOT_MOVE_OUT_OF_MAZE
            END
        END;
        
    //Move to Robot to South direction
    //Do validations and assign result to result
    message <-- moveSouth =
        BEGIN
            IF
                (robot_Y_Position - 1 : y_Maze)
            THEN
                IF
                    (robot_X_Position |-> (robot_Y_Position - 1) /: wall)
                THEN
                    robot_Visited_Direction, robot_Visited_Path, robot_Y_Position := robot_Visited_Direction <- South, robot_Visited_Path <- (robot_X_Position, robot_Y_Position), robot_Y_Position - 1 ||
                    message := MOVED_SOUTH
                ELSE
                    message := CANNOT_MOVE_WALL_DETECTED
                END
            ELSE
                message := CANNOT_MOVE_OUT_OF_MAZE
            END
        END; 

    //Move to Robot to East direction
    //Do validations and assign result to result
    message <-- moveEast =
        BEGIN
            IF
                (robot_X_Position + 1 : x_Maze)
            THEN
                IF
                    ((robot_X_Position + 1) |-> robot_Y_Position /: wall)
                THEN
                    robot_Visited_Direction, robot_Visited_Path, robot_X_Position := robot_Visited_Direction <- East, robot_Visited_Path <- (robot_X_Position, robot_Y_Position), robot_X_Position + 1 ||
                    message := MOVED_EAST
                ELSE
                    message := CANNOT_MOVE_WALL_DETECTED
                END
            ELSE
                message := CANNOT_MOVE_OUT_OF_MAZE
            END
        END;
        
    //Move to Robot to West direction
    //Do validations and assign result to result
    message <-- moveWest =
        BEGIN
            IF
                (robot_X_Position - 1 : x_Maze)
            THEN
                IF
                    ((robot_X_Position - 1) |-> robot_Y_Position /: wall)
                THEN
                    robot_Visited_Direction, robot_Visited_Path, robot_X_Position := robot_Visited_Direction <- West, robot_Visited_Path <- (robot_X_Position, robot_Y_Position), robot_X_Position - 1 ||
                    message := MOVED_WEST
                ELSE
                    message := CANNOT_MOVE_WALL_DETECTED
                END
            ELSE
                message := CANNOT_MOVE_OUT_OF_MAZE
            END
        END ;
        
    //Operation for teleport
           message <-- Teleport (x_Position, y_Position) =
        PRE
            x_Position : NATURAL1 &
            y_Position : NATURAL1 & 
            (x_Position |-> y_Position) /= (robot_X_Position |-> robot_Y_Position)
        THEN
            //To prevent immediate teleport to exist 
            IF
               ( (x_Position |-> y_Position) = exit_Square &
                size(robot_Visited_Path) = 0)
            THEN
                message := CANNOT_IMMEDIATELY_TELEPORT_TO_EXIT
            ELSE
                 IF
                    (x_Position |-> y_Position /: wall)
                THEN
                    IF
                       ( x_Position : x_Maze & y_Position : y_Maze)
                    THEN
                        robot_X_Position, robot_Y_Position, robot_Visited_Path := x_Position, y_Position, robot_Visited_Path <- (robot_X_Position, robot_Y_Position) ||
                        message := TELEPORTED
                    ELSE
                        message := CANNOT_MOVE_OUT_OF_MAZE
                    END
                ELSE
                    message := CANNOT_MOVE_WALL_DETECTED   
                END                
            END
        END;
        
    //Operation to get the robot's current position
    answer <-- getPosition =
        BEGIN
            answer := robot_X_Position |-> robot_Y_Position
        END;
        
    //Operation to check whether robot has found the exit or not
    answer <-- foundExit =
        BEGIN
            //Check robot's current position equals to (1,5) coordinates
            IF ((robot_X_Position |-> robot_Y_Position) = exit_Square)
            THEN
                answer := YES
            ELSE
                answer := NO
            END
        END;
        
    //Operation to track the visited squares
    answer <-- hasVisitedSquare(x_Position, y_Position) =
        PRE
            x_Position : x_Maze & 
            y_Position : y_Maze
        THEN
            IF ((x_Position |-> y_Position) : ran(robot_Visited_Path))    
            THEN
                answer := TRUE
            ELSE
                answer := FALSE
            END
        END;
        
    //Operation to check robots visited paths
    answer <-- robotsRoute =
        BEGIN
            answer := robot_Visited_Path 
        END;
        
    //Operation to check robots visited direction
    answer <-- robotsDirection =
        BEGIN
            answer := robot_Visited_Direction 
        END
END
