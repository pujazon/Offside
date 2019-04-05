%% TOP Camera
%  Get the image and show it. Set number of thread


classdef ini
   properties
      top = 1;
   end
   methods(Static)

        function res=getPlayersMatrix()
            
            %addpath '/home/pujazon/Escriptori/Offside/tests/PlayerDetection/'
            %addpath '/home/pujazon/Escriptori/Offside/MainNode/bin/testcases'
			addpath 'C:\Users\danie\Desktop\TFG\Offside\test\PlayerDetection\'
            
            %Profiling
            format shortg
            c = clock

            %GLOBALS
            global Processed;
            global TmpBlobMap;
            global PlayersMask;
            global Blobs;
            global Ball;
            global N;    
            global NBlobs; 
            global FinalBlobs;

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
            
            global row_avg;
            global col_avg;
            
            global R_Ball;
            global G_Ball;
            global B_Ball;
            global Ball_th;

            R_Ball=159;
            G_Ball=136;
            B_Ball=165;
            
            Ball_th = 20;
            
            %Camera units in cm
            camera_width = 50;
            camera_height = 50;

            global x_cm_per_pixel;
            global y_cm_per_pixel;
            global y_pixel_per_cm;
            global x_pixel_per_cm;  
            
            global Ori;
            
            N = 30;

            for compress=1:1

            maxNumCompThreads(16);
            %%%%%fprintf('Hilos: %d\n',maxNumCompThreads);

            I = imread('top.ppm');
            Ori = imread('top.ppm');

            figure, imshow(Ori);

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
            fprintf("RGB Grass %d,%d,%d\n",max_RLevels,max_GLevels,max_BLevels);

            %% Preprocessing
            %  FieldMask:
            %  Apply thresholding with Grass mean color and offset
            %  FieldBoundaries:
            %  Image is bigger than field and we only want to process the blobs inside field 
            %  so must be found field boundaries

            for compress=1:1

            rows = size(I,1);
            columns = size(I,2);
                        
            row_avg = floor(rows*0.5);
            col_avg = floor(columns*0.5);

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
            %        %%fprintf("RGB Grass %d,%d,%d\n",abs(RChannel(i,j)),abs(GChannel(i,j)),abs(BChannel(i,j)));        
            %        %%fprintf("Shirt color %d,%d,%d\n",max_RLevels,max_GLevels,max_BLevels);
            %        %%fprintf("Diff RGB Grass %d,%d,%d\n",diff_abs(RChannel(i,j),max_RLevels),diff_abs(GChannel(i,j),max_GLevels),diff_abs(BChannel(i,j),max_BLevels));        
            
            %       With three last conditions we delte White and black
            %       pixels which can pass through first conditions.
            %       Third is an empiristic one

                        
            
                    %TODO: Field lines
%                    if(RChannel(i,j) > 190 &&...
%                         GChannel(i,j) > 190 &&...
%                         BChannel(i,j) > 190)                                                        
%                         FieldMask(i,j) = 0;
%                     else

                    if (diff_abs(RChannel(i,j),max_RLevels) < Rth &&...
                        diff_abs(GChannel(i,j),max_GLevels) < Gth &&...
                        diff_abs(BChannel(i,j),max_BLevels) < Bth && ...
                        RChannel(i,j) < GChannel(i,j) &&...
                        RChannel(i,j) < BChannel(i,j) &&...
                        RChannel(i,j) < 50)   

                        %It's grass
                        tmp_PlayersMask(i,j) = 255;
                        
                    else
                        FieldMask(i,j) = 255;
                    end  
                   %end
                end
            end

             PlayersMask = tmp_PlayersMask;
             figure, imshow(PlayersMask);
             %figure, imshow(FieldMask);

             %Field Boundaries
              find_top();
              fprintf('find_top: %d\n',top_field);
              find_bottom();
              fprintf('bottom_field: %d\n',bottom_field);
              find_right();
              fprintf('right_field: %d\n',right_field);
              find_left();
              fprintf('left_field: %d\n',left_field);                                             

            end


            %% Blob detection:
            %  Detect all Blobs, filtered by size (not too much pixels means is no a
            %  Blob) and store them into a Matrix where each row is one Blob and
            %  columns are each one of pixels where even positions are the row (i)
            %  and their respectives consecutive odd positions are the column (j) 
            %  where pixel is on image

            for compress=1:1

            Blobs = Player.empty(N,0);
            Ball = Player.empty(1,0);
            Processed = zeros(rows,columns);

            %Initial set. Each position stores 0 (== no player)
            TmpBlobMap = zeros(rows,columns,'uint8');

            %Weight threshold. or put it after too many examples or do it dinamically
            %Difficult to do it dinamically. It will be hardcoded but must be good
            %justifyed

            minWeight = 300;

            id = 1;   

            %Blob Detection
            for i = top_field+2: bottom_field-2
                for j = left_field+2: right_field-2                    

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

                            if ((top ~= 0) && (bottom ~= 0) && (left ~= 0) && (right ~= 0)...
                                    && (weight > minWeight) && isBall() == 0)
%                             
%                                 if(isBall())
%                                     Ball(1).top = top;
%                                     Ball(1).bottom = bottom;
%                                     Ball(1).left = left;
%                                     Ball(1).right = right;  
%                                     Ball(1).weight = weight;   
%                                     Ball(1).width = right-left;   
%                                     Ball(1).height = bottom-top; 
%                                     fprintf('Ball has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',Ball(1).weight,Ball(1).top,Ball(1).bottom,Ball(1).right,Ball(1).left);                                    
%                                 else
                                    
                                Blobs(id).top = top;
                                Blobs(id).bottom = bottom;
                                Blobs(id).left = left;
                                Blobs(id).right = right;
                                Blobs(id).weight = weight;   
                                Blobs(id).width = right-left;   
                                Blobs(id).height = bottom-top;                 
                                fprintf('Blob(%d,%d) has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',i,j,Blobs(id).weight,Blobs(id).top,Blobs(id).bottom,Blobs(id).right,Blobs(id).left);                                    
                                id = id+1;
                                %end
                                
                            end 

                    end       

                end
            end

            NBlobs = id-1;
            %%figure, imshow(Processed); 

            end
            
            %% Ball Detection
            %  First get the Candidates
            %  Compare with precalculated mean histogram.
            
            for compress=1:1
            
            [centers, radii, metric] = imfindcircles(Ori,[1 20]);
            ncenter = centers(1:10,:);
            nradio = radii(1:10);
            viscircles(ncenter, nradio,'EdgeColor','b');      
            
            N2 = size(ncenter);
            
            for i=1:N2               
                
                ycenter = floor(ncenter(i,1));
                xcenter = floor(ncenter(i,2));
                radio   = floor(nradio(i));
                
                btop    = (xcenter-radio);
                bbottom = (xcenter+radio);
                bleft   = (ycenter-radio);
                bright  = (ycenter+radio);
                
                %checkHistogram
                isBall = 0;
                Rc = uint32(0);
                Gc = uint32(0);
                Bc = uint32(0);
                Np = uint32(0);

                RM = Ori(:,:,1); 
                GM = Ori(:,:,2); 
                BM = Ori(:,:,3);

                for iii=btop:bbottom
                    for jjj=bleft:bright
                        if (PlayersMask(i,j) == 0)
                            Rc = Rc+uint32(RM(iii,jjj));
                            Gc = Gc+uint32(GM(iii,jjj));
                            Bc = Bc+uint32(BM(iii,jjj));
                            Np = Np+1;
                        end
                    end
                end

                Rh = floor(Rc/Np);
                Gh = floor(Gc/Np);
                Bh = floor(Bc/Np); 


                if (diff_abs(Rh,R_Ball) < Ball_th &&...
                diff_abs(Gh,G_Ball) < Ball_th &&...
                diff_abs(Bh,B_Ball) < Ball_th)
                    isBall = 1;
                end
                
                %fprintf("Ball candidate %d POS: [%d,%d,%d,%d] RGB: [%d,%d,%d]\n",i,btop,bbottom,bleft,bright,Rh,Gh,Bh);
                if(isBall == 1)

                 Ball(1).top = btop;
                 Ball(1).bottom = bbottom;
                 Ball(1).left = bleft;
                 Ball(1).right = bright;                    
                    
                for ii=btop:bbottom
                    for jj=bleft:bright
                            I(ii,jj,1) = 130;
                            I(ii,jj,2) = 130;
                            I(ii,jj,3) = 130;  
                    end
                end
                end
                                               
            end
      
            imshow(I);
                  
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

                %%fprintf('std_width = %d\n',std_width);
                %%fprintf('mean_width = %d\n',mean_width);
                %%fprintf('std_height = %d\n',std_height);
                %%fprintf('mean_height = %d\n',mean_height);

                fid = 1;

                for k=1:NBlobs

                    %reorder conditional statements in order to impreove performance.
                    %also, mean_weight can be processed befeore on Blob, loop fusion
                    std_width_i = diff_abs(Blobs(k).width,mean_width);
                    std_height_i= diff_abs(Blobs(k).height,mean_height);

                    blob_box_weight = floor(Blobs(k).width*Blobs(k).height);

                    %%fprintf('std_height_i = %d\n',std_height_i);
                    %%fprintf('std_width_i = %d\n',std_width_i);

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
                    %%%%%%fprintf("I(%d)=[%d,%d,%d,%d]; r=%d,c=%d\n",w,FinalBlobs(w).top,FinalBlobs(w).left,FinalBlobs(w).bottom,FinalBlobs(w).right,(FinalBlobs(w).bottom-FinalBlobs(w).top),(FinalBlobs(w).right-FinalBlobs(w).left));        
                    for iii= FinalBlobs(w).top:FinalBlobs(w).bottom 
                        for jjj = FinalBlobs(w).left:FinalBlobs(w).right
                            I(iii,jjj,1) = 234;
                            I(iii,jjj,2) = 34;
                            I(iii,jjj,3) = 234;
                        end
                    end    
                end
                %Debug
                    %%%%%%fprintf("I(%d)=[%d,%d,%d,%d]; r=%d,c=%d\n",w,FinalBlobs(w).top,FinalBlobs(w).left,FinalBlobs(w).bottom,FinalBlobs(w).right,(FinalBlobs(w).bottom-FinalBlobs(w).top),(FinalBlobs(w).right-FinalBlobs(w).left));        
                    for iii= Ball(1).top:Ball(1).bottom 
                        for jjj = Ball(1).left:Ball(1).right
                            I(iii,jjj,1) = 100;
                            I(iii,jjj,2) = 100;
                            I(iii,jjj,3) = 50;
                        end
                    end   

                %%fprintf('Really, there are %d Blobs!\n',fid);
                NBlobs = fid;
                imshow(I);
            end

            %% Coordinates
            % Get each player's coordinates assuming orthogonal camera (unreal)

            for compress=1:1
            %TODO: Player Pixels must be passed to field coordinates;
            field_width = right_field - left_field;
            field_height = bottom_field - top_field;

            x_cm_per_pixel = round(camera_width/field_width,5);
            y_cm_per_pixel = round(camera_height/field_height,5);
            x_pixel_per_cm = round(field_width/camera_width,5);
            y_pixel_per_cm = round(field_height/camera_height,5);
                
            %fprintf("x_cm_per_pixel = %d\n",x_cm_per_pixel);
            %fprintf("y_cm_per_pixel = %d\n",y_cm_per_pixel);
            %fprintf("x_pixel_per_cm = %d\n",x_pixel_per_cm);
            %fprintf("y_pixel_per_cm = %d\n",y_pixel_per_cm);

            for id=1:NBlobs

				%fprintf("top = %d\n",top);
				%fprintf("bottom = %d\n",bottom);
				%fprintf("left  = %d\n",left);
				%fprintf("right  = %d\n",right);
%                 
%                 top = y_coords_from_camera_to_real(FinalBlobs(id).top);
%                 bottom = y_coords_from_camera_to_real(FinalBlobs(id).bottom);
%                 left = x_coords_from_camera_to_real(FinalBlobs(id).left);
%                 right = x_coords_from_camera_to_real(FinalBlobs(id).right);
%             
% 				%fprintf("top = %d\n",top);
% 				%fprintf("bottom = %d\n",bottom);
% 				%fprintf("left  = %d\n",left);
% 				%fprintf("right  = %d\n",right);
% 
%                 FinalBlobs(id).top = top;
%                 FinalBlobs(id).bottom = bottom;
%                 FinalBlobs(id).left = left;
%                 FinalBlobs(id).right = right;

				%fprintf("top = %d\n",top);
				%fprintf("bottom = %d\n",bottom);
				%fprintf("left  = %d\n",left);
				%fprintf("right  = %d\n",right);

                FinalBlobs(id).width = right-left;   
                FinalBlobs(id).height = bottom-top;                 
                fprintf('Player(%d); top: %d, bottom: %d, right: %d, left: %d\n',id,FinalBlobs(id).top,FinalBlobs(id).bottom,FinalBlobs(id).right,FinalBlobs(id).left);                                    

                res(1+(((id-1)*4)+1))= FinalBlobs(id).top;
                res(1+(((id-1)*4)+2))= FinalBlobs(id).bottom;
                res(1+(((id-1)*4)+3))= FinalBlobs(id).left;
                res(1+(((id-1)*4)+4))= FinalBlobs(id).right;
            end
            
            %% Ball Posprocessing
              
                fprintf('Ball; top: %d, bottom: %d, right: %d, left: %d\n',Ball(1).top,Ball(1).bottom,Ball(1).right,Ball(1).left);                                                    
                BallId = BallOwner();
                
            end

            %% Profiling
            %format shortg
            %c = clock
            
            for compress=1:1
            %TODO: Ball detection            
            res(1)=BallId;  
            res(34)=max_RLevels;
            res(35)=max_GLevels;
            res(36)=max_BLevels;

            fprintf("RES: {%d,",res(1));
            for i=2:33
                fprintf("%d,",res(i));
            end
            fprintf("}\n");
        
            fprintf("Colors: {%d,",res(34));
            for i=35:36
                fprintf("%d,",res(i));
            end
            fprintf("}\n"); 
            end

        end
   end
end

%% Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = in_of_bounds(i,j)    
    global top_field; 
    global bottom_field;  
    global right_field;  
    global left_field; 

    ret = (i > top_field && j > left_field && i < bottom_field && j < right_field);
    
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
        
    %fprintf("Pos [%d,%d]\n",ii,jj);
    if(in_of_bounds(ii+1,jj)==1 && PlayersMask(ii+1,jj) == 0 && Processed(ii+1,jj) == 0) 
        %%%%%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii+1,jj));
        Processed(ii+1,jj) = 1;
        weight = weight +1;        
        bottom = max(ii+1,bottom);
        %%fprintf('bottom = %d\n',bottom);
        Blob(ii+1,jj);
    end  
            
    if(in_of_bounds(ii,jj-1)== 1 && PlayersMask(ii,jj-1) == 0 && Processed(ii,jj-1) == 0)     
        %%%%%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj-1));
        Processed(ii,jj-1) = 1;
        weight = weight +1;        
        left = min(jj-1,left);
        %%fprintf('left = %d\n',left);
        Blob(ii,jj-1);
    end
    
    if(in_of_bounds(ii,jj+1)==1 && PlayersMask(ii,jj+1) == 0 && Processed(ii,jj+1) == 0)
        %%%%%%fprintf('TmpBlob() = %d\n',TmpBlobMap(ii,jj+1));
        Processed(ii,jj+1) = 1;
        weight = weight +1; 
        right = max(jj+1,right);
        %%fprintf('right = %d\n',right);
        Blob(ii,jj+1);
    end    

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function find_top()

    global rows;
    global columns;
    global top_field;      
    global FieldMask; 
    global col_avg;
    
    ii = 1;
    trobat = 0;
    old_counter = 0;
    
    while(trobat == 0 && ii < rows)
        jj = 1;
        counter = 0;
        
        while (trobat == 0 && jj < columns-1)
            %if != 0 -> Is not grass
            %fprintf("Grass is %d\n",FieldMask(ii,jj));
            if (FieldMask(ii,jj) == 0)
                %if is grass we must count and check if we know
                %already that is row grass one
                counter = counter +1;
            end
            jj = jj+1;
            %%%fprintf("(%d,%d)\n",ii,jj);
        end
   
        %Cannot be used avg because 
        if(counter < old_counter)
           % fprintf("ii %d counter %d\n",ii,counter);
            trobat = 1; 
            top_field = ii;
        end
        
        %fprintf("Fila %d counter %d\n",ii,counter);
        old_counter = counter;
        ii=ii+1;
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function find_bottom()

    global rows;
    global columns;
    global bottom_field;      
    global FieldMask;
    global col_avg;
    
    ii = rows;
    trobat = 0;
    old_counter = 0;
    
    while(trobat == 0 && ii > 1)
        jj = 1;
        counter = 0;
        
        while (trobat == 0 && jj < columns-1)
            %if != 0 -> Is not grass
            %fprintf("Grass is %d\n",FieldMask(ii,jj));
            if (FieldMask(ii,jj) == 0)
                %if is grass we must count and check if we know
                %already that is row grass one
                counter = counter +1;
            end
            jj = jj+1;
            %%%fprintf("(%d,%d)\n",ii,jj);
        end
        
        if(counter > col_avg && counter < old_counter)
            trobat = 1; 
            bottom_field = ii;
        end
        
        old_counter = counter;
        ii=ii-1;
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function find_right()

    global columns;
    global right_field;      
    global FieldMask; 
    global row_avg;
    global rows;
    
    jj = columns-1;
    trobat = 0;
    old_counter = 0;
    
    while(trobat == 0 && jj > 1)
        ii = 1;
        counter = 0;
        
        while (trobat == 0 && (ii < rows-1))
            %if != 0 -> Is not grass
            %fprintf("Grass is %d\n",FieldMask(ii,jj));
            if (FieldMask(ii,jj) == 0)
                %if is grass we must count and check if we know
                %already that is row grass one
                counter = counter +1;

            end      
            ii = ii+1;
            %%%fprintf("(%d,%d)\n",ii,jj);
        end
        
        if(counter > row_avg && counter < old_counter)
            trobat = 1;                 
            right_field = jj;
        end
        
        old_counter = counter;
        jj=jj-1;
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function find_left()

    global columns;
    global rows;
    global left_field;      
    global FieldMask; 
    global row_avg;
    
    jj = 1;
    trobat = 0;
    old_counter = 0;
    
    while(trobat == 0 && jj < columns)
        ii = 1;
        counter = 0;
        
        while (trobat == 0 && ii < rows-1)
            %if != 0 -> Is not grass
            %fprintf("Grass [%d,%d] is %d\n",ii,jj,FieldMask(ii,jj));
            if (FieldMask(ii,jj) == 0)
                %if is grass we must count and check if we know
                %already that is row grass one
                counter = counter +1;
            end      
            ii = ii+1;
        end
        
        if(counter > row_avg && counter < old_counter)
            trobat = 1;                        
            left_field = jj;
        end
        
        old_counter = counter;
        jj=jj+1;
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = x_coords_from_camera_to_real(x_camera_coord)

    global x_cm_per_pixel;

    x_real_coord = x_camera_coord*x_cm_per_pixel;
    %%fprintf("x_real_coord: %d\n",x_real_coord);

    %TODO: Precision level (?)
    ret = round(x_real_coord);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = y_coords_from_camera_to_real(y_camera_coord)

    global y_cm_per_pixel;

    y_real_coord = y_camera_coord*y_cm_per_pixel;
    %%fprintf("y_real_coord: %d\n",y_real_coord);

    %TODO: Precision level (?)
    ret = round(y_real_coord);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = x_coords_from_real_to_camera(x_real_coord)

    global x_pixel_per_cm;

    x_real_coord = x_real_coord*x_pixel_per_cm;
    %%fprintf("x_real_coord: %d\n",x_real_coord);

    %TODO: Precision level (?)
    ret = round(x_real_coord);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = y_coords_from_real_to_camera(y_real_coord)

    global y_pixel_per_cm;

    y_real_coord = y_real_coord*y_pixel_per_cm;
    %%fprintf("y_real_coord: %d\n",y_real_coord);

    %TODO: Precision level (?)
    ret = round(y_real_coord);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = isBall()

    global Ball;
    global Ori;
    global PlayersMask;
    global top;
    global bottom;
    global left;
    global right; 

    global R_Ball;
    global G_Ball;
    global B_Ball;
    global Ball_th;
    
    Rc = uint32(0);
    Gc = uint32(0);
    Bc = uint32(0);
    N = uint32(0);
    
    RM = Ori(:,:,1); 
    GM = Ori(:,:,2); 
    BM = Ori(:,:,3);
    
    ret = 0;
    
    for i=top:bottom
        for j=left:right
            
        if (PlayersMask(i,j) == 0)
            Rc = Rc+uint32(RM(i,j));
            Gc = Gc+uint32(GM(i,j));
            Bc = Bc+uint32(BM(i,j));
            N = N+1;
        end
        %fprintf("(%d,%d) -> [%d,%d,%d])\n",i,j,RM(i,j),GM(i,j),BM(i,j)); 
            
        end
    end
    
    Rh = floor(Rc/N);
    Gh = floor(Gc/N);
    Bh = floor(Bc/N); 

    %fprintf("isBall() = [%d,%d,%d]\n == %d %d %d\n",Rh,Gh,Bh,diff_abs(Rc,R_Ball),diff_abs(Gc,G_Ball),diff_abs(Bc,B_Ball));

    if (diff_abs(Rh,R_Ball) < Ball_th &&...
    diff_abs(Gh,G_Ball) < Ball_th &&...
    diff_abs(Bh,B_Ball) < Ball_th)
        ret = 1;
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res=BallOwner()
    global NBlobs;
    global FinalBlobs;
    global Ball;

    ballOwner_id = 0;
    distance = 100;

    for id=1:NBlobs

        %fprintf("ID %d\n");
        c1_up = Ball(1).top-FinalBlobs(id).bottom;
        c1_down = FinalBlobs(id).top-Ball(1).bottom;
        %fprintf("c1 up %d, c down %d\n",c1_up,c1_down);
        if(c1_up > -2)
             c1 = c1_up;
        else
            c1 = c1_down;
        end                    

        c2_left = Ball(1).left-FinalBlobs(id).right;
        c2_right = FinalBlobs(id).left-Ball(1).right;

        if(c2_left > -2)
             c2 = c2_left;
        else
            c2 = c2_right;
        end                    

        %fprintf("c2_left %d, c2_right %d\n",c2_left,c2_right);
        distance_tmp = floor(sqrt((c1*c1)+(c2*c2)));

        if(distance_tmp < distance)
            distance = distance_tmp;
            ballOwner_id = id;
        end

        %fprintf("%d: (%d,%d)= %d\n",id,c1,c2,distance_tmp);

    end
    %fprintf("Ball owner is Player(%d)\n",ballOwner_id);
    res = ballOwner_id;
end
