
function res=handler_tracking(bb,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,...
                a1,b1,c1,d1,e1,f1,g1,h1,i1,j1,k1,l1,m1,n1,o1,p1,rc,gc,bc)
            
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

	fprintf("Vaoms a ver los inputs pe RGB %d %d  \n",bb,a);
    
    Program = tracker(trash,bb,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,...
                a1,b1,c1,d1,e1,f1,g1,h1,i1,j1,k1,l1,m1,n1,o1,p1,rc,gc,bc);  
    Program.echo();
    res=Program.tracking();
    
    fprintf("end handler_tracking()\n");
    
    %res = tmp;
end

%8,13,25,22,10,15,38,35,21,24,43,40,25,28,48,45,26,29,12,8,29,32,29,26,31,33,40,37,32,35,22,19,...
        %10,82,103);    
