%% Init
%  Get the image and show it. Set number of thread
addpath 'C:\Users\danie\Desktop\TFG\img'
addpath 'C:\Users\danie\Desktop\TFG\img\test4_players'

for compress=1:1
    
maxNumCompThreads(8);
fprintf('Hilos: %d\n',maxNumCompThreads);

I = imread('test6.jpg');
figure, imshow(I);

end

%GLOBALS

global Processed;
global BlobMap;
global TmpBlobMap;
global Blobs;
global ZeroMask;

%%

%% MaskTeam:    
%  Get RGB mean of each RGB Peaks Team B Player 
%  Get RGB mean of each RGB Peaks Team A Player 

for k = 1:1
%Declare Variables

N=5;

TeamA = cell(1,N);
TeamB = cell(1,N);

RLevelTeamB = cell(1,N);
GLevelTeamB = cell(1,N);
BLevelTeamB = cell(1,N);

idRTeamB = cell(1,N);
idGTeamB = cell(1,N);
idBTeamB = cell(1,N);

RLevelTeamA = cell(1,N);
GLevelTeamA = cell(1,N);
BLevelTeamA = cell(1,N);

idRTeamA = cell(1,N);
idGTeamA = cell(1,N);
idBTeamA = cell(1,N);

RPeak = zeros(N);
GPeak = zeros(N);
BPeak = zeros(N);

PixelsRPeak = 0;
PixelsGPeak = 0;
PixelsBPeak = 0;


% Get Teams

%TeamA
for i = 1:N

    path = sprintf('a%d.png',i);
    TeamA{i}= imread(path);
 
end

%TeamB
for i = 1:N
       
    path = sprintf('b%d.png',i);
    TeamB{i}= imread(path);
 
end

% Get Histograms

%Take Histograms
for i = 1:N
    
    %TeamB
    [BidR, BtmpR] = imhist(TeamB{i}(:,:,1));
    [BidG, BtmpG] = imhist(TeamB{i}(:,:,2));
    [BidB, BtmpB] = imhist(TeamB{i}(:,:,3));
    
    RLevelTeamB{i} = BtmpR;
    GLevelTeamB{i} = BtmpG;
    BLevelTeamB{i} = BtmpB;     

    idRTeamB{i} = BidR;
    idGTeamB{i} = BidG;
    idBTeamB{i} = BidB;    
    
    %TeamA
    [AidR, AtmpR] = imhist(TeamA{i}(:,:,1));
    [AidG, AtmpG] = imhist(TeamA{i}(:,:,2));
    [AidB, AtmpB] = imhist(TeamA{i}(:,:,3));
    
    RLevelTeamA{i} = AtmpR;
    GLevelTeamA{i} = AtmpG;
    BLevelTeamA{i} = AtmpB;     

    idRTeamA{i} = AidR;
    idGTeamA{i} = AidG;
    idBTeamA{i} = AidB;
 
end

%Printf Histograms
% for i = 1:N
%     %fprintf("Player B(%d) Greens\n",i);
%     %idGTeamA{i}
%     
%     figure, subplot(3,1,1);
%     x = linspace(0,10,50);
%     R=[idRTeamB{i}];
%     plot(R,'r');
%     title('RED 1')
%     
%     subplot(3,1,2);
%     G=[idGTeamB{i}];
%     plot(G,'g');
%     title('GREEN 2')
%     
%     subplot(3,1,3);
%     B=[idBTeamB{i}];
%     plot(B,'b');
%     title('BLUE 3')    
%     
% end

% RGB TeamB

TeamB_RPeak = 0;
TeamB_GPeak = 0;
TeamB_BPeak = 0;

%RPeak(n), GPeak(n), BPeak(n) TeamB
for i = 1:N
    
    auxidsR = idRTeamB{i};
    auxidsG = idGTeamB{i};
    auxidsB = idBTeamB{i};
    PixelsRPeak = 0;
    PixelsGPeak = 0;
    PixelsBPeak = 0;
    
    for j = 1:255     
        %fprintf("R: Value %d #pixels = %d, max = %d\n",j,auxidsR(j),PixelsRPeak);
        if(auxidsR(j) > PixelsRPeak)
            RPeak(i) = j;
            PixelsRPeak = auxidsR(j);
        end

        if(auxidsG(j) > PixelsGPeak)
            GPeak(i) = j;
            PixelsGPeak = auxidsG(j);
        end

        if(auxidsB(j) > PixelsBPeak)
            BPeak(i) = j;
            PixelsBPeak = auxidsB(j);
        end
        
    end
    
    TeamB_RPeak = TeamB_BPeak + RPeak(i);
    TeamB_GPeak = TeamB_BPeak + GPeak(i);
    TeamB_BPeak = TeamB_BPeak + BPeak(i);
end

TeamB_RPeak = floor(TeamB_RPeak/N);
TeamB_GPeak = floor(TeamB_GPeak/N);
TeamB_BPeak = floor(TeamB_BPeak/N);

%Print R,G,B Peaks
% for i = 1:N
%     fprintf("B(%d): RGB: (%d,%d,%d)\n",i,RPeak(i),GPeak(i),BPeak(i));
% end
fprintf("Team B RGB: (%d,%d,%d)\n",TeamB_RPeak,TeamB_GPeak,TeamB_BPeak);


% RGB TeamA

TeamA_RPeak = 0;
TeamA_GPeak = 0;
TeamA_BPeak = 0;

%RPeak(n), GPeak(n), BPeak(n) TeamA
for i = 1:N
    
    auxidsR = idRTeamA{i};
    auxidsG = idGTeamA{i};
    auxidsB = idBTeamA{i};
    PixelsRPeak = 0;
    PixelsGPeak = 0;
    PixelsBPeak = 0;    
    
    for j = 1:255     
        %fprintf("R: Value %d #pixels = %d, max = %d\n",j,auxidsR(j),PixelsRPeak);
        if(auxidsR(j) > PixelsRPeak)
            RPeak(i) = j;
            PixelsRPeak = auxidsR(j);
        end

        if(auxidsG(j) > PixelsGPeak)
            GPeak(i) = j;
            PixelsGPeak = auxidsG(j);
        end

        if(auxidsB(j) > PixelsBPeak)
            BPeak(i) = j;
            PixelsBPeak = auxidsB(j);
        end
        
    end
    
    TeamA_RPeak = TeamA_RPeak + RPeak(i);
    TeamA_GPeak = TeamA_GPeak + GPeak(i);
    TeamA_BPeak = TeamA_BPeak + BPeak(i);
    
end

TeamA_RPeak = floor(TeamA_RPeak/N);
TeamA_GPeak = floor(TeamA_GPeak/N);
TeamA_BPeak = floor(TeamA_BPeak/N);

%Print R,G,B Peaks
% for i = 1:N
%     fprintf("A(%d): RGB: (%d,%d,%d)\n",i,RPeak(i),GPeak(i),BPeak(i));
% end
fprintf("Team A RGB: (%d,%d,%d)\n",TeamA_RPeak,TeamA_GPeak,TeamA_BPeak);

end

%%

%% Plotting Image Histogram:
%  Plot image histogram in order to get an image
%  that there are big acumulation of pixels in each components
%  which are grass pixels

for compress=1:1
    
figure, subplot(3,1,1);
x = linspace(0,10,50);
R=imhist(I(:,:,1));
plot(R,'r');
title('RED 1')

subplot(3,1,2);
G=imhist(I(:,:,2));
plot(G,'g');
title('GREEN 2')

subplot(3,1,3);
B=imhist(I(:,:,3));
plot(B,'b');
title('BLUE 3')

end

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
        
            tmp_PlayersMask(i,j) = 255;
            FieldMask(i,j) = 0;
        else
            FieldMask(i,j) = 255;
        end        
    end
end

figure, imshow(FieldMask);

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
PlayersMask = imgaussfilt(tmp_PlayersMask,1);

%If image has quality is no needed Gaussian Blur

figure, imshow(PlayersMask);

end

%%

%% Blob detection:
%  Detect all Blobs, filtered by size (not too much pixels means is no a
%  Blob) and store them into a Matrix where each row is one Blob and
%  columns are each one of pixels where even positions are the row (i)
%  and their respectives consecutive odd positions are the column (j) 
%  where pixel is on image

for compress=1:1

Blobs = Player.empty(23,0);
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
            
top = 0;
bottom = 0;
left = 0;
right = 0;
weight = 1;
id = 1;   

%Blob Detection
for i = 1: rows
    for j = 1: columns        
        if (PlayersMask(i,j) == 0 && Processed(i,j) == 0)
            
            Processed(i,j) = 1;
            Blob(i,j,id);
            
            %Hay que refinarlo. 1 pixel ya es un blob. 
            %Ha de haber un mínim de pixels cjt                        
            % ahora > 10 pxls pero s'ha de fer be amb la mitjana i les
            % desviacions
            
                if ((top ~= 0) && (bottom ~= 0) && (left ~= 0) && (right ~= 0) && (weight > 10))
                    
                    TmpBlobMap(i,j) = id;
                    
                    Blobs(id).top = top;
                    Blobs(id).bottom = bottom;
                    Blobs(id).left = left;
                    Blobs(id).right = right;
                    Blobs(id).weight = weight;                 
                    fprintf("Blob(%d,%d) has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n",i,j,Blobs(id).weight,Blobs(id).top,Blobs(id).bottom,Blobs(id).right,Blobs(id).left);                
                             
                    BlobMap = bitor(BlobMap,TmpBlobMap);       
                    id = id+1;                    
                end 
                
                %C = bitand(A,B) Use BlobMap as argument because soruce
                %cannot be the same as target 
                TmpBlobMap = bitand(TmpBlobMap,ZeroMask);
                
                top = 0;
                bottom = 0;
                left = 0;
                right = 0;
                weight = 1;
        end
    end
end

id = id-1;
fprintf("There are %d Blobs!\n",id);

end

%%

%% Merge Blobs:
%  For each Blob if there is a neighbour too close
%  Means that is part of the same Blob so merge them

for compress=1:1
    
    %Blob iterator    
    k = 1;
    trobat = 0;        
   
    for i=1:rows
        for j=1:columns
            
            %Because all llops go from left to right and from top to left
            %means that when we found a Processd pixel it must be the
            %top-left boundary and we can know which Blob is comparing the 
            %current i,j with top-left pixel
            
            if (BlobMap(i,j)~=0)
                %fprintf("Pixel %d,%d is id %d\n",i,j,BlobMap(i,j));
                
                %Blobs.size == 23;
                while (trobat == 0 && k < 22)
                    
                    %Must be a Blob
                    if (Blobs(k).top ~= -1)
                        %fprintf("K is %d\n",k);
                        x = Blobs(k).top;
                        y = Blobs(k).left;

                        %fprintf("top-left is (%d,%d) i'm on (%d,%d)\n",y,x,i,j);
                        
                        %we must process when we find it:
                        %Merge nearest blobs and store it on FinalBlobs array
                        %(!) Miss 1 condition: & not Merged.
                        %if merged we don't have to proceed it.
                        
                        if(x == i && y == j)
                            %fprintf("top-left is (%d,%d) i'm on (%d,%d)\n",y,x,i,j);
                            Merge(k);
                            trobat = 1;
                        end

                        k = k+1;
                    end
                    
                end
                
                trobat = 0;               
                k = 1;
                
            end            
            
        end
    end
    
end

%%

%% Player detection:
%  For each Blob get RGB mean and standard derivation.
%  If all pixels are inside that derivation, means that on Blob there is
%  only one player. Compare it mean RGB with mean RGB Team A or B, set
%  the Team and set the Player to Output array.
%  If there is some pixels which are outside of standard derivation means
%  that there are more than one Player on Blob so we must group all pixels
%  that are near (get 1 pixel. If following pixel is "near" set to GroupA
%  else set to GroupB). Then calculate left and right position of each
%  Group (Player) and set them individually on Output vector

for compress=1:1

sumR = 0;
sumG = 0;
sumB = 0;
meanR = 0;
meanG = 0;
meanB = 0;


for k=1:id
    if(Blobs(k).top > 0)
        
        M = (Blobs(k).bottom - Blobs(k).top) * (Blobs(k).right - Blobs(k).left) ;
        fprintf("B(%d)\n",k);
        for i= Blobs(k).top:Blobs(k).bottom
            for j = Blobs(k).left:Blobs(k).right 
                
                if(k < 4) 
                %fprintf("pixel(%d,%d) =[%d,%d,%d]\n",i,j,RChannel(i,j),GChannel(i,j),BChannel(i,j)); 
                %fprintf("Color k*50 = %d\n",k*50);
                I(i,j,1) = 255;
                I(i,j,2) = 0;
                I(i,j,3) = 0;
                end
                sumR = sumR+RChannel(i,j);
                sumG = sumG+GChannel(i,j);
                sumB = sumB+BChannel(i,j);
            end
        end
        
        meanR = floor(sumR/M);
        meanG = floor(sumG/M);
        meanB = floor(sumB/M);
        
    end
end

end

figure, imshow(I);
%%

%% Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ret = in_of_bounds(i,j)    
    global rows;
    global columns;

    ret = (i > 0 && j > 0 && i < rows && j < columns );
    
end

function Blob(ii,jj,id)

    global PlayersMask;
    global Processed;
    global TmpBlobMap;
    
    global top;
    global bottom;
    global left;
    global right;
    global weight;
    
    if(in_of_bounds(ii-1,jj)==1 && PlayersMask(ii-1,jj) == 0 && Processed(ii-1,jj) == 0)
        Processed(ii-1,jj) = 1;
        TmpBlobMap(ii-1,jj) = id;
        fprintf("TmpBlob() = %d\n",TmpBlobMap(ii-1,jj));
        weight = weight +1;
        top = ii-1;
        Blob(ii-1,jj,id);
    end
        
    if(in_of_bounds(ii+1,jj)==1 && PlayersMask(ii+1,jj) == 0 && Processed(ii+1,jj) == 0)   
        TmpBlobMap(ii+1,jj) = id;
        fprintf("TmpBlob() = %d\n",TmpBlobMap(ii+1,jj));
        Processed(ii+1,jj) = 1;
        weight = weight +1;
        bottom = ii+1;
        Blob(ii+1,jj,id);
    end     
    
    if(in_of_bounds(ii,jj-1)== 1 && PlayersMask(ii,jj-1) == 0 && Processed(ii,jj-1) == 0)
        TmpBlobMap(ii,jj-1) = id;        
        fprintf("TmpBlob() = %d\n",TmpBlobMap(ii,jj-1));
        Processed(ii,jj-1) = 1;
        weight = weight +1;
        left = jj-1;
        Blob(ii,jj-1,id);
    end
    
    if(in_of_bounds(ii,jj+1)==1 && PlayersMask(ii,jj+1) == 0 && Processed(ii,jj+1) == 0)
        TmpBlobMap(ii,jj+1) = id;
        fprintf("TmpBlob() = %d\n",TmpBlobMap(ii,jj+1));
        Processed(ii,jj+1) = 1;
        weight = weight +1;
        right = jj+1;
        Blob(ii,jj+1,id);
    end    
end

function Merge(id)

    global BlobMap;
    global Blobs;

    %Iterate arround Blob(id) box and if on that positions in 
    %BlobMap is different to 0 (other id) these blobs must be merged
    %pe: TmpMergeBlob=(id,new id) recursively
    %at the end merge boundaries add to FinalBlob array
    
    for ii=Blobs(id).top:Blobs(id).bottom
        for jj=Blobs(id).left:Blobs(id).right
            
            %fprintf("look is merge in Blob(%d): Map(%d,%d) = %d\n",id,ii,jj,BlobMap(ii,jj));
            if (BlobMap(ii,jj) ~= 0)
                
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%