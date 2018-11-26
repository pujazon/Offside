%% Init
%  Get the image and show it. Set number of thread
addpath 'F:\tfg\offside\img'
addpath 'F:\tfg\offside\img\test4_players'

for compress=1:1
    
maxNumCompThreads(8);
fprintf('Hilos: %d\n',maxNumCompThreads);

I = imread('test1.jpg');
T = imread('test1.jpg');
T2 = imread('test1.jpg');

figure, imshow(I);

end

%GLOBALS
global MarkedBlobs;
global Processed;
global BlobMap;
global TmpBlobMap;
global Blobs;
global ZeroMask;
global FinalBlobs;
global N;    
global NBlobs;    
global global_std_top;
global global_std_bottom;
global global_std_left;
global global_std_right;

N = 30;

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
%     %fprintf('Player B(%d) Greens\n',i);
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
        %fprintf('R: Value %d #pixels = %d, max = %d\n',j,auxidsR(j),PixelsRPeak);
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
%     fprintf('B(%d): RGB: (%d,%d,%d)\n',i,RPeak(i),GPeak(i),BPeak(i));
% end
fprintf('Team B RGB: (%d,%d,%d)\n',TeamB_RPeak,TeamB_GPeak,TeamB_BPeak);


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
        %fprintf('R: Value %d #pixels = %d, max = %d\n',j,auxidsR(j),PixelsRPeak);
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
%     fprintf('A(%d): RGB: (%d,%d,%d)\n',i,RPeak(i),GPeak(i),BPeak(i));
% end
fprintf('Team A RGB: (%d,%d,%d)\n',TeamA_RPeak,TeamA_GPeak,TeamA_BPeak);

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
PlayersMask = tmp_PlayersMask;

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
                    %fprintf('Blob(%d,%d) has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',i,j,Blobs(id).weight,Blobs(id).top,Blobs(id).bottom,Blobs(id).right,Blobs(id).left);                
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

fprintf('There are %d Blobs!\n',NBlobs);
imshow(T);
end


%%


%% Blob Filter
%  Calculate weight std and only will be blobs the ones that 
%  have less deviation than std. otherwise will be discarted

for compress=1:1   

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

    fprintf('std_weight = %d\n',std_weight);
    fprintf('mean_weight = %d\n',mean_weight);
    fprintf('std_height = %d\n',std_height);
  
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
        
         if ((~(abs(mean_weight - Blobs(k).weight) > std_weight) && ...
             ~(abs(mean_height - height) > std_height)) || ...
                 Blobs(k).weight > mean_weight)
             
            FinalBlobs(fid) = Blobs(k);
            fprintf('FBlob(%d,%d) has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',iii,jjj,FinalBlobs(fid).weight,FinalBlobs(fid).top,FinalBlobs(fid).bottom,FinalBlobs(fid).right,FinalBlobs(fid).left);                
            fid = fid+1;
        end
    end    

    
    fid = fid-1;
    
    %Debug
    for w=1:fid
        %fprintf('iter %d\n',w);
        for iii= FinalBlobs(w).top:FinalBlobs(w).bottom 
            for jjj = FinalBlobs(w).left:FinalBlobs(w).right
                T2(iii,jjj,1) = 255;
                T2(iii,jjj,2) = 0;
                T2(iii,jjj,3) = 255;
            end
        end    
    end
    
    fprintf('Really, there are %d Blobs!\n',fid);
    imshow(T2);
end

%%


%% Merge Blobs:
%  For each Blob if there is a neighbour too close
%  Means that is part of the same Blob so merge them
% 
% for compress=1:1
%     
%     %First calculate standrad recivation of four directions.
%     
%     Vtop = zeros(N,0);
%     Vbottom = zeros(N,0);
%     Vleft = zeros(N,0);
%     Vright = zeros(N,0);
%     
%     for k=1:N
%         Vtop(k) = Blobs(k).top;
%         Vbottom(k) = Blobs(k).bottom;
%         Vleft(k) = Blobs(k).left;
%         Vright(k) = Blobs(k).right;
%     end
% 
%     global_std_top = std(Vtop);
%     global_std_bottom = std(Vbottom);
%     global_std_left = std(Vleft);
%     global_std_right = std(Vright);
%     
%     %Set init values
%     FinalBlobs = Player.empty(N,0);
%     MarkedBlobs = zeros(N);   
%     fid = 1;
%    
%     for i=1:rows
%         for j=1:columns
%             
%             %Because all lops go from left to right and from top to left
%             %means that when we found a pixel to be processed it will be 
%             %top-left Blob box.
%             
%             current_Blob = BlobMap(i,j);
%             
%             %If there is a blob (c_Blob != 0) and has not been processed
%             %(MarkedBlob == 0) procced it, merge            
%             if (current_Blob ~=0 && MarkedBlobs(current_Blob) == 0)
%                 MarkedBlobs(current_Blob) = 1;
%                 Merge(current_Blob,fid);
%                 fid = fid+1;
%             end
%             
%         end
%     end
%     
%     fprintf('Final Blobs are %d\n',fid);
%     
% end

%%

%% Player detection:
%  For each Blob get RGB mean and standard derivation.
%  If all pixels are inside that derivation, means that on Blob there is
%  only one player. Compare it mean RGB with mean RGB Team A or B, set
%  the Team and set the Player to Output array.
%  If there is some pixels which are outside of standard derivation means
%  that there are more than one Player on Blob so we must group all pixels
%  that are near (get 1 pixel. If following pixel is 'near' set to GroupA
%  else set to GroupB). Then calculate left and right position of each
%  Group (Player) and set them individually on Output vector
% 
% for compress=1:1
% 
% sumR = 0;
% sumG = 0;
% sumB = 0;
% meanR = 0;
% meanG = 0;
% meanB = 0;
% 
% 
% for k=1:id
%     if(Blobs(k).top > 0)
%         
%         M = (Blobs(k).bottom - Blobs(k).top) * (Blobs(k).right - Blobs(k).left) ;
%         fprintf('B(%d)\n',k);
%         for i= Blobs(k).top:Blobs(k).bottom
%             for j = Blobs(k).left:Blobs(k).right 
%                 
%                 if(k < 4) 
%                 %fprintf('pixel(%d,%d) =[%d,%d,%d]\n',i,j,RChannel(i,j),GChannel(i,j),BChannel(i,j)); 
%                 %fprintf('Color k*50 = %d\n',k*50);
%                 I(i,j,1) = 255;
%                 I(i,j,2) = 0;
%                 I(i,j,3) = 0;
%                 end
%                 sumR = sumR+RChannel(i,j);
%                 sumG = sumG+GChannel(i,j);
%                 sumB = sumB+BChannel(i,j);
%             end
%         end
%         
%         meanR = floor(sumR/M);
%         meanG = floor(sumG/M);
%         meanB = floor(sumB/M);
%         
%     end
% end
% 
% end
% 
% figure, imshow(I);
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
    
    %fprintf('(%d,%d)\n',ii,jj);
    
    if(in_of_bounds(ii-1,jj)==1 && PlayersMask(ii-1,jj) == 0 && Processed(ii-1,jj) == 0)
        Processed(ii-1,jj) = 1;
        TmpBlobMap(ii-1,jj) = id;
        %fprintf('TmpBlob() = %d\n',TmpBlobMap(ii-1,jj));
        weight = weight +1;
        top = min(ii-1,top);
        %fprintf('top = %d\n',top);
        Blob(ii-1,jj,id);
    end
        
    if(in_of_bounds(ii+1,jj)==1 && PlayersMask(ii+1,jj) == 0 && Processed(ii+1,jj) == 0)   
        TmpBlobMap(ii+1,jj) = id;
        %fprintf('TmpBlob() = %d\n',TmpBlobMap(ii+1,jj));
        Processed(ii+1,jj) = 1;
        weight = weight +1;
        bottom = max(ii+1,bottom);
        %fprintf('bottom = %d\n',bottom);
        Blob(ii+1,jj,id);
    end     
    
    if(in_of_bounds(ii,jj-1)== 1 && PlayersMask(ii,jj-1) == 0 && Processed(ii,jj-1) == 0)
        TmpBlobMap(ii,jj-1) = id;        
        %fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj-1));
        Processed(ii,jj-1) = 1;
        weight = weight +1;
        left = min(jj-1,left);
        %fprintf('left = %d\n',left);
        Blob(ii,jj-1,id);
    end
    
    if(in_of_bounds(ii,jj+1)==1 && PlayersMask(ii,jj+1) == 0 && Processed(ii,jj+1) == 0)
        TmpBlobMap(ii,jj+1) = id;
        %fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj+1));
        Processed(ii,jj+1) = 1;
        weight = weight +1;
        right = max(jj+1,right);
        %fprintf('right = %d\n',right);
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
            fprintf('Merge: Pixel (%d,%d); current_Blob = %d AND id = %d\n',ii,jj,current_Blob, id);
            fprintf('Merge: Old B(%d): t=%d, b=%d, l=%d,r=%d\n',id,Blobs(id).top,Blobs(id).bottom,Blobs(id).left,Blobs(id).right);
            fprintf('Merge: New B(%d): t=%d, b=%d, l=%d,r=%d\n',current_Blob,Blobs(current_Blob).top,Blobs(current_Blob).bottom,Blobs(current_Blob).left,Blobs(current_Blob).right);
                
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