%% Tracker algorithm
%  Having old positions and the current image it returns the current
%  positions

classdef tracker < handle

    properties
        old(1,32)
        R_Field;
        G_Field; 
        B_Field;
        Ball;

    end

    methods
        %(!) The first value on the call will be unsued.
        function obj = tracker(obj,bb,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,...
                a1,b1,c1,d1,e1,f1,g1,h1,i1,j1,k1,l1,m1,n1,o1,p1,rc,gc,bc)
         obj.old(1,1)   = a;
         obj.old(1,2)   = b;
         obj.old(1,3)   = c;
         obj.old(1,4)   = d;
         obj.old(1,5)   = e;
         obj.old(1,6)   = f;
         obj.old(1,7)   = g;
         obj.old(1,8)   = h;
         obj.old(1,9)   = i;
         obj.old(1,10)  = j;
         obj.old(1,11)  = k;
         obj.old(1,12)  = l;
         obj.old(1,13)  = m;
         obj.old(1,14)  = n;
         obj.old(1,15)  = o;         
         obj.old(1,16)  = p;    
         obj.old(1,17)   = a1;
         obj.old(1,18)   = b1;
         obj.old(1,19)   = c1;
         obj.old(1,20)   = d1;
         obj.old(1,21)   = e1;
         obj.old(1,22)   = f1;
         obj.old(1,23)   = g1;
         obj.old(1,24)   = h1;
         obj.old(1,25)   = i1;
         obj.old(1,26) 	 = j1;
         obj.old(1,27) 	 = k1;
         obj.old(1,28) 	 = l1;
         obj.old(1,29) 	 = m1;
         obj.old(1,30) 	 = n1;
         obj.old(1,31) 	 = o1;         
         obj.old(1,32) 	 = p1; 
         
         obj.R_Field = rc;
         obj.G_Field = gc;
         obj.B_Field = bc;
         
         obj.Ball = bb;
         
        end   
        
        function echo(obj)
                     
         fprintf("v[n]={");
         for i=1:32
             fprintf("%d,",obj.old(i));
         end
         fprintf("}\n");
         
         fprintf("Field = [%d,%d,%d]\n",obj.R_Field,obj.G_Field,obj.B_Field);
         
        end     
        function res =tracking(obj)
            %% Prolog
            for compress=1:1
            fprintf("Tracking...\n"); 
            %addpath '/home/pujazon/Escriptori/Offside/tests/PlayerDetection/'
            %addpath '/home/pujazon/Escriptori/Offside/MainNode/bin/testcases'
			addpath 'C:\Users\danie\Desktop\TFG\Offside\test\PlayerDetection\'     
            maxNumCompThreads(16);

            I = imread('top.ppm');
            Ori = imread('top.ppm');
            
            %GLOBALS            
            global rows;
            global columns;          
            global row_avg;
            global col_avg;   
            global top_field; 
            global bottom_field;  
            global right_field;  
            global left_field; 
            global FieldMask;
            global PlayersMask;
            global Processed;
            global top;
            global bottom;
            global right;
            global left;
            global weight;
            
            global N;
            N = 8;
            %Camera units in cm
            camera_width = 50;
            camera_height = 50;   
            global x_cm_per_pixel;
            global y_cm_per_pixel; 
            global y_pixel_per_cm;
            global x_pixel_per_cm;  
            
            figure, imshow(Ori);
            end
            
            %% Preprocessing
            
            max_RLevels = obj.R_Field;
            max_GLevels = obj.G_Field;
            max_BLevels = obj.B_Field;         
            
            fprintf("RGB Grass %d,%d,%d\n",max_RLevels,max_GLevels,max_BLevels);
            
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
                   if(RChannel(i,j) > 190 &&...
                        GChannel(i,j) > 190 &&...
                        BChannel(i,j) > 190)                                                        
                        FieldMask(i,j) = 0;
                    else

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
                   end
                end
            end

             PlayersMask = imgaussfilt(tmp_PlayersMask);
             %figure, imshow(PlayersMask);
             figure, imshow(PlayersMask);

             %Field Boundaries
              find_top();
              fprintf('find_top: %d\n',top_field);
              find_bottom();
              fprintf('bottom_field: %d\n',bottom_field);
              find_right();
              fprintf('right_field: %d\n',right_field);
              find_left();
              fprintf('left_field: %d\n',left_field);               
              

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

            end

            %% Tracking
            %  Knowing the old positions and having the current photo,
            %  check where each player is now searching "near" and set it
            %  to current position
            for compress=1:1

            Blobs = Player.empty(N,0);
            Processed = zeros(rows,columns);
            minWeight = 1;
			vel = 50;
			
            %Tracking player by player
            for id = 1:8                 

                i_id = id-1;
                
				old_top 		= obj.old(1,(i_id*4)+1);
				old_bottom 		= obj.old(1,(i_id*4)+2);
				old_left 		= obj.old(1,(i_id*4)+3);
				old_right 		= obj.old(1,(i_id*4)+4);

                old_top 		= y_coords_from_real_to_camera(old_top)+top_field;
                old_bottom 		= y_coords_from_real_to_camera(old_bottom)+top_field;
                old_left 		= x_coords_from_real_to_camera(old_left)+left_field;
                old_right 		= x_coords_from_real_to_camera(old_right)+left_field;

                %fprintf("old_top = %d\n",old_top);
                %fprintf("old_bottom = %d\n",old_bottom);
                %fprintf("old_left = %d\n",old_left);
                %fprintf("old_right = %d\n",old_right);
                
				box_x_offset	= floor((old_bottom-old_top)/2);
				box_y_offset	= floor((old_right-old_left)/2);
				
				ori_x 			= old_top-box_x_offset;
				ori_y 			= old_left-box_y_offset;
                

                %fprintf("ori_x = %d\n",ori_x);
                %fprintf("ori_y = %d\n",ori_y);             
			
                Processed(i,j) 	= 1;
				top 			= ori_x;
				bottom 			= ori_x;
				left 			= ori_y;
				right 			= ori_y;
				weight 			= 1;                              
				
				top_bound		= old_top-box_x_offset;
				bottom_bound	= old_bottom+box_x_offset;
				left_bound		= old_left-box_y_offset;
				right_bound		= old_right+box_y_offset; 
                
                i = ori_x;
                j = ori_y;
                trobat = 0;
                
                while(i < bottom_bound && trobat == 0)
                    while(j < right_bound && trobat == 0)
                        if (PlayersMask(i,j) == 0 && Processed(i,j) == 0)
                            top = i;
                            left = j;
                            TrackBlob(i,j,top_bound,bottom_bound,left_bound,right_bound);
                            trobat = 1;
                        end                        
                        j = j+1;
                    end
                    i = i+1;
                    j = ori_y;
                end

                %fprintf("top = %d\n",top);
                %fprintf("bottom = %d\n",bottom);
                %fprintf("left = %d\n",left);
                %fprintf("right = %d\n",right);  
                %fprintf("top_bound = %d\n",top_bound);
                %fprintf("bottom_bound = %d\n",bottom_bound);
                %fprintf("left_bound = %d\n",left_bound);
                %fprintf("right_bound = %d\n",right_bound);  
                
				if ((top ~= 0) && (bottom ~= 0) && (left ~= 0) && (right ~= 0) && (weight > minWeight))
					Blobs(id).top = top-top_field;
					Blobs(id).bottom = bottom-top_field;
					Blobs(id).left = left-left_field;
					Blobs(id).right = right-left_field;
					Blobs(id).weight = weight;   
					Blobs(id).width = right-left;   
					Blobs(id).height = bottom-top;                 
					%fprintf('TrackBlob(%d,%d) has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',old_top,old_left,Blobs(id).weight,Blobs(id).top,Blobs(id).bottom,Blobs(id).right,Blobs(id).left);                                    
                    
                    
                %Debug
                    %%%%%%fprintf("I(%d)=[%d,%d,%d,%d]; r=%d,c=%d\n",w,FinalBlobs(w).top,FinalBlobs(w).left,FinalBlobs(w).bottom,FinalBlobs(w).right,(FinalBlobs(w).bottom-FinalBlobs(w).top),(FinalBlobs(w).right-FinalBlobs(w).left));        
                    for iii= Blobs(id).top:Blobs(id).bottom 
                        for jjj = Blobs(id).left:Blobs(id).right
                            Ori(iii,jjj,1) = 234;
                            Ori(iii,jjj,2) = 34;
                            Ori(iii,jjj,3) = 234;
                        end                        
                end

                    
				end 

            end
            end 
            
            %% Output            
            imshow(Ori);

            for id=1:8

                top = y_coords_from_camera_to_real(Blobs(id).top);
                bottom = y_coords_from_camera_to_real(Blobs(id).bottom);
                left = x_coords_from_camera_to_real(Blobs(id).left);
                right = x_coords_from_camera_to_real(Blobs(id).right);
                
                res(1+(((id-1)*4)+1))= top;
                res(1+(((id-1)*4)+2))= bottom;
                res(1+(((id-1)*4)+3))=left;
                res(1+(((id-1)*4)+4))= right;
                
                fprintf('Player(%d); top: %d, bottom: %d, right: %d, left: %d\n',id,top,bottom,right,left);                                    
                
            end
            %TODO: Ball Detection
            res(1)=obj.Ball;  
            
            res(34)=obj.R_Field;
            res(35)=obj.G_Field;
            res(36)=obj.B_Field;

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
%% Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = in_of_bounds_box(i,j,top_bound,bottom_bound,left_bound,right_bound)
    global top_field; 
    global bottom_field;  
    global right_field;  
    global left_field; 
    
    ret = (i > top_bound && j > left_bound && i < bottom_bound && j < right_bound)&&...
        (top_bound > top_field && left_bound > left_field && bottom_bound < bottom_field &&...
        right_bound < right_field);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = diff_abs(a,b)    
    if (a > b) ret = a-b;
    else ret = b-a;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TrackBlob(ii,jj,top_bound,bottom_bound,left_bound,right_bound)

    global PlayersMask;
    global Processed;
    global bottom;
    global right;
    global left;
    global weight;
        
    %fprintf("Pos [%d,%d]\n",ii,jj);
    if(in_of_bounds_box(ii+1,jj,top_bound,bottom_bound,left_bound,right_bound)==1 &&...
        PlayersMask(ii+1,jj) == 0 && Processed(ii+1,jj) == 0) 
        %%%%%%fprintf('TmpTrackBlob() = %d\n',TmpBlobMap(ii+1,jj));
        Processed(ii+1,jj) = 1;
        weight = weight +1;        
        bottom = max(ii+1,bottom);
        %%fprintf('bottom = %d\n',bottom);
        TrackBlob(ii+1,jj,top_bound,bottom_bound,left_bound,right_bound);
    end  
            
    if(in_of_bounds_box(ii,jj-1,top_bound,bottom_bound,left_bound,right_bound)== 1 &&...
            PlayersMask(ii,jj-1) == 0 && Processed(ii,jj-1) == 0)     
        %%%%%%fprintf('TmpTrackBlob() = %d\n',TmpBlobMap(ii,jj-1));
        Processed(ii,jj-1) = 1;
        weight = weight +1;        
        left = min(jj-1,left);
        %%fprintf('left = %d\n',left);
        TrackBlob(ii,jj-1,top_bound,bottom_bound,left_bound,right_bound);
    end
    
    if(in_of_bounds_box(ii,jj+1,top_bound,bottom_bound,left_bound,right_bound)==1 &&...
            PlayersMask(ii,jj+1) == 0 && Processed(ii,jj+1) == 0)
        %%%%%%fprintf('TmpTrackBlob() = %d\n',TmpBlobMap(ii,jj+1));
        Processed(ii,jj+1) = 1;
        weight = weight +1; 
        right = max(jj+1,right);
        %%fprintf('right = %d\n',right);
        TrackBlob(ii,jj+1,top_bound,bottom_bound,left_bound,right_bound);
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
                if(counter > col_avg)
                    trobat = 1; 
                end
            end
            jj = jj+1;
            %%%fprintf("(%d,%d)\n",ii,jj);
        end
        
        if (trobat == 1)
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
    global col_avg;
    
    ii = rows;
    trobat = 0;
    
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
                if(counter > col_avg)
                    trobat = 1; 
                end
            end
            jj = jj+1;
            %%%fprintf("(%d,%d)\n",ii,jj);
        end
        
        if (trobat == 1)
            bottom_field = ii;
        end
        
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
                if(counter > row_avg)
                    trobat = 1; 
                end
            end      
            ii = ii+1;
            %%%fprintf("(%d,%d)\n",ii,jj);
        end
        
        if (trobat == 1)
            right_field = jj;
        end
        
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
                if(counter > row_avg)
                    trobat = 1; 
                end
            end      
            ii = ii+1;
        end
        
        if (trobat == 1)            
            left_field = jj;
        end
        
        jj=jj+1;
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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