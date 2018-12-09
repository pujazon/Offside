%% Init
%  Get the image and show it. Set number of thread
addpath 'C:\Users\danie\Desktop\offside\img'

%Profiling
% format shortg
% c = clock

for compress=1:1
    
maxNumCompThreads(8);
%fprintf('Hilos: %d\n',maxNumCompThreads);

I = imread('test1.jpg');
TeamMap = imread('test1.jpg');
T = imread('test1.jpg');
T2 = imread('test1.jpg');

figure, imshow(I);

end

%GLOBALS
global Processed;
global BlobMap;
global TmpBlobMap;
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
% figure, subplot(3,1,1);
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

%fprintf("RGB Grass %d,%d,%d\n",max_RLevels,max_GLevels,max_BLevels);

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

Rth = 1;
Gth = 1;
Bth = 1;

FieldMask = zeros(rows,columns);
tmp_PlayersMask = zeros(rows,columns);

for i = 1: rows
    for j = 1: columns        
        
        if (abs(RChannel(i,j)- RPeak) < Rth &&...
            abs(GChannel(i,j)- GPeak) < Gth &&...
            abs(BChannel(i,j)- BPeak) < Bth &&...
            GChannel(i,j) > RChannel(i,j) &&...
            GChannel(i,j) > BChannel(i,j))    
        
            %It's grass
            tmp_PlayersMask(i,j) = 255;
            FieldMask(i,j) = 0;
        else
            FieldMask(i,j) = 255;
        end        
    end
end

%figure, imshow(FieldMask);


end

%%

%% BoundaryMask:
%  Knowing that the image has on the top the spectators and the publicity
%  and just above there is the Field, get the boundary where there is the
%  change

for compress=1:1
    
boundary = 1;
i_boundary = 0;
i = 1;

% Find Maximum Boundary Value %%
for j = 1: columns
    while(i < rows && i_boundary < 1)
        if (FieldMask(i,j) == 0 )
            i_boundary = i;
        end
        i = i+1;
    end
    
    if (i_boundary > boundary)
        boundary = i_boundary;
    end
    
    i_boundary = 0;
    i = 1;
    
end

end

%%

%% PlayersMask:
%  Merge FieldMask && Boundary in order to get PlayersMask
%  Where only Blobs (Player or set of players) are to 0 others are to 1

for compress=1:1
    
for i = 1: boundary
    for j = 1: columns
        tmp_PlayersMask(i,j) = 255;      
    end
end

global PlayersMask;
PlayersMask = tmp_PlayersMask;

%If image has quality is no needed Gaussian Blur
%figure, imshow(PlayersMask);

end

%%

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
            
            Blob(i,j,id);
            
            %We must add 30-bigger-weight condition in order to delete
            %noise. Else STD calcus won't be realistic because there were
            %too fake values           
            
                if ((weight > 30)&&(top ~= 0) && (bottom ~= 0) && (left ~= 0) && (right ~= 0) && (weight > 10))
                    
                    TmpBlobMap(i,j) = id;
                    
                    Blobs(id).top = top;
                    Blobs(id).bottom = bottom;
                    Blobs(id).left = left;
                    Blobs(id).right = right;
                    Blobs(id).weight = weight;                 
                    %%fprintf('Blob(%d,%d) has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',i,j,Blobs(id).weight,Blobs(id).top,Blobs(id).bottom,Blobs(id).right,Blobs(id).left);                
                    BlobTotalWeight = BlobTotalWeight + weight;
                    
                    BlobMap = bitor(BlobMap,TmpBlobMap);       
                    id = id+1; 
                end 
                
                TmpBlobMap = bitand(TmpBlobMap,ZeroMask);
        end
    end
end

NBlobs = id-1;


%Debug
for q=1:NBlobs
    for iii= Blobs(q).top:Blobs(q).bottom 
        for jjj = Blobs(q).left:Blobs(q).right
            T(iii,jjj,1) = 0;
            T(iii,jjj,2) = 0;
            T(iii,jjj,3) = 255;
        end
    end    
end

%imshow(T);
end


%%

%% Blob Filter
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
% 
%     %fprintf('std_weight = %d\n',std_weight);
%     %fprintf('mean_weight = %d\n',mean_weight);
%     %fprintf('std_height = %d\n',std_height);

    fid = 1;

    %If Blob height deviation is less than STD height deviation
    %means that Blob has similar height than the mean (Players)
    %so must be added as a real Blob
            
    %Only with that filter, could be vertical line which has similar height
    %than Players that pass the filter. So in order to avoid that kind of
    %noise weight filter must be also used
    
    %height filter doesn't work beacuse Player heights are too small
    %so noise has too much probabilities to be inside
    %let-height-range and pass the filter
    
    %We must make other deviation calculation:
   
    for k=1:NBlobs

         height = Blobs(k).bottom - Blobs(k).top;       
         
         if ((~((mean_weight - Blobs(k).weight) > std_weight) && ...
             ~((mean_height - height) > std_height)) || ...
                 Blobs(k).weight > mean_weight)
            
            FinalBlobs(fid) = Blobs(k);
             
            %%fprintf("[%d]::W()=%d,XW()=%d STD_W=%d,,H()=%d,STD_H=%d\n",fid,(mean_weight - Blobs(k).weight),mean_weight,std_weight,(mean_height - (Blobs(k).bottom - Blobs(k).top)),std_height);
            %fprintf('FBlob[%d](%d,%d) has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',fid,iii,jjj,FinalBlobs(fid).weight,FinalBlobs(fid).top,FinalBlobs(fid).bottom,FinalBlobs(fid).right,FinalBlobs(fid).left);                
            
            fid = fid+1;
        end
    end    

    fid = fid-1;
    
    %Debug
    for w=1:fid
        %%fprintf("I(%d)=[%d,%d,%d,%d]; r=%d,c=%d\n",w,FinalBlobs(w).top,FinalBlobs(w).left,FinalBlobs(w).bottom,FinalBlobs(w).right,(FinalBlobs(w).bottom-FinalBlobs(w).top),(FinalBlobs(w).right-FinalBlobs(w).left));        
        for iii= FinalBlobs(w).top:FinalBlobs(w).bottom 
            for jjj = FinalBlobs(w).left:FinalBlobs(w).right
                T2(iii,jjj,1) = 133;
                T2(iii,jjj,2) = 90;
                T2(iii,jjj,3) = 133;
            end
        end    
    end
    
    %fprintf('Really, there are %d Blobs!\n',fid);
    NBlobs = fid;
    imshow(T2);
end

%%

%% Team detection:
% 

PlayerColors = zeros(NBlobs,3);


for compress=1:1

      %We will work with Blob box not only with player pixels so
      %there will be field pixels noise    
      cteamA = 0;
      cteamB = 0;
      
    for k=1:NBlobs    
        
        comptador = 1;
        
        box_rows = FinalBlobs(k).bottom-FinalBlobs(k).top;
        box_columns = FinalBlobs(k).right-FinalBlobs(k).left;
        
        %We want to get mean Shirt color. So cropping the blobs as a box
        %there is too much Grass-noise. So we must erase it of histogram
        
        %The solution will be: If Grass one colour using 255 255 0 (Cyan)
        %Then we compute the Peak. IF the peak is Cyan one we take the
        %second one.
        
        for i=FinalBlobs(k).top:FinalBlobs(k).bottom
            for j=FinalBlobs(k).left:FinalBlobs(k).right
                
                    if (abs(RChannel(i,j)- max_RLevels) < Rth+255 &&...
                    abs(GChannel(i,j)- max_GLevels) < Gth+255 &&...
                    abs(BChannel(i,j)- max_BLevels) < Bth+255 &&...
                    GChannel(i,j) > RChannel(i,j) &&...
                    GChannel(i,j) > BChannel(i,j))    
                                        
                    TeamMap(i,j,1) = 0;
                    TeamMap(i,j,2) = 0;
                    TeamMap(i,j,3) = 0;
                    
                    end                    
            end
        end
        
        %coords [xmin ymin width height]
        %%fprintf("I(%d)=[%d,%d,%d,%d]; r=%d,c=%d\n",k,FinalBlobs(k).top,FinalBlobs(k).left,FinalBlobs(k).bottom,FinalBlobs(k).right,(FinalBlobs(k).bottom-FinalBlobs(k).top),(FinalBlobs(k).right-FinalBlobs(k).left));
        tmp_Player  = imcrop(TeamMap,[FinalBlobs(k).left FinalBlobs(k).top box_columns box_rows]);
        
        [tmpR,bR] = imhist(tmp_Player(:,:,1));
        [tmpG,bG] = imhist(tmp_Player(:,:,2));
        [tmpB,bB] = imhist(tmp_Player(:,:,3));             

        max_RLevels = 1;
        RPeak = 0;
        max_GLevels = 1;
        GPeak = 0;
        max_BLevels = 1;
        BPeak = 0;
        
        for i = 2:256
            if(tmpR(i) > RPeak)
                max_RLevels = i;
                RPeak = tmpR(i);
            end
            if(tmpG(i) > GPeak)
                max_GLevels = i;
                GPeak = tmpG(i);
            end
            if(tmpB(i) > BPeak)
                max_BLevels = i;
                BPeak = tmpB(i);
            end
        end

        PlayerColors(k,1) = max_RLevels;
        PlayerColors(k,2) = max_GLevels;
        PlayerColors(k,3) = max_BLevels;
        
       fprintf("Player %d color (%d,%d,%d)\n",k,PlayerColors(k,1),PlayerColors(k,2),PlayerColors(k,3));
       figure, imshow(tmp_Player);
       
    end        
    
    SetTeam();
    
    for k=1:NBlobs
        fprintf("Player %d is team %d\n",k,FinalBlobs(k).team);
    end
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
    
    %%fprintf('(%d,%d)\n',ii,jj);
    
    if(in_of_bounds(ii-1,jj)==1 && PlayersMask(ii-1,jj) == 0 && Processed(ii-1,jj) == 0)
        Processed(ii-1,jj) = 1;
        TmpBlobMap(ii-1,jj) = id;
        %%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii-1,jj));
        weight = weight +1;
        top = min(ii-1,top);
        %%fprintf('top = %d\n',top);
        Blob(ii-1,jj,id);
    end
        
    if(in_of_bounds(ii+1,jj)==1 && PlayersMask(ii+1,jj) == 0 && Processed(ii+1,jj) == 0)   
        TmpBlobMap(ii+1,jj) = id;
        %%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii+1,jj));
        Processed(ii+1,jj) = 1;
        weight = weight +1;
        bottom = max(ii+1,bottom);
        %%fprintf('bottom = %d\n',bottom);
        Blob(ii+1,jj,id);
    end     
    
    if(in_of_bounds(ii,jj-1)== 1 && PlayersMask(ii,jj-1) == 0 && Processed(ii,jj-1) == 0)
        TmpBlobMap(ii,jj-1) = id;        
        %%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj-1));
        Processed(ii,jj-1) = 1;
        weight = weight +1;
        left = min(jj-1,left);
        %%fprintf('left = %d\n',left);
        Blob(ii,jj-1,id);
    end
    
    if(in_of_bounds(ii,jj+1)==1 && PlayersMask(ii,jj+1) == 0 && Processed(ii,jj+1) == 0)
        TmpBlobMap(ii,jj+1) = id;
        %%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj+1));
        Processed(ii,jj+1) = 1;
        weight = weight +1;
        right = max(jj+1,right);
        %%fprintf('right = %d\n',right);
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
            %fprintf('Merge: Pixel (%d,%d); current_Blob = %d AND id = %d\n',ii,jj,current_Blob, id);
            %fprintf('Merge: Old B(%d): t=%d, b=%d, l=%d,r=%d\n',id,Blobs(id).top,Blobs(id).bottom,Blobs(id).left,Blobs(id).right);
            %fprintf('Merge: New B(%d): t=%d, b=%d, l=%d,r=%d\n',current_Blob,Blobs(current_Blob).top,Blobs(current_Blob).bottom,Blobs(current_Blob).left,Blobs(current_Blob).right);
                
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

tRth = 50;
tGth = 50;
tBth = 50;

team_id = 1;
counter = 0;

for i=1:n
    
    %If we have assigned team to i Player we don't have to iteretae through
    %him. Also, if not team assigned, first assigned counter team and then
    %iterate
    
    if (FinalBlobs(i).team == -1)
        
        FinalBlobs(i).team=team_id;
        
        %We will travell whole array if the neighbours 
        %color is inside mine with threshold && has not been proceesed
        for j = 1:n
            
            %fprintf("I=%d [%d,%d,%d]; J=%d [%d,%d,%d]\n",i,PlayerColors(i,1),PlayerColors(i,2),PlayerColors(i,3),j,PlayerColors(j,1),PlayerColors(j,2),PlayerColors(j,3));
            
            if (i ~= j && ...
                   (PlayerColors(i,1)+tRth > PlayerColors(j,1) && PlayerColors(i,1)-tRth < PlayerColors(j,1)) && ...
                   (PlayerColors(i,1)+tGth > PlayerColors(j,1) && PlayerColors(i,1)-tGth < PlayerColors(j,1)) && ...
                   (PlayerColors(i,1)+tBth > PlayerColors(j,1) && PlayerColors(i,1)-tBth < PlayerColors(j,1)) && ...
                   FinalBlobs(j).team < 1)
               
                fprintf("SET:: Player %d is team %d\n",j,FinalBlobs(j).team);
                FinalBlobs(j).team=team_id;

            end

        end
       
        if (counter == 0)
            FinalBlobs(i).team=-1;
        end
        
        team_id = team_id+1;
        counter = 0;
        
    end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%