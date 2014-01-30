function [LabelLine] = MakeLabelFlox( StringText,NumberIterations,NumberLoops)
%UNTITLED2 Summary of this function goes here
%   There is frequently a need to have labels as the first row in a Matlab output file of type xlsx.
% For instance, I often output EEG pwr 1-20 Hz in 1 Hz bins, each represented by 1 column of data in the spreadsheet.
% I need to output a row of labels: 'FileID, EEG2-1, EEG2-2, EEG2-3 etc. to EEG2-20' at the top of the spreadsheet.
%This fxn takes an input string (i.e., 'EEG2-' and a counter variable and concatenates them to produce these labels.
%There are three inputs for this function: the string, the number of iterations of that string, and the number of
%loops through the counter one wants to run.

CellCount=0;

modlist=mod(1:1:12,3);
modlist(find(modlist<1))=3;
d=char (modlist);
intlist=fix((0:1:11)/3);
intlist=intlist+1;

for BigLoop=1:NumberLoops
    for SmallLoop=1:NumberIterations
        CellCount = CellCount+1;
        if intlist (BigLoop) ==1
            if modlist(BigLoop)==1
                LabelLine {CellCount} = [StringText '-1HzStim-30Min-' num2str(SmallLoop) ' HzFFT'];
            elseif modlist(BigLoop)==2
                LabelLine {CellCount} = [StringText '-1HzStim-60Min-' num2str(SmallLoop) ' HzFFT'];
            elseif modlist(BigLoop)==3
                LabelLine {CellCount} = [StringText '-1HzStim-90Min-' num2str(SmallLoop) ' HzFFT'];
            end
        elseif intlist(BigLoop)==2
            if modlist(BigLoop)==1
                LabelLine {CellCount} = [StringText '-10HzStim-30Min-' num2str(SmallLoop) ' HzFFT'];
            elseif modlist(BigLoop)==2
                LabelLine {CellCount} = [StringText '-10HzStim-60Min-' num2str(SmallLoop) ' HzFFT'];
            elseif modlist(BigLoop)==3
                LabelLine {CellCount} = [StringText '-10HzStim-90Min-' num2str(SmallLoop) ' HzFFT'];
            end
        elseif intlist(BigLoop)==3
            if modlist(BigLoop)==1
                LabelLine {CellCount} = [StringText '-20HzStim-30Min-' num2str(SmallLoop) ' HzFFT'];
            elseif modlist(BigLoop)==2
                LabelLine {CellCount} = [StringText '-20HzStim-60Min-' num2str(SmallLoop) ' HzFFT'];
            elseif modlist(BigLoop)==3
                LabelLine {CellCount} = [StringText '-20HzStim-90Min-' num2str(SmallLoop) ' HzFFT'];
            end
        elseif intlist(BigLoop)==4
            if modlist(BigLoop)==1
                LabelLine {CellCount} = [StringText '-40HzStim-30Min-' num2str(SmallLoop) ' HzFFT'];
            elseif modlist(BigLoop)==2
                LabelLine {CellCount} = [StringText '-40HzStim-60Min-' num2str(SmallLoop) ' HzFFT'];
            elseif modlist(BigLoop)==3
                LabelLine {CellCount} = [StringText '-40HzStim-90Min-' num2str(SmallLoop) ' HzFFT'];
            end
        end
    end
end
    
return