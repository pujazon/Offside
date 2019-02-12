%% BOTTOM Camera
%  Get the image and show it. Set number of thread
addpath 'C:\Users\danie\Desktop\TFG\Offside\PlayerDetection\bottom\testcases'

%Profiling
% format shortg
% c = clock

for compress=1:1
    
maxNumCompThreads(16);
%%%fprintf('Hilos: %d\n',maxNumCompThreads);

I = imread('m_009.jpg');
Ori = imread('m_009.jpg');
A = imread('0A.jpg');
B = imread('0B.jpg');

figure, imshow(Ori);
figure, imshow(A);
figure, imshow(B);

end

%GLOBALS
global Processed;
global TmpBlobMap;
global PlayersMask;
global Blobs;
global N;    
global NBlobs;   

N = 30;

%Camera units in cm
camera_width = 50;
camera_height = 50;

global x_cm_per_pixel;
global y_cm_per_pixel;

%% Plotting Image Histogram:
%  Plot image histogram in order to get an image
%  that there are big acumulation of pixels in each components
%  which are grass pixels
% 
 for compress=1:1
%     
% %%figure, subplot(3,1,1);
% x = linspace(0,10,50);
% R=imhist(I(:,:,1));
% plot(R,'r');
% title('RED 1')
% 
% subplot(3,1,2);
% G=imhist(I(:,:,2));
% plot(G,'g');
% title('GREEN 2')
% 
% subplot(3,1,3);
% B=imhist(I(:,:,3));
% plot(B,'b');
% title('BLUE 3')
% 
 end

%% RGB Shirt color:
% Must be passed as an input before STR system run.
for compress=1:1
    
%pe: Red     
max_RLevels = 152;
max_GLevels = 32;
max_BLevels = 26;

end
%%fprintf("Shirt color %d,%d,%d\n",max_RLevels,max_GLevels,max_BLevels);

%% Preprocessing
%  Shirt color mask
% Here the segmentation will be using shirt color

for compress=1:1
    
global rows;
global columns;
rows = size(I,1);
columns = size(I,2);

RChannel = I(:,:,1);
GChannel = I(:,:,2);
BChannel = I(:,:,3);

%Are hardcoded but must be set dinamically
%Difference from field segmentation this must be very restrictive
Rth = 50;
Gth = 50;
Bth = 50;

tmp_PlayersMask = zeros(rows,columns);

for i = 1: rows
    for j = 1: columns                        
%        fprintf("RGB Grass %d,%d,%d\n",abs(RChannel(i,j)),abs(GChannel(i,j)),abs(BChannel(i,j)));        
%        fprintf("Shirt color %d,%d,%d\n",max_RLevels,max_GLevels,max_BLevels);
%        fprintf("Diff RGB Grass %d,%d,%d\n",mabs(RChannel(i,j),max_RLevels),mabs(GChannel(i,j),max_GLevels),mabs(BChannel(i,j),max_BLevels));        
        if (mabs(RChannel(i,j),max_RLevels) < Rth &&...
            mabs(GChannel(i,j),max_GLevels) < Gth &&...
            mabs(BChannel(i,j),max_BLevels) < Bth )            
            tmp_PlayersMask(i,j) = 0;
        else
            tmp_PlayersMask(i,j) = 255;
        end        
    end
end
 PlayersMask = tmp_PlayersMask;
 %PlayersMask = imgaussfilt(tmp_PlayersMask, 4);
 figure, imshow(PlayersMask);
    
end


%% Blob detection:
%  Detect all Blobs, filtered by size (not too much pixels means is no a
%  Blob) and store them into a Matrix where each row is one Blob and
%  columns are each one of pixels where even positions are the row (i)
%  and their respectives consecutive odd positions are the column (j) 
%  where pixel is on image

for compress=1:1

Blobs = Player.empty(N,0);
Processed = zeros(rows,columns);

%Initial set. Each position stores 0 (== no player)
TmpBlobMap = zeros(rows,columns,'uint8');

global top;
global bottom;
global left;
global right;
global weight;

%Weight threshold. or put it after too many examples or do it dinamically
%Difficult to do it dinamically. It will be hardcoded but must be good
%justifyed

minWeight = 400;

id = 1;   
BlobTotalWeight = 0;

%Blob Detection
for i = 1: rows
    for j = 1: columns                    
        
        if (PlayersMask(i,j) == 0 && Processed(i,j) == 0)
            %Ini setup before Blob detection function
            Processed(i,j) = 1;
            top = i;
            bottom = i;
            left = j;
            right = j;
            weight = 1; 

            Blob(i,j);
            
            %We must add 30-bigger-weight condition in order to delete
            %noise. Else STD calcus won't be realistic because there were
            %too fake values           
            
                if ((top ~= 0) && (bottom ~= 0) && (left ~= 0) && (right ~= 0) && (weight > minWeight))

                    Blobs(id).top = top;
                    Blobs(id).bottom = bottom;
                    Blobs(id).left = left;
                    Blobs(id).right = right;
                    Blobs(id).weight = weight;                 
                    %fprintf('PreBlob(%d,%d) has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',i,j,Blobs(id).weight,Blobs(id).top,Blobs(id).bottom,Blobs(id).right,Blobs(id).left);                                    
                    id = id+1; 
                    %figure, imshow(Processed); 
                end 

        end       
        
    end
end

NBlobs = id-1;
%figure, imshow(Processed); 
    
end

%% Postprocessing
%  Calculate weight std and only will be blobs the ones that 
%  have less deviation than std. otherwise will be discarted

for compress=1:1   

    %Problem is that there are too many noise and then that noise 
    %affects too much on STDi values and then on STD
    %and smal fake blobs pass STD filter because there were 
    %noise pixels blobs too small.
    %SOLVED-> Add pixel weight filter, enmpiristic (Knowing that 10 px is
    %too lees for a Player).
    
    FinalBlobs = Player.empty(NBlobs,0);
    maxWeight = 10000;
    
    %Ini calculus varaibles    
    SWeight = 0; 
    Sheight = 0;    
    sum = 0;
    sum2 = 0;
    
    %Weight Mean calculus
    for k=1:NBlobs               
        SWeight = SWeight + Blobs(k).weight;
        height = Blobs(k).bottom - Blobs(k).top;    
        Sheight = Sheight + height;
    end
    
    mean_weight = floor(SWeight/NBlobs);
    mean_height = floor(Sheight/NBlobs);

    %Weight STD Calculus
    for k=1:NBlobs  
        tmp=(Blobs(k).weight-mean_weight);
        tmp2 = tmp*tmp;
        sum = sum+tmp2;
        
        height = Blobs(k).bottom - Blobs(k).top;    
        aux=(height-mean_height);
        aux2 = aux*aux;
        sum2 = sum2+aux2;        
        
    end
    
    %Finish Weight STD Calculus
    tmp = floor(sum/(NBlobs-1));
    tmp2= sqrt(tmp);
    std_weight = floor(tmp2);
    
    aux = floor(sum2/(NBlobs-1));
    aux2= sqrt(aux);
    std_height = floor(aux2);  

    fprintf('std_weight = %d\n',std_weight);
    fprintf('mean_weight = %d\n',mean_weight);

    fid = 1;
   
    for k=1:NBlobs
        
        %reorder conditional statements in order to impreove performance.
        %also, mean_weight can be processed befeore on Blob, loop fusion
       
        std_i= abs(Blobs(k).weight - mean_weight);
        %fprintf('weight_i = %d\n',Blobs(k).weight);
        
        %Processed output shows the curve of camera.
        %this origins that center players will have less pixels
        %than the others, so probablly std_i won't be correct.
        %So there is other filter. maxWeight
        
         if (Blobs(k).weight > maxWeight )
             % NOT WORKS|| std_i < std_weight)
            fprintf('Blob has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',Blobs(k).weight,Blobs(k).top,Blobs(k).bottom,Blobs(k).right,Blobs(k).left);                                    
            FinalBlobs(fid) = Blobs(k);                        
            fid = fid+1;
        end
    end    

    fid = fid-1;
    
    %Debug
    for w=1:fid
        %%%%fprintf("I(%d)=[%d,%d,%d,%d]; r=%d,c=%d\n",w,FinalBlobs(w).top,FinalBlobs(w).left,FinalBlobs(w).bottom,FinalBlobs(w).right,(FinalBlobs(w).bottom-FinalBlobs(w).top),(FinalBlobs(w).right-FinalBlobs(w).left));        
        for iii= FinalBlobs(w).top:FinalBlobs(w).bottom 
            for jjj = FinalBlobs(w).left:FinalBlobs(w).right
                I(iii,jjj,1) = 34;
                I(iii,jjj,2) = 234;
                I(iii,jjj,3) = 34;
            end
        end    
    end
    
    fprintf('Really, there are %d Blobs!\n',fid);
    NBlobs = fid;
    imshow(I);
end

%% Coordinates
% Get each player's coordinates assuming orthogonal camera (unreal)

for compress=1:1

x_cm_per_pixel = (camera_width/columns);
y_cm_per_pixel = (camera_height/rows);

% fprintf("camera_width = %d\n",camera_width);
% fprintf("camera_height = %d\n",camera_height);
% 
% fprintf("x_cm_per_pixel = %d\n",x_cm_per_pixel);
% fprintf("y_cm_per_pixel = %d\n",y_cm_per_pixel);

for id=1:NBlobs
    
top = y_coords_from_camera_to_real(FinalBlobs(id).top);
bottom = y_coords_from_camera_to_real(FinalBlobs(id).bottom);
left = x_coords_from_camera_to_real(FinalBlobs(id).left);
right = x_coords_from_camera_to_real(FinalBlobs(id).right);
    
FinalBlobs(id).top = top;
FinalBlobs(id).bottom = bottom;
FinalBlobs(id).left = left;
FinalBlobs(id).right = right;

FinalBlobs(id).width = right-left;   
FinalBlobs(id).height = bottom-top;                 
fprintf('Player(%d); top: %d, bottom: %d, right: %d, left: %d\n',id,FinalBlobs(id).top,FinalBlobs(id).bottom,FinalBlobs(id).right,FinalBlobs(id).left);                                    

end

end
%% Profiling
% format shortg
% c = clock

%% Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = in_of_bounds(i,j)    
    global rows;
    global columns;

    ret = (i > 0 && j > 0 && i < rows && j < columns );
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = mabs(a,b)    
    if (a > b) ret = a-b;
    else ret = b-a;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Blob(ii,jj)

    global PlayersMask;
    global Processed;
    global bottom;
    global right;
    global left;
    global weight;
        
    if(in_of_bounds(ii+1,jj)==1 && PlayersMask(ii+1,jj) == 0 && Processed(ii+1,jj) == 0) 
        %%%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii+1,jj));
        Processed(ii+1,jj) = 1;
        weight = weight +1;        
        bottom = max(ii+1,bottom);
        %%%%fprintf('bottom = %d\n',bottom);
        Blob(ii+1,jj);
    end  
            
    if(in_of_bounds(ii,jj-1)== 1 && PlayersMask(ii,jj-1) == 0 && Processed(ii,jj-1) == 0)     
        %%%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj-1));
        Processed(ii,jj-1) = 1;
        weight = weight +1;        
        left = min(jj-1,left);
        %%%%fprintf('left = %d\n',left);
        Blob(ii,jj-1);
    end
    
    if(in_of_bounds(ii,jj+1)==1 && PlayersMask(ii,jj+1) == 0 && Processed(ii,jj+1) == 0)
        %%%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj+1));
        Processed(ii,jj+1) = 1;
        weight = weight +1; 
        right = max(jj+1,right);
        %%%%fprintf('right = %d\n',right);
        Blob(ii,jj+1);
    end    

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = x_coords_from_camera_to_real(x_camera_coord)

    global x_cm_per_pixel;
    %fprintf("x_camera_coord: %d\n",x_camera_coord);      
    %fprintf("x_cm_per_pixel: %d\n",x_cm_per_pixel);
    
    x_real_coord = x_camera_coord*x_cm_per_pixel;
    
    %fprintf("x_real_coord: %d\n",x_real_coord);

    %TODO: Precision level (?)
    ret = round(x_real_coord);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = y_coords_from_camera_to_real(y_camera_coord)

    global y_cm_per_pixel;

    y_real_coord = y_camera_coord*y_cm_per_pixel;
    %fprintf("y_real_coord: %d\n",y_real_coord);

    %TODO: Precision level (?)
    ret = round(y_real_coord);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
