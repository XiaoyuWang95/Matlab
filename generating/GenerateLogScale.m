function [LogScaler] = GenerateLogScale(LogBase,ArrayLength)

%This function will output to the array variable that calls its name
%("GenerateLogScale"), the content of the array LogScaler,
%with user-specified length ArrayLength.  For instance, the command:
%
%>LogMeTwo=GenerateLogScale(2,10)
%
%will produce a log-based 2 scale from log[2]0 through log[2]10:
%LogMeTwo =  1     2     4     8    16    32    64   128   256   512

LogScaler(1)=1;
for LogStep=1:ArrayLength-1
   LogScaler(LogStep+1) =LogBase^LogStep;
end