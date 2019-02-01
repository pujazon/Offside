%% TOP Camera
%  Get the image and show it. Set number of thread
addpath 'C:\Users\danie\Desktop\TFG\Offside\PlayerDetection\top\testcases'

%Profiling
% format shortg
% c = clock

for compress=1:1
    
maxNumCompThreads(16);
%%%fprintf('Hilos: %d\n',maxNumCompThreads);

I = imread('m_005.jpg');
Ori = imread('m_005.jpg');

figure, imshow(Ori);

end

%GLOBALS
global Processed;
global TmpBlobMap;
global PlayersMask;
global Blobs;
global N;    
global NBlobs;   

N = 30;

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

%% RGB Peks Grass:
%  Get R,G,B Peaks of each components
%  and then you will get Grass mean color

for compress=1:1
    
[pixelidsG, GLevels] = imhist(I(:,:,2));
[pixelidsB, BLevels] = imhist(I(:,:,3));
[pixelidsR, RLevels] = imhist(I(:,:,1));

max_RLevels = 1;
RPeak = pixelidsR(1);
max_GLevels = 1;
GPeak = pixelidsG(1);
max_BLevels = 1;
BPeak = pixelidsB(1);

%Loop fusion

for i = 2:255
    if(pixelidsR(i) > RPeak)
        max_RLevels = i;
        RPeak = pixelidsR(i);
    end
    if(pixelidsG(i) > GPeak)
        max_GLevels = i;
        GPeak = pixelidsG(i);
    end
    if(pixelidsB(i) > BPeak)
        max_BLevels = i;
        BPeak = pixelidsB(i);
    end
end

end
%%fprintf("RGB Grass %d,%d,%d\n",max_RLevels,max_GLevels,max_BLevels);

%% Preprocessing
%  FieldMask:
%  Apply thresholding with Grass mean color and offset
%  FieldBoundaries:
%  Image is bigger than field and we only want to process the blobs inside field 
%  so must be found field boundaries

for compress=1:1
    
global rows;
global columns;
global top_field; 
global bottom_field;  
global FieldMask;
rows = size(I,1);
columns = size(I,2);

RChannel = I(:,:,1);
GChannel = I(:,:,2);
BChannel = I(:,:,3);

%Are hardcoded but must be set dinamically
Rth = 80;
Gth = 80;
Bth = 80;

FieldMask = zeros(rows,columns);
tmp_PlayersMask = zeros(rows,columns);

for i = 1: rows
    for j = 1: columns                        
%        fprintf("RGB Grass %d,%d,%d\n",abs(RChannel(i,j)),abs(GChannel(i,j)),abs(BChannel(i,j)));        
%        fprintf("Shirt color %d,%d,%d\n",max_RLevels,max_GLevels,max_BLevels);
%        fprintf("Diff RGB Grass %d,%d,%d\n",mabs(RChannel(i,j),max_RLevels),mabs(GChannel(i,j),max_GLevels),mabs(BChannel(i,j),max_BLevels));        
        if (mabs(RChannel(i,j),max_RLevels) < Rth &&...
            mabs(GChannel(i,j),max_GLevels) < Gth &&...
            mabs(BChannel(i,j),max_BLevels) < Bth )   
        
            %It's grass
            tmp_PlayersMask(i,j) = 255;
        else
            FieldMask(i,j) = 255;
        end        
    end
end

 PlayersMask = tmp_PlayersMask;
 figure, imshow(FieldMask);
 
 %Field Boundaries
 find_top();
 find_bottom();
 
 %fprintf('find_top: %d\n',top_field);
 %fprintf('find_top: %d\n',bottom_field);
 
end

%% Edge detection
%Not needed. Adds more problems than solutions
 for compress=1:1
% 
%     IGray = rgb2gray(I);
%     IGray2 = imgaussfilt(IGray,10);
%     Edges = edge(IGray2,'sobel');
%     %figure, imshow(BW1);
% 
% end
% 
% Merge filters
% 
% for compress=1:1
% 
%     MergeMap = ones(rows,columns);
% 
%     for i = 1: rows
%         for j = 1: columns  
%             if (FieldMask(i,j) == 255 && Edges(i,j) == 1)
%                 MergeMap(i,j) = 0;
%             end
%         end
%     end
%     
%     
%     PlayersMask = imgaussfilt(MergeMap,10);    
%     %figure, imshow(PlayersMask);
%     
%     Debug
%     for i = 1: rows
%         for j = 1: columns  
%             if (PlayersMask(i,j) == 0)               
%                 %fprintf("%i == d; j == %d\n",i,j);
%             end
%         end
%     end
%     
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
for i = top_field: bottom_field
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
                    fprintf('Blob(%d,%d) has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',i,j,Blobs(id).weight,Blobs(id).top,Blobs(id).bottom,Blobs(id).right,Blobs(id).left);                                    
                    id = id+1; 
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
    maxWeight = 1000;
    
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
        fprintf('std_i = %d\n',std_i);
        
        %Processed output shows the curve of camera.
        %this origins that center players will have less pixels
        %than the others, so probablly std_i won't be correct.
        %So there is other filter. maxWeight
        
         if (Blobs(k).weight > maxWeight || std_i < std_weight)            
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
                I(iii,jjj,1) = 234;
                I(iii,jjj,2) = 34;
                I(iii,jjj,3) = 234;
            end
        end    
    end
    
    fprintf('Really, there are %d Blobs!\n',fid);
    NBlobs = fid;
    imshow(I);
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
function find_top()

    global rows;
    global columns;
    global top_field;      
    global FieldMask; 
    
    ii = 1;
    trobat = 0;
    
    while(trobat == 0 && ii < rows)
        jj = 1;
        field_row = 1;
        fprintf("(%d,%d)\n",ii,jj);
        
        while (field_row == 1 && jj < columns-1)
            if (FieldMask(ii,jj) ~= 0)
                field_row = 0;
            end            
            jj = jj+1;
            fprintf("(%d,%d)\n",ii,jj);
        end
        
        if (field_row == 1)
            trobat = 1;
            top_field = ii;
        end
        ii=ii+1;
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function find_bottom()

    global rows;
    global columns;
    global bottom_field;      
    global FieldMask; 
    
    ii = rows;
    trobat = 0;
    
    while(trobat == 0 && ii > 1)
        jj = 1;
        field_row = 1;
        fprintf("(%d,%d)\n",ii,jj);
        
        while (field_row == 1 && jj < columns-1)
            if (FieldMask(ii,jj) ~= 0)
                field_row = 0;
            end            
            jj = jj+1;
            fprintf("(%d,%d)\n",ii,jj);
        end
        
        if (field_row == 1)
            trobat = 1;
            bottom_field = ii;
        end
        ii=ii-1;
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%