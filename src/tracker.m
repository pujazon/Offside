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
            global Blobs;
            global Ball;
                        
            global R_Ball;
            global G_Ball;
            global B_Ball;
            global Ball_th;            

            R_Ball=162;
            G_Ball=135;
            B_Ball=165;
            
            Ball_th = 30;
            
            global N;
            N = 8;
            %Camera units in cm
            camera_width = 50;
            camera_height = 50;   
            global x_cm_per_pixel;
            global y_cm_per_pixel; 
            global y_pixel_per_cm;
            global x_pixel_per_cm;  
            
            global RM;
            global GM;
            global BM;

            RM = Ori(:,:,1); 
            GM = Ori(:,:,2); 
            BM = Ori(:,:,3);
            
            Ball_dim_x = 150;
            Ball_dim_y = 150;
            
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
            for i = 1: rows
                for j = 1: columns     
                    if(PlayersMask(i,j) < 255 ) PlayersMask(i,j) = 0; end                        
                end
            end

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


            end

            %% Tracking
            %  Knowing the old positions and having the current photo,
            %  check where each player is now searching "near" and set it
            %  to current position
			
            for compress=1:1

            Blobs = Player.empty(N,0);
            Processed = zeros(rows,columns);
            minWeight = 1;
			
            %Tracking player by player
            for id = 1:8                 

                i_id = id-1;
                
				old_top 		= obj.old(1,(i_id*4)+1);
				old_bottom 		= obj.old(1,(i_id*4)+2);
				old_left 		= obj.old(1,(i_id*4)+3);
				old_right 		= obj.old(1,(i_id*4)+4);
                
				box_x_offset	= 10; 
				box_y_offset	= 10; 
                
				ori_x 			= old_top-box_x_offset;
				ori_y 			= old_left-box_y_offset;
                     
			
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
                            Processed(i,j) = 1;
                            top = i;
                            bottom = i;
                            left = j;
                            right = j;
                            weight = 1; 
                            TrackBlob(i,j,top_bound,bottom_bound,left_bound,right_bound);
                            trobat = 1;
                        end                        
                        j = j+1;
                    end
                    i = i+1;
                    j = ori_y;
                end

                
				if ((top ~= 0) && (bottom ~= 0) && (left ~= 0) && (right ~= 0) && (weight > minWeight))
					Blobs(id).top = top;
					Blobs(id).bottom = bottom;
					Blobs(id).left = left;
					Blobs(id).right = right;
					Blobs(id).weight = weight;   
					Blobs(id).width = right-left;   
					Blobs(id).height = bottom-top;                 
					fprintf('TrackBlob[%d](%d,%d) has %d pixels; top: %d, bottom: %d, right: %d, left: %d\n',id,old_top,old_left,Blobs(id).weight,Blobs(id).top,Blobs(id).bottom,Blobs(id).right,Blobs(id).left);                                             
				end 
                    
            end
            end 
            
            
            %% Ball Detection
            %  First get the Candidates
            %  Compare with precalculated mean histogram.
            
            for compress=1:1
            
            [centers, radii, metric] = imfindcircles(Ori,[9 20]);
            N2 = size(centers);
            ncenter = centers(1:N2,:);
            nradio = radii(1:N2);
            
            %Size filter to avoid noise blobs
            min_ball_x = 20;
            min_ball_y = 20;
            
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
                diff_abs(Bh,B_Ball) < Ball_th &&...
                (bbottom-btop) > min_ball_x && (bright-bleft) > min_ball_y)
                    isBall = 1;
                end
                
                if(isBall == 1)
                 
                 Ball(1).top = btop;
                 Ball(1).bottom = bbottom;
                 Ball(1).left = bleft;
                 Ball(1).right = bright;   
                 final_xcenter = xcenter;
                 final_ycenter = ycenter;

                end
                                               
            end 
			
            Bid = BallOwner(final_xcenter,final_ycenter);
 
            end
            
            
            %% Output;

            for id=1:8
                
                res(1+(((id-1)*4)+1))= Blobs(id).top;
                res(1+(((id-1)*4)+2))= Blobs(id).bottom;
                res(1+(((id-1)*4)+3))= Blobs(id).left;
                res(1+(((id-1)*4)+4))= Blobs(id).right;
                
                fprintf('Player(%d); top: %d, bottom: %d, right: %d, left: %d\n',id,Blobs(id).top,Blobs(id).bottom,Blobs(id).right,Blobs(id).left);                                    
                
            end

            res(1)=Bid;  
            
            res(34)=obj.R_Field;
            res(35)=obj.G_Field;
            res(36)=obj.B_Field;
              
            
            
        end        

    end

end

%% Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%(!) TODO CANNOT BE ON THE MARGINS DUE TO ERROR CAMERA DISTORSION MAKES OUT
%OF BOUND A BLOBL WHICH IS NOT
function ret = in_of_bounds_box(i,j,top_bound,bottom_bound,left_bound,right_bound)
     
    global bottom_field;  
    global right_field;  
    global left_field; 
    
    ret = (i > top_bound && j > left_bound && i < bottom_bound && j < right_bound);
    
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
        
    if(in_of_bounds_box(ii+1,jj,top_bound,bottom_bound,left_bound,right_bound)==1 &&...
        PlayersMask(ii+1,jj) == 0 && Processed(ii+1,jj) == 0 && isBallPixel(ii+1,jj) == 0) 
        Processed(ii+1,jj) = 1;
        weight = weight +1;        
        bottom = max(ii+1,bottom);
        TrackBlob(ii+1,jj,top_bound,bottom_bound,left_bound,right_bound);
    end  
            
    if(in_of_bounds_box(ii,jj-1,top_bound,bottom_bound,left_bound,right_bound)== 1 &&...
            PlayersMask(ii,jj-1) == 0 && Processed(ii,jj-1) == 0 && isBallPixel(ii,jj-1) == 0)     
        Processed(ii,jj-1) = 1;
        weight = weight +1;        
        left = min(jj-1,left);
        TrackBlob(ii,jj-1,top_bound,bottom_bound,left_bound,right_bound);
    end
    
    if(in_of_bounds_box(ii,jj+1,top_bound,bottom_bound,left_bound,right_bound)==1 &&...
            PlayersMask(ii,jj+1) == 0 && Processed(ii,jj+1) == 0 && isBallPixel(ii,jj+1) == 0)
        Processed(ii,jj+1) = 1;
        weight = weight +1; 
        right = max(jj+1,right);
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
    old_counter = 0;
    
    while(trobat == 0 && ii < rows)
        jj = 1;
        counter = 0;
        
        while (trobat == 0 && jj < columns-1)
            %if != 0 -> Is not grass
            if (FieldMask(ii,jj) == 0)
                %if is grass we must count and check if we know
                %already that is row grass one
                counter = counter +1;
            end
            jj = jj+1;
        end
   
        %Cannot be used avg because 
        if(counter > col_avg && counter < old_counter)
            trobat = 1; 
            top_field = ii;
        end
        
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
            if (FieldMask(ii,jj) == 0)
                %if is grass we must count and check if we know
                %already that is row grass one
                counter = counter +1;
            end
            jj = jj+1;
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
            if (FieldMask(ii,jj) == 0)
                counter = counter +1;

            end      
            ii = ii+1;
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

    ret = round(x_real_coord,5);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = y_coords_from_camera_to_real(y_camera_coord)

    global y_cm_per_pixel;

    y_real_coord = y_camera_coord*y_cm_per_pixel;

    ret = round(y_real_coord,5);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = x_coords_from_real_to_camera(x_real_coord)

    global x_pixel_per_cm;

    x_real_coord = x_real_coord*x_pixel_per_cm;

    ret = round(x_real_coord,5);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = y_coords_from_real_to_camera(y_real_coord)

    global y_pixel_per_cm;

    y_real_coord = y_real_coord*y_pixel_per_cm;

    ret = round(y_real_coord,5);

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
            
        end
    end
    
    Rh = floor(Rc/N);
    Gh = floor(Gc/N);
    Bh = floor(Bc/N); 


    if (diff_abs(Rh,R_Ball) < Ball_th &&...
    diff_abs(Gh,G_Ball) < Ball_th &&...
    diff_abs(Bh,B_Ball) < Ball_th)
        ret = 1;
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res=BallOwner(xball,yball)
    global Blobs;

    ballOwner_id = 0;
    distance = 100;

    for id=1:8
        xplayer = Blobs(id).top  + floor((Blobs(id).bottom-Blobs(id).top)/2);
        yplayer = Blobs(id).left + floor((Blobs(id).right-Blobs(id).left)/2);                
        
        t1 = (xplayer-xball);     
        t2 = (yplayer-yball);

        distance_tmp = floor(sqrt((t1*t1)+(t2*t2)));

        if(distance_tmp < distance)
            distance = distance_tmp;
            ballOwner_id = id;
        end


    end
	
    res = ballOwner_id;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res=isBallPixel(i,j)
            
    global R_Ball;
    global G_Ball;
    global B_Ball;
    global Ball_th;
    global RM;
    global GM;
    global BM;

    R = RM(i,j);
    G = GM(i,j);
    B = BM(i,j);
    
    if (diff_abs(R,R_Ball) < Ball_th &&...
    diff_abs(G,G_Ball) < Ball_th &&...
    diff_abs(B,B_Ball) < Ball_th)
        res = 1;
    else
        res = 0;
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ret = in_of_bounds(i,j)    
    global top_field; 
    global bottom_field;  
    global right_field;  
    global left_field; 

    ret = (i > top_field && j > left_field && i < bottom_field && j < right_field);
    
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
        Processed(ii+1,jj) = 1;
        weight = weight +1;        
        bottom = max(ii+1,bottom);
        Blob(ii+1,jj);
    end  
            
    if(in_of_bounds(ii,jj-1)== 1 && PlayersMask(ii,jj-1) == 0 && Processed(ii,jj-1) == 0)     
        Processed(ii,jj-1) = 1;
        weight = weight +1;        
        left = min(jj-1,left);
        Blob(ii,jj-1);
    end
    
    if(in_of_bounds(ii,jj+1)==1 && PlayersMask(ii,jj+1) == 0 && Processed(ii,jj+1) == 0)
        Processed(ii,jj+1) = 1;
        weight = weight +1; 
        right = max(jj+1,right);
        Blob(ii,jj+1);
    end    

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
