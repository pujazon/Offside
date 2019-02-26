# RafVAR

Real-time system which detects Offside situation of the offense team in a Footbal match.
It has 3 sub-systems:
<hr>
<h2>PlayerDetection:</h2>
There are 3 Cameras: Top ,bottom and left camera.
With top camera image, our visual-computing software must take all players position.
With left and bottom camera we must be able to detect each player axis position (Y position with left and X position with bottom)
and combinating all results it matches the left-bottom pairs position with their respective top position having then all players team and their positions.
Also BallDetection algorithm is included on top software camera detecting ball's position.

<h2>BallDetection:</h2>
Using an MPU6050 accelerometer we are able to know when a player kicks the ball (high acceleration increase in any of the axis).
So when that happens a signal must be send to Server. This trigger is the one who forces Main algorithm to process the PlayerDetection algorithm and BallPosition.

<h2>MainNode:</h2>

MainNode is the one who has to process the information recived from Ball,Cameras and decide if there is Offside or not.
Inside a infinity loop we are getting PLayers' coordinates from PlayerDetection MATLAB process and they are stored.
When Ball trigger is detected we get the current Players' coordinates and we compare them with the last triggered Players' coordinates. Knowing the team of the owner ball player on the last trigger, the owner ball player on the current trigger and old and current positions the system is able to decide if there is Offside or not.

The comunication between PlayerDetection MATLAB process and MainNode process is done by MATLAB C++ API using "MatlabDataArray.hpp" and "MatlabEngine.hpp"

<h2>Network</h2>
Speaker and Listener modules let a System speak with other System that is listening. It's implemented using sockets and sending data via TCP. 
Camera system and Ball system are the Speakers while MainNode is the Listener. 

<hr>
<h2>Considerations:</h2>
1. We can use Visual-computing software to detect ball's position because our PoC won't have occlusion above the ball (there are no real players to step the ball).

2. Sliding field on 4 sides from the center A,B,C,D from top and left to right and bottom, if player is in A or B there is big right-left deviation. If it is in C and D there is a big top-bottom deviation

3. How more high the camera is less deviation are.
