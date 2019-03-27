#include "camera.h"

raspicam::RaspiCam Camera;

int setup_camera(){

    // Allowable values: RASPICAM_FORMAT_GRAY,RASPICAM_FORMAT_RGB,RASPICAM_FORMAT_BGR,RASPICAM_FORMAT_YUV420
    Camera.setFormat(raspicam::RASPICAM_FORMAT_RGB);

    // Allowable widths: 320, 640, 1280
    // Allowable heights: 240, 480, 960
    // setCaptureSize(width,height)
    Camera.setCaptureSize(WIDTH,HEIGHT);
	
    //Open camera 
    cout<<"Opening Camera..."<<endl;
    if ( !Camera.open()) {cerr<<"Error opening camera"<<endl;return -1;}
    //wait a while until camera stabilizes
    cout<<"Stabilizing camera in 3 secs..."<<endl;
    sleep(3);

	return 0;	

}

int photo(){

	auto start = std::chrono::system_clock::now();				
Camera.grab();
    //allocate memory
    unsigned char *data=new unsigned char[  Camera.getImageTypeSize ( raspicam::RASPICAM_FORMAT_RGB )];
    //extract the image in rgb format
    Camera.retrieve ( data,raspicam::RASPICAM_FORMAT_RGB );//get camera image

    std::ofstream outFile ( "top.ppm",std::ios::binary );
    outFile<<"P6\n"<<Camera.getWidth() <<" "<<Camera.getHeight() <<" 255\n";
    outFile.write ( ( char* ) data, Camera.getImageTypeSize ( raspicam::RASPICAM_FORMAT_RGB ) );
    cout<<"Image saved at raspicam_image.ppm"<<endl;
sleep(1);
	
	auto end = std::chrono::system_clock::now();				
	std::chrono::duration<double> elapsed_seconds = end-start;
	std::time_t end_time = std::chrono::system_clock::to_time_t(end);
	std::cout << "photo(): " << elapsed_seconds.count() << "s\n";	 

    return 0;
}
