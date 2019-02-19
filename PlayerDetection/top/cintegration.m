%copyfile(fullfile('C:\Program Files\MATLAB\R2017b','extern','examples','refbook','timestwo.c'),'.','f')
%mex timestwo.c

%mex -compatibleArrayDims timestwo.c
