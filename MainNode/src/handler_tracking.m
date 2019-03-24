
function res=handler_tracking()
    fprintf("Testing PlayersMatrix()\n");
    %2 equipos*(4 jugadores/equipo *4 atrr/jug)+1 = 33 posiciones (del 0 al 32)

    %PlayersMatrix C format
    %[0] id_ball : Is the id of ball's owner player (passer or reciver)
    %[1-4] TeamA player 0: top,bottom,left,right;
    %[5-8] TeamA player 1: top,bottom,left,right;
    % Team B in 1+4*4 = 17 
    %[17-20] TeamB player 0: top,bottom,left,right; ...

    %Primer parametro NULLL
    trash = 0;
    
    Program = tracker(trash,10,13,26,29,19,21,33,36,19,22,19,22,27,29,26,29,28,31,44,47,30,32,3,7,37,40,34,36,38,41,17,20,...
        1,7,57);    
    Program.echo();
    res=Program.tracking();
    
    fprintf("end handler_tracking()\n");
    
    %res = tmp;
end
