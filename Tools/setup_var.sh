#TODO:A check should be done. If that path already exist on global var they musn't be set again
#Workarround: On our machine that var is always empty in each restart so we can first empty and then set

export LD_LIBRARY_PATH=' ';

echo $LD_LIBRARY_PATH;

export LD_LIBRARY_PATH='/usr/local/MATLAB/R2018b/extern/bin:/usr/local/MATLAB/R2018b/extern/bin/glnxa64:/usr/lib/x86_64-linux-gnu;'

echo $LD_LIBRARY_PATH;
