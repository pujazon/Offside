# offside

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

<h2>Network</h2>
Camera system and Ball system have in their system source code (TODO: Are more than one source code so in order to link them headers must be created, set which source file will be main one, others c only could have functions...) a socket connection that sends messages.
Server system has other source code which recives the information and then will be processed.
<hr>
<h2>Considerations:</h2>
1. We can use Visual-computing software to detect ball's position because our PoC won't have occlusion above the ball (there are no real players to step the ball).

2. Sliding field on 4 sides from the center A,B,C,D from top and left to right and bottom, if player is in A or B there is big right-left deviation. If it is in C and D there is a big top-bottom deviation

3. How more high the camera is less deviation are.