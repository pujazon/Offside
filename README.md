# RafVAR

Real-time system which detects Offside situation of the offense team in a Footbal match.
It has 3 sub-systems:
<hr>
<h2>PlayerDetection:</h2>
There are 3 Cameras: Top ,bottom and left camera.
With top camera image, our visual-computing software must take all players position.
With team camera, which is moved repected to top one and then is able to get shirt's players information, we must be able to detect each player axis position (Y position with left and X position with bottom) and their team 
Combinating all results it matches the left-bottom pairs position with their respective top position having then all players team and their positions.
Also BallDetection algorithm is included on top software camera detecting ball's position and the nearest player will be the ball owner (passer or reciver). So return value related to the Ball will be the index of this player.

PlayersMatrix C format
There is: id_ball + TeamA + TeamB
From [0] to [32] <-> 1 + 4*4 + 4*4 = 33 elments

[0] id_ball : Is the id of ball's owner player (passer or reciver)
[1-4] TeamA player 0: top,bottom,left,right;
[5-8] TeamA player 1: top,bottom,left,right;
Team B subarray begins in 1+4*4 = 17 
[17-20] TeamB player 0: top,bottom,left,right; ...

<h2>BallDetection:</h2>
Using an MPU6050 accelerometer we are able to know when a player kicks the ball (high acceleration increase in any of the axis).
So when that happens a signal must be send to Server. This trigger is the one who forces Main algorithm to process the PlayerDetection algorithm and BallPosition.

<h2>Camera</h2>
Our cameras are a Raspberry Pi Camera v2. Raspberry uses Raspicam library to work with camera. Then we gate the image and send via socket to the MainNode. Images are about 3,5 MB (Our throughput is about 1KB/sec so it takes 3 seconds more or less to transfer a whole image to MainNode. This is too much so we have to reduce image size to 1MB or 500KB in order to get the deadlines in STR)

<h2>MainNode:</h2>
MainNode is the one who has to process the information recived from Ball,Cameras and decide if there is Offside or not.
Inside a infinity loop we are getting PLayers' coordinates from PlayerDetection MATLAB process and they are stored.
When Ball trigger is detected we get the current Players' coordinates and we compare them with the last triggered Players' coordinates. Knowing the team of the owner ball player on the last trigger, the owner ball player on the current trigger and old and current positions the system is able to decide if there is Offside or not.

The comunication between PlayerDetection MATLAB process and MainNode process is done by MATLAB C++ API using "MatlabDataArray.hpp" and "MatlabEngine.hpp"

<h2>Network</h2>
Speaker and Listener modules let a System speak with other System that is listening. It's implemented using sockets and sending data via TCP. 
Camera system and Ball system are the Speakers while MainNode is the Listener. 

<hr>
<h2> TODOs </h2>
Camera calibration
Tracking algorithm
Homography team camera algorithm
Parallel ToolBox

<h2>Considerations:</h2>
1. We can use Visual-computing software to detect ball's position because our PoC won't have occlusion above the ball (there are no real players to step the ball).

2. Sliding field on 4 sides from the center A,B,C,D from top and left to right and bottom, if player is in A or B there is big right-left deviation. If it is in C and D there is a big top-bottom deviation

3. How more high the camera is less deviation are.
