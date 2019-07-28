#include <chrono>
#include <thread>
#include <mex.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){    
    if (nlhs != 1) mexErrMsgTxt("1 output needed.");
    
    if (nrhs != 1)
        mexErrMsgTxt("The input has to be a desired sleep duration [s].");
    
    
    // sleep here
    if ((double)*mxGetPr(prhs[0]) > 0) {
        std::this_thread::sleep_for(
                std::chrono::microseconds(
                (unsigned)(*mxGetPr(prhs[0]) * 1000000)));
    }
    
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    
    unsigned long long usSinceEpoch =
            std::chrono::duration_cast<std::chrono::microseconds>
            (std::chrono::system_clock::now().time_since_epoch()).count();
    
    *mxGetPr(plhs[0]) = usSinceEpoch / 1000000.0;
    return;
}