#include "MatlabDataArray.hpp"
#include "MatlabEngine.hpp"
#include <iostream>

using namespace matlab::engine; 

void callgetVars() {     
	     													 // Start MATLAB engine synchronously     
	
	std::unique_ptr<MATLABEngine> matlabPtr = startMATLAB();     							// Evaluate MATLAB statement     
	matlabPtr->eval(convertUTF8StringToUTF16String("[az,el,r] = cart2sph(5,7,3);"));       // Get the result from MATLAB     
	matlab::data::TypedArray<double> result1 = matlabPtr->getVariable(convertUTF8StringToUTF16String("az"));
	matlab::data::TypedArray<double> result2 = matlabPtr->getVariable(convertUTF8StringToUTF16String("el"));     
	matlab::data::TypedArray<double> result3 = matlabPtr->getVariable(convertUTF8StringToUTF16String("r"));      // Display results     
	std::cout << "az: " << result1[0] << std::endl;     std::cout << "el: " << result2[0] << std::endl;     std::cout << "r: " << result3[0] << std::endl; 
}
