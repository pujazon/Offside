
function res=test()
    fprintf("Testing PlayersMatrix()\n");
    %2 equipos*(4 jugadores/equipo *4 atrr/jug)+1 = 33 posiciones (del 0 al 32)

    %PlayersMatrix C format
    %[0] id_ball : Is the id of ball's owner player (passer or reciver)
    %[1-4] TeamA player 0: top,bottom,left,right;
    %[5-8] TeamA player 1: top,bottom,left,right;
    % Team B in 1+4*4 = 17 
    %[17-20] TeamB player 0: top,bottom,left,right; ...


    Program = ini.empty(1,0);
    res = Program.getPlayersMatrix();
    fprintf("OUT\n");
    
    res = tmp;
end
