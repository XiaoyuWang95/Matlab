function [LabelLine] = LabelEpochs(NumberHzBinsPerChannel,NumberEpochs)
%UNTITLED2 Summary of this function goes here
%   There is frequently a need to have labels as the first row in a Matlab output file of type xlsx.
% For instance, I often output EEG pwr 1-20 Hz in 1 Hz bins, each represented by 1 column of data in the spreadsheet.
% I need to output a row of labels: 'FileID, EEG2-1, EEG2-2, EEG2-3 etc. to EEG2-20' at the top of the spreadsheet.
%This fxn takes an input string (i.e., 'EEG2-' and a counter variable and concatenates them to produce these labels.
%There are three inputs for this function: the string, the number of iterations of that string, and the number of
%loops through the counter one wants to run.

CellCount=0;

EpochNumber=(-1:1:NumberEpochs-2);
EEGChannel(1:NumberHzBinsPerChannel)=1;
EEGChannel(NumberHzBinsPerChannel+1:NumberHzBinsPerChannel*2)=2;
HzBin=rem(1:1:NumberHzBinsPerChannel*2,20);
HzBin(HzBin<1)=NumberHzBinsPerChannel;

for BigLoop=1:NumberEpochs
    for SmallLoop=1:NumberHzBinsPerChannel*2
        CellCount = CellCount+1;
                LabelLine {CellCount} = ['Epoch' num2str(EpochNumber(BigLoop)) ' EEG' num2str(EEGChannel(SmallLoop)) ' ' num2str(HzBin(SmallLoop)) 'HzFFT'];
    end
end
    
return