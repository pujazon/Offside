%% Init
%  Get the image and show it. Set number of thread
addpath 'C:\Users\danie\Desktop\TFG\Offside\PlayerDetection\top\testcases'

%Profiling
% format shortg
% c = clock

for compress=1:1
    
maxNumCompThreads(8);
%%fprintf('Hilos: %d\n',maxNumCompThreads);

I = imread('001.jpg');
TeamMap = imread('001.jpg');
T = imread('001.jpg');
T2 = imread('001.jpg');

end

%GLOBALS
global Processed;
global BlobMap;
global TmpBlobMap;
global MergeMap;
global Blobs;
global ZeroMask;
global FinalBlobs;
global N;    
global NBlobs;  
global PlayerColors;    

N = 30;

%%
%% Plotting Image Histogram:
%  Plot image histogram in order to get an image
%  that there are big acumulation of pixels in each components
%  which are grass pixels
% 
% for compress=1:1
%     
% %figure, subplot(3,1,1);
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
% end

%%

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

fprintf("RGB Grass %d,%d,%d\n",max_RLevels,max_GLevels,max_BLevels);

%%

%% FieldMask:
%  Apply thresholding with Grass mean color and offset

for compress=1:1
    
global rows;
global columns;
rows = size(I,1);
columns = size(I,2);

RChannel = I(:,:,1);
GChannel = I(:,:,2);
BChannel = I(:,:,3);

%Are hardcoded but must be set dinamically
Rth = 50;
Gth = 50;
Bth = 50;

FieldMask = zeros(rows,columns);
tmp_PlayersMask = zeros(rows,columns);

for i = 1: rows
    for j = 1: columns                        
        %fprintf("RGB Grass %d,%d,%d\n",abs(RChannel(i,j)),abs(GChannel(i,j)),abs(BChannel(i,j)));        
        if (abs(RChannel(i,j)- max_RLevels) < Rth &&...
            abs(GChannel(i,j)- max_GLevels) < Gth &&...
            abs(BChannel(i,j)- max_BLevels) < Bth )    
        
            %It's grass
            tmp_PlayersMask(i,j) = 255;
            FieldMask(i,j) = 0;
        else
            FieldMask(i,j) = 255;
        end        
    end
end

% figure, imshow(FieldMask);


end


%%

%% Edge detection

for compress=1:1

    IGray = rgb2gray(I);
    IGray2 = imgaussfilt(IGray,10);
    Edges = edge(IGray2,'sobel');
    %figure, imshow(BW1);

end

%%

%% Merge filters

for compress=1:1

    MergeMap = ones(rows,columns);

    for i = 1: rows
        for j = 1: columns  
            if (FieldMask(i,j) == 255 && Edges(i,j) == 1)
                MergeMap(i,j) = 0;
            end
        end
    end
    
    
    PlayersMask = imgaussfilt(MergeMap,10);    
    figure, imshow(PlayersMask);
    
    %Debug
    for i = 1: rows
        for j = 1: columns  
            if (PlayersMask(i,j) == 0)               
                fprintf("%i == d; j == %d\n",i,j);
            end
        end
    end
    
end

%%

%% Blob detection

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
ZeroMask = zeros(rows,columns,'uint8');
TmpBlobMap = zeros(rows,columns,'uint8');
BlobMap = zeros(rows,columns,'uint8');

global top;
global bottom;
global left;
global right;
global weight;    
SWeight = 0;

id = 1;   
BlobTotalWeight = 0;

while(1)
end

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
            
            fprintf("in\n");
            Blob(i,j,id);
            
            %We must add 30-bigger-weight condition in order to delete
            %noise. Else STD calcus won't be realistic because there were
            %too fake values           
            
                if ((top ~= 0) && (bottom ~= 0) && (left ~= 0) && (right ~= 0) && (weight > 10))
                    
                    TmpBlobMap(i,j) = id;
                    
                    Blobs(id).top = top;
                    Blobs(id).bottom = bottom;
                    Blobs(id).left = left;
                    Blobs(id).right = right;
                    Blobs(id).weight = weight;                 
                    %%%fprintf('Blob(%d,%d) has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',i,j,Blobs(id).weight,Blobs(id).top,Blobs(id).bottom,Blobs(id).right,Blobs(id).left);                
                    BlobTotalWeight = BlobTotalWeight + weight;
                    
                    BlobMap = bitor(BlobMap,TmpBlobMap);       
                    id = id+1; 
                end 
                
                TmpBlobMap = bitand(TmpBlobMap,ZeroMask);
        end
    end
end

NBlobs = id-1;
end


%%

%Profiling
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

function Blob(ii,jj,id)

    global PlayersMask;
    global Processed;
    global TmpBlobMap;
    
    global top;
    global bottom;
    global left;
    global right;
    global weight;
    
    fprintf('(%d,%d)\n',ii,jj);
    
    if(in_of_bounds(ii-1,jj)==1 && PlayersMask(ii-1,jj) == 0 && Processed(ii-1,jj) == 0)
        Processed(ii-1,jj) = 1;
        TmpBlobMap(ii-1,jj) = id;
        %%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii-1,jj));
        weight = weight +1;
        top = min(ii-1,top);
        %%%fprintf('top = %d\n',top);
        Blob(ii-1,jj,id);
    end
        
    if(in_of_bounds(ii+1,jj)==1)
        if(PlayersMask(ii+1,jj) == 0)
            if (Processed(ii+1,jj) == 0)   
        TmpBlobMap(ii+1,jj) = id;
        %%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii+1,jj));
        Processed(ii+1,jj) = 1;
        weight = weight +1;
        bottom = max(ii+1,bottom);
        %%%fprintf('bottom = %d\n',bottom);
        Blob(ii+1,jj,id);
            end
        end
    end     
    
    if(in_of_bounds(ii,jj-1)== 1 && PlayersMask(ii,jj-1) == 0 && Processed(ii,jj-1) == 0)
        TmpBlobMap(ii,jj-1) = id;        
        %%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj-1));
        Processed(ii,jj-1) = 1;
        weight = weight +1;
        left = min(jj-1,left);
        %%%fprintf('left = %d\n',left);
        Blob(ii,jj-1,id);
    end
    
    if(in_of_bounds(ii,jj+1)==1 && PlayersMask(ii,jj+1) == 0 && Processed(ii,jj+1) == 0)
        TmpBlobMap(ii,jj+1) = id;
        %%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj+1));
        Processed(ii,jj+1) = 1;
        weight = weight +1;
        right = max(jj+1,right);
        %%%fprintf('right = %d\n',right);
        Blob(ii,jj+1,id);
    end    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Merge(id,fid)

    global BlobMap;
    global Blobs;
    global FinalBlobs;
    global MarkedBlobs;
    global global_std_top;
    global global_std_bottom;
    global global_std_left;
    global global_std_right;
 

    %Iterate arround Blob(id) box and if on that positions in 
    %BlobMap is different to 0 (other id) these blobs must be merged
    %pe: TmpMergeBlob=(id,new id) recursively
    %at the end merge boundaries add to FinalBlob array
    
    for ii=Blobs(id).top:Blobs(id).bottom
        for jj=Blobs(id).left:Blobs(id).right
            
            current_Blob = BlobMap(ii,jj);
            %%fprintf('Merge: Pixel (%d,%d); current_Blob = %d AND id = %d\n',ii,jj,current_Blob, id);
            %%fprintf('Merge: Old B(%d): t=%d, b=%d, l=%d,r=%d\n',id,Blobs(id).top,Blobs(id).bottom,Blobs(id).left,Blobs(id).right);
            %%fprintf('Merge: New B(%d): t=%d, b=%d, l=%d,r=%d\n',current_Blob,Blobs(current_Blob).top,Blobs(current_Blob).bottom,Blobs(current_Blob).left,Blobs(current_Blob).right);
                
            if (current_Blob ~= 0 && current_Blob ~= id)               
                
                %Merge if only if the std of dimension between two blobs is 
                %less than global std deviation
                
                tmpTop = [Blobs(id).top,Blobs(current_Blob).top];
                tmpBottom = [Blobs(id).bottom,Blobs(current_Blob).bottom];
                tmpLeft = [Blobs(id).left,Blobs(current_Blob).left];
                tmpRight = [Blobs(id).right,Blobs(current_Blob).right];
                
                std_top = std(tmpTop);
                std_bottom = std(tmpBottom);
                std_left = std(tmpLeft);
                std_right = std(tmpRight);
                
                if(std_top < global_std_top || ...
                        std_bottom < global_std_bottom || ...
                        std_left < global_std_left || ...
                        std_right < global_std_right )
                                    
                    FinalBlobs(fid).top = min(Blobs(id).top,Blobs(current_Blob).top);
                    FinalBlobs(fid).bottom = max(Blobs(id).bottom,Blobs(current_Blob).bottom);
                    FinalBlobs(fid).left = min(Blobs(id).left,Blobs(current_Blob).left);
                    FinalBlobs(fid).right = max(Blobs(id).right,Blobs(current_Blob).right);
                    
                    %Recursive call. All contiguos Blobs of fid Blob
                    MarkedBlobs(current_Blob) = 1;
                    Merge(current_Blob,fid);
                    
                end                
                
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SetTeam()

global FinalBlobs;
global PlayerColors;
n = size(PlayerColors);

tRth = 90;
tGth = 90;
tBth = 90;

team_id = 1;

for i=1:n
    
    %If we have assigned team to i Player we don't have to iteretae through
    %him. Also, if not team assigned, first assigned counter team and then
    %iterate
    
    counter = 0;

    if (FinalBlobs(i).team == -1)
        
        FinalBlobs(i).team=team_id;
        
        %We will travell whole array if the neighbours 
        %color is inside mine with threshold && has not been proceesed
        
        for j = 1:n
            
            %fprintf("I=%d [%d,%d,%d]; J=%d [%d,%d,%d]\n",i,PlayerColors(i,1),PlayerColors(i,2),PlayerColors(i,3),j,PlayerColors(j,1),PlayerColors(j,2),PlayerColors(j,3));
            
            if (i ~= j && ...
                   (PlayerColors(i,1)+tRth > PlayerColors(j,1) && PlayerColors(i,1)-tRth < PlayerColors(j,1)) && ...
                   (PlayerColors(i,2)+tGth > PlayerColors(j,2) && PlayerColors(i,2)-tGth < PlayerColors(j,2)) && ...
                   (PlayerColors(i,3)+tBth > PlayerColors(j,3) && PlayerColors(i,3)-tBth < PlayerColors(j,3)) && ...
                   FinalBlobs(j).team < 1)                                                           

                FinalBlobs(j).team=team_id;
                counter = counter+1;
                %fprintf("SET:: Player %d is team %d\n",j,FinalBlobs(j).team); 

            end

        end
      
        team_id = team_id+1;

        if (counter == 0)
            FinalBlobs(i).team=-1;        
            team_id = team_id-1;
        end        

    end
            
   
        
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%