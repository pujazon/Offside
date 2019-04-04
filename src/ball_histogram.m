  
            %addpath '/home/pujazon/Escriptori/Offside/PlayerDetection/top/testcases'
            %addpath '/home/pujazon/Escriptori/Offside/MainNode/bin/testcases'
            addpath 'C:\Users\danie\Desktop\TFG\Offside\PlayerDetection\top\testcases'
            
            %Profiling
            format shortg
            c = clock

            for compress=1:1

            maxNumCompThreads(16);
            %%%%%fprintf('Hilos: %d\n',maxNumCompThreads);

            I = imread('ball_2.png');
            Ori = imread('ball_2.png');

            figure, imshow(Ori);

            end

            %GLOBALS
            global Processed;
            global TmpBlobMap;
            global PlayersMask;
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
            
            global row_avg;
            global col_avg;

            %Camera units in cm
            camera_width = 50;
            camera_height = 50;

            global x_cm_per_pixel;
            global y_cm_per_pixel;

            N = 30;
            
                        %% Preprocessing
            %  FieldMask:
            %  Apply thresholding with Grass mean color and offset
            %  FieldBoundaries:
            %  Image is bigger than field and we only want to process the blobs inside field 
            %  so must be found field boundaries

            max_RLevels = 21;
            max_GLevels = 80;
            max_BLevels = 96;
            
            for compress=1:1

            rows = size(I,1);
            columns = size(I,2);
                        
            row_avg = floor(rows*0.5)
            col_avg = floor(columns*0.5)

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
             %figure, imshow(PlayersMask);
             figure, imshow(FieldMask);
            end


    
    Rc = uint32(0);
    Gc = uint32(0);
    Bc = uint32(0);
    N = uint32(0);
    
    RM = Ori(:,:,1); 
    GM = Ori(:,:,2); 
    BM = Ori(:,:,3);
    
    for i=1:rows
        for j=1:columns
            
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
    
    
    fprintf("isBall() = [%d,%d,%d]\n",Rh,Gh,Bh);
    
             
function ret = diff_abs(a,b)    
    if (a > b) ret = a-b;
    else ret = b-a;
    end
end