%% TOP Camera
%  Get the image and show it. Set number of thread
addpath '/home/pujazon/Escriptori/Offside/PlayerDetection/top/testcases'
%addpath 'C:\Users\danie\Desktop\TFG\Offside\PlayerDetection\top\testcases'

%TODO: Cannot load all .h files that are on ubuntu /usr/libs
% pe: 'sys/socket.h'
%So Matlab should be run in Ubuntu

%loadlibrary('lib_Server','listener.h');
%Profiling
format shortg
c = clock
%codegen -config:lib listener -report



for compress=1:1
    
maxNumCompThreads(16);
%%%%fprintf('Hilos: %d\n',maxNumCompThreads);
I = imread('m_009.jpg');
Ori = imread('m_009.jpg');

figure, imshow(Ori);


end

%GLOBALS
global Processed;
global TmpBlobMap;
global PlayersMask;
global MergeMap;
global R_MergeMap;
global G_MergeMap;
global B_MergeMap;
global Blobs;
global N;    
global NBlobs;   

global rows;
global columns;
global top_field; 
global bottom_field;  
global right_field;  
global left_field; 
global FieldMask;

global top;
global bottom;
global left;
global right;
global weight;

%Camera units in cm
camera_width = 50;
camera_height = 50;

global x_cm_per_pixel;
global y_cm_per_pixel;
rows = size(I,1);
columns = size(I,2);

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
%%%fprintf("RGB Grass %d,%d,%d\n",max_RLevels,max_GLevels,max_BLevels);

%% Preprocessing
%  FieldMask:
%  Apply thresholding with Grass mean color and offset
%  FieldBoundaries:
%  Image is bigger than field and we only want to process the blobs inside field 
%  so must be found field boundaries

for compress=1:1
%     
% rows = size(I,1);
% columns = size(I,2);
% 
% RChannel = I(:,:,1);
% GChannel = I(:,:,2);
% BChannel = I(:,:,3);
% 
% %Are hardcoded but must be set dinamically
% Rth = 50;
% Gth = 50;
% Bth = 50;
% 
% FieldMask = zeros(rows,columns);
% tmp_PlayersMask = zeros(rows,columns);
% 
% for i = 1: rows
%     for j = 1: columns                        
% %        %fprintf("RGB Grass %d,%d,%d\n",abs(RChannel(i,j)),abs(GChannel(i,j)),abs(BChannel(i,j)));        
% %        %fprintf("Shirt color %d,%d,%d\n",max_RLevels,max_GLevels,max_BLevels);
% %        %fprintf("Diff RGB Grass %d,%d,%d\n",diff_abs(RChannel(i,j),max_RLevels),diff_abs(GChannel(i,j),max_GLevels),diff_abs(BChannel(i,j),max_BLevels));        
%         if (diff_abs(RChannel(i,j),max_RLevels) < Rth &&...
%             diff_abs(GChannel(i,j),max_GLevels) < Gth &&...
%             diff_abs(BChannel(i,j),max_BLevels) < Bth )   
%         
%             %It's grass
%             tmp_PlayersMask(i,j) = 255;
%         else
%             FieldMask(i,j) = 255;
%         end        
%     end
% end
% 
%  PlayersMask = tmp_PlayersMask;
%  figure, imshow(PlayersMask);
%  
%  %Field Boundaries
% %  find_top();
% %  find_bottom();
% %  find_right();
% %  find_left();
% %  TODO:  They don't work because now there is no axis with all pixels being field
% 
% top_field = 357; 
% bottom_field = 2100;
% left_field = 1024;
% right_field = 2400;
%  
%  fprintf('find_top: %d\n',top_field);
%  fprintf('bottom_field: %d\n',bottom_field);
%  fprintf('left_field: %d\n',left_field);
%  fprintf('right_field: %d\n',right_field);
%  
end

%% Edge detection
%Not needed. Adds more problems than solutions

 for compress=1:1

    IGray = rgb2gray(I);
    Gray2 = imgaussfilt(IGray,10);
    Edges = edge(IGray,'sobel');
    figure, imshow(Edges);

end

%Merge filters

for compress=1:1

    auxField = ones(rows,columns);
    Processed = zeros(rows,columns);

    
    for i = 1: rows
        for j = 1: columns  
            if (Edges(i,j) == 1)
                auxField(i,j) = 0;
            end
        end
    end
    
    %%PlayersMask = MergeMap;
    auxField2 = imgaussfilt(auxField,30);
    MergeMap = convertBinImage2RGB(auxField2);
    figure, imshow(MergeMap);
    
    R_MergeMap = MergeMap(:,:,1); 
    G_MergeMap = MergeMap(:,:,2);
    B_MergeMap = MergeMap(:,:,3);
    mii = floor(rows/2);
    mjj = floor(columns/2);
    
    find_boundary(mii,mjj);
     
     fprintf('find_top: %d\n',top_field);
     fprintf('bottom_field: %d\n',bottom_field);
     fprintf('left_field: %d\n',left_field);
     fprintf('right_field: %d\n',right_field);
    
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

%Weight threshold. or put it after too many examples or do it dinamically
%Difficult to do it dinamically. It will be hardcoded but must be good
%justifyed

minWeight = 1000;

id = 1;   
BlobTotalWeight = 0;

%Blob Detection
for i = top_field+1: bottom_field
    for j = left_field+1: right_field                    
        
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

                    Blobs(id).top = top-top_field;
                    Blobs(id).bottom = bottom-top_field;
                    Blobs(id).left = left-left_field;
                    Blobs(id).right = right-left_field;
                    Blobs(id).weight = weight;   
                    Blobs(id).width = right-left;   
                    Blobs(id).height = bottom-top;                 
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
%  Filter noise-blobs and
%  Merge overlapped blobs.

for compress=1:1   

    %Filter1: width > 3*height || height > 3*width
    % Blobs are top-head view so they are similar to a circle.
    % then the blob box is similar to square. (width similar to height)
    
    %Filter2: weight << box_weght
    % If condition above is not satisfied means that there is a lot of
    % dispersation of pixels on the blob and players head fit inside blob
    % box so there is no dispersation

    FinalBlobs = Player.empty(NBlobs,0);
    %maxWeight = 1000;
    
    %Ini calculus varaibles     
    sum = 0;
    sum2 = 0;
    
    %Weight Mean calculus
    for k=1:NBlobs               
        sum = sum + Blobs(k).width;   
        sum2 = sum2 + Blobs(k).height;
    end
    
    mean_width = floor(sum/NBlobs);
    mean_height = floor(sum2/NBlobs);

    %Width and height STD Calculus
    for k=1:NBlobs  
        tmp  = diff_abs(Blobs(k).width,mean_width);
        tmp2 = tmp*tmp;
        sum  = sum+tmp2;
           
        aux  = diff_abs(Blobs(k).height,mean_height);
        aux2 = aux*aux;
        sum2 = sum2+aux2;        
        
    end
    
    %Finish Weight STD Calculus
    tmp = floor(sum/(NBlobs-1));
    tmp2= sqrt(tmp);
    std_width = floor(tmp2);
    
    aux = floor(sum2/(NBlobs-1));
    aux2= sqrt(aux);
    std_height = floor(aux2);  

    %fprintf('std_width = %d\n',std_width);
    %fprintf('mean_width = %d\n',mean_width);
    %fprintf('std_height = %d\n',std_height);
    %fprintf('mean_height = %d\n',mean_height);

    fid = 1;
   
    for k=1:NBlobs
        
        %reorder conditional statements in order to impreove performance.
        %also, mean_weight can be processed befeore on Blob, loop fusion
        std_width_i = diff_abs(Blobs(k).width,mean_width);
        std_height_i= diff_abs(Blobs(k).height,mean_height);
        
        blob_box_weight = floor(Blobs(k).width*Blobs(k).height);
        
        %fprintf('std_height_i = %d\n',std_height_i);
        %fprintf('std_width_i = %d\n',std_width_i);
        
        %Processed output shows the curve of camera.
        %this origins that center players will have less pixels
        %than the others, so probablly std_i won't be correct.

         %if ((std_height_i < std_height || std_width_i < std_width))            
         if((Blobs(k).width < 2*Blobs(k).height && ...
                 Blobs(k).height < 2*Blobs(k).width)&&...
             (Blobs(k).weight > floor(blob_box_weight/2))...
             )             
            FinalBlobs(fid) = Blobs(k);                        
            fid = fid+1;
        end
    end    

    fid = fid-1;
    
    %Debug
    for w=1:fid
        %%%%%fprintf("I(%d)=[%d,%d,%d,%d]; r=%d,c=%d\n",w,FinalBlobs(w).top,FinalBlobs(w).left,FinalBlobs(w).bottom,FinalBlobs(w).right,(FinalBlobs(w).bottom-FinalBlobs(w).top),(FinalBlobs(w).right-FinalBlobs(w).left));        
        for iii= FinalBlobs(w).top:FinalBlobs(w).bottom 
            for jjj = FinalBlobs(w).left:FinalBlobs(w).right
                I(iii,jjj,1) = 234;
                I(iii,jjj,2) = 34;
                I(iii,jjj,3) = 234;
            end
        end    
    end
    
    %fprintf('Really, there are %d Blobs!\n',fid);
    NBlobs = fid;
    imshow(I);
end

%% Coordinates
% Get each player's coordinates assuming orthogonal camera (unreal)

for compress=1:1
%TODO: Player Pixels must be passed to field coordinates;
field_width = right_field - left_field;
field_height = bottom_field - top_field;
    
x_cm_per_pixel = (camera_width/field_width);
y_cm_per_pixel = (camera_height/field_height);

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

format shortg
c = clock

%% Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = in_of_bounds(i,j)    
    global rows; 
    global columns;
    
    ret = (i > 1 && j > 1 && i < rows && j < columns);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = diff_abs(a,b)    
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
        %%%%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii+1,jj));
        Processed(ii+1,jj) = 1;
        weight = weight +1;        
        bottom = max(ii+1,bottom);
        %fprintf('bottom = %d\n',bottom);
        Blob(ii+1,jj);
    end  
            
    if(in_of_bounds(ii,jj-1)== 1 && PlayersMask(ii,jj-1) == 0 && Processed(ii,jj-1) == 0)     
        %%%%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj-1));
        Processed(ii,jj-1) = 1;
        weight = weight +1;        
        left = min(jj-1,left);
        %fprintf('left = %d\n',left);
        Blob(ii,jj-1);
    end
    
    if(in_of_bounds(ii,jj+1)==1 && PlayersMask(ii,jj+1) == 0 && Processed(ii,jj+1) == 0)
        %%%%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj+1));
        Processed(ii,jj+1) = 1;
        weight = weight +1; 
        right = max(jj+1,right);
        %fprintf('right = %d\n',right);
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
        
        while (field_row == 1 && jj < columns-1)
            if (FieldMask(ii,jj) ~= 0)
                field_row = 0;
            end            
            jj = jj+1;
            %%fprintf("(%d,%d)\n",ii,jj);
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
        
        while (field_row == 1 && jj < columns-1)
            if (FieldMask(ii,jj) ~= 0)
                field_row = 0;
            end            
            jj = jj+1;
            %%fprintf("(%d,%d)\n",ii,jj);
        end
        
        if (field_row == 1)
            trobat = 1;
            bottom_field = ii;
        end
        ii=ii-1;
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function find_right()

    global columns;
    global top_field; 
    global bottom_field; 
    global right_field;      
    global FieldMask; 
    
    jj = columns-1;
    trobat = 0;
    
    while(trobat == 0 && jj > 1)
        ii = top_field;
        field_row = 1;
        
        while (field_row == 1 && (ii < bottom_field-1))
            if (FieldMask(ii,jj) ~= 0)
                field_row = 0;
            end            
            ii = ii+1;
            %%fprintf("(%d,%d)\n",ii,jj);
        end
        
        if (field_row == 1)
            trobat = 1;
            right_field = jj;
        end
        
        jj=jj-1;
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function find_left()

    global columns;
    global top_field; 
    global bottom_field; 
    global left_field;      
    global FieldMask; 
    
    jj = 1;
    trobat = 0;
    
    while(trobat == 0 && jj < columns)
        ii = top_field;
        field_row = 1;
        
        while (field_row == 1 && ii < bottom_field)
            if (FieldMask(ii,jj) ~= 0)
                field_row = 0;
            end            
            ii = ii+1;
            %%fprintf("(%d,%d)\n",ii,jj);
        end
        
        if (field_row == 1)
            trobat = 1;
            left_field = jj;
        end
        
        jj=jj+1;
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = x_coords_from_camera_to_real(x_camera_coord)

    global x_cm_per_pixel;

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
function ret = isField(ii,jj)
    global R_MergeMap;
    global G_MergeMap;
    global B_MergeMap;
    
    error = 10;
    
    ret = (R_MergeMap(ii,jj) > 255-error &&...
        G_MergeMap(ii,jj) > 255-error &&...
        B_MergeMap(ii,jj) > 255-error);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function find_boundary(ii,jj)

    global MergeMap;
    global Processed;
    global field_top;
    global field_bottom;
    global field_left;
    
    fprintf('ii = %d; jj = %d; V == %d\n',ii,jj,MergeMap(ii,jj));
    
    if(in_of_bounds(ii,jj-1)==1 && isField(ii,jj-1) == 1 && Processed(ii,jj-1) == 0) 
        
        fprintf('MergeMap() = %d\n',MergeMap(ii,jj-1));
        Processed(ii+1,jj) = 1;       
        field_left = min(jj-1,field_left);
        %fprintf('bottom = %d\n',bottom);
        find_boundary(ii,jj-1);        
    end  
        
    if(in_of_bounds(ii+1,jj)==1 && isField(ii+1,jj) ==  1 && Processed(ii+1,jj) == 0) 
        fprintf('MergeMap() = %d\n',MergeMap(ii+1,jj));
        Processed(ii+1,jj) = 1;       
        field_top = min(ii+1,field_top);
        %fprintf('bottom = %d\n',bottom);

        find_boundary(ii+1,jj);

    end  
                    
    if(in_of_bounds(ii-1,jj)==1 && isField(ii-1,jj) ==  1 && Processed(ii-1,jj) == 0) 
        fprintf('MergeMap() = %d\n',MergeMap(ii+1,jj));
        Processed(ii-1,jj) = 1;       
        field_bottom = max(ii-1,field_bottom);
        %fprintf('bottom = %d\n',bottom);        

        find_boundary(ii-1,jj);
    end  
    
    fprintf("end\n");
            
end

function [RGB_Image] = convertBinImage2RGB(BinImage)
  RGB_Image = uint8( BinImage(:,:,[1 1 1]) * 255 );
end
