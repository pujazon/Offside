#include "interlanguage.h"
#include <iostream>



void callgetVars() {     
	using namespace matlab::engine;
	int i;

	// Start MATLAB engine synchronously
	std::unique_ptr<MATLABEngine> matlabPtr = startMATLAB();
	// Create MATLAB data array factory
	//matlab::data::ArrayFactory factory;
	for(i=0;i<100;i++){
		// Pass vector containing 2 scalar args in vector 
		double result = matlabPtr->feval<double>(u"test");   	

		//double result = matlabPtr->feval<double>(u"sqrt", double(2));   
		//std::vector<matlab::data::Array> args({
		//factory.createScalar<int16_t>(30),
		//factory.createScalar<int16_t>(56) });
		// Call MATLAB function and return result
		//matlab::data::TypedArray<int16_t> result = matlabPtr->feval(u"gcd", args);
		std::cout << "Result: " << result << std::endl;
	}
	
	sleep(10);

}
