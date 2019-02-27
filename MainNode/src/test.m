
function res=test()
    %A = [1 2; 3 4];
    fprintf("Testing PlayersMatrix()\n");
    %2 equipos*(11 jugadores/equipo *4 atrr/jug)+1 indice jugador con balo

    %PlayersMatrix C format
    %[0] id_ball
    %[1-4] TeamA player 0: top,bottom,left,right;
    %[5-8] TeamA player 1: top,bottom,left,right;
    % Team B in 1+4*11-1(*) = 22 (*)-1 porque empezamos des del 0
    %[22-26] TeamB player 0: top,bottom,left,right;

    Program = Main.empty(1,0);
    res = Program.getPlayersMatrix();
    fprintf("OUT\n");
    
    %res = tmp;
end
