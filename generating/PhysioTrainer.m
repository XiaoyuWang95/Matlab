function [ DateLine,TargetMe ] = PhysioTrainer( TargetDate, StartingTime,TargetTime)
%This function takes a target date a target performance time and a current
%performance time, and produces a spreadsheet that will plot the interim
%target performance times at a weekly frequency.
%   Target Date must be in this format: MM-DD-YYYY.

TargetDateNum= datenum(TargetDate);
Today=(date);
TodayNum= datenum(Today);
Iterations=floor(TargetDateNum/TodayNum);

for Count=1:Iterations
    DateLineNum(Count)=(TargetDateNum-Count*7);
    DateLine(Count)=char(datestr(DateLineNum(Count)));
    TargetMe(Count)=StartingTime-(((StartingTime-TargetTime)/Iterations)*Count);
end


end
