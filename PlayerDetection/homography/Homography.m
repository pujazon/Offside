%% Homography
% https://www.i-ciencias.com/pregunta/100407/como-calcular-la-matriz-de-homografia-h-de-puntos-correspondientes-2d-2d-plana-homografia

%addpath '/home/pujazon/Escriptori/Offside/PlayerDetection/homography/testcases'
addpath 'C:\Users\danie\Desktop\TFG\Offside\PlayerDetection\homography\testcases'
top = imread('top_001.jpg');
figure, imshow(top);

a_side = imread('a_side_001.jpg');
figure, imshow(a_side);

%Points
% Top
x1 = 474;
x2 = 474;
x3 = 2710;
x4 = 2710;

y1 = 1112;
y2 = 3307;
y3 = 1028;
y4 = 3363;

%SideA

x1p = 330;
x2p = 278;
x3p = 2500;
x4p = 2500;
  
y1p = 1280;
y2p = 3356;
y3p = 899;
y4p = 3728;


P=    [-x1,-y1,-1,0,0,0,x1*x1p y1*x1p,x1p; ...
       0,0,0,-x1,-y1,-1,x1*y1p,y1*y1p,y1p; ...
       -x2,-y2,-1,0,0,0,x2*x2p,y2*x2p,x2p ; ...
       0,0,0,-x2,-y2,-1,x2*y2p,y2*y2p,y2p ; ...
       -x3,-y3,-1,0,0,0,x3*x3p,y3*x3p,x3p ; ...
       0,0,0,-x3,-y3,-1,x3*y3p,y3*y3p,y3p ; ...
       -x4,-y4,-1,0,0,0,x4*x4p,y4*x4p,x4p ; ...
       0,0,0,-x4,-y1,-1,x4*y4p,y4*y4p,y4p ]
   

zero=[0;0;0;0;0;0;0;0]
% 
% syms H;
% eqn = P*H == zero;
% solx = solve(eqn,H)

H = zero\P



