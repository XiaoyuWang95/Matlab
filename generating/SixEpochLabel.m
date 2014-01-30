function [LabelLine] = DurationLabel( StringText,NumberIterations,SourceArray)
%UNTITLED2 Summary of this function goes here
%   There is frequently a need to have labels as the first row in a Matlab output file of type xlsx.
% For instance, I often output EEG pwr 1-20 Hz in 1 Hz bins, each represented by 1 column of data in the spreadsheet.
% I need to output a row of labels: 'FileID, EEG2-1, EEG2-2, EEG2-3 etc. to EEG2-20' at the top of the spreadsheet.
%This fxn takes an input string (i.e., 'EEG2-' and a counter variable and concatenates them to produce these labels.  
%There are three inputs for this function: the string, the number of iterations of that string, and the number of
%loops through the counter one wants to run.

clear LabelLine % we will use this variable later.  We clear it here to make sure that it can be created as an array of chars later.

for CellCount=1:NumberIterations  %NumberIterations is provided when this function is called within a script.  The user must know how many data columns there are.
  CountChar=char(SourceArray(CellCount));  %The source array is a cell array of chars. 
               %It has to be an array of chars, since the content of a given cell within this array will be used as output text for this function.
               %We must convert the content of this cell of the array into a character variable, so that it can be processed into a 
               %single cell in a cell array. If we were to call the
               %SourceArray directly in the next executable line, the
               %resulting array would be a cell array of cell arrays, which
               %cannot be converted directly into a char.
  LabelLine {CellCount}= char ([StringText '-Epoch ' CountChar]);  
               %Every item within the brackets is a char.  The brackets insert them together into a cell array of chars. 
               %'char' allows the entire content of the cell array to be concatenated into a single character variable.    
               %The character variable is added as a single cell in an array of chars, LabelLine, which is the final output of the function.
end


end



