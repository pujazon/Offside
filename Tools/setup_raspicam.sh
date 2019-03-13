echo Raspicam library setup

git clone https://github.com/pujazon/libs.git
cd  libs/raspicam
mkdir build
cd build
cmake ..
make 
sudo make install
