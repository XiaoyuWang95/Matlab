function [TargetOut] = TrainingSchedule(StartingTime,TargetTime,TargetDate)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

TargetDateNum= datenum(TargetDate);
TodayNum= datenum(date);
Today= datestr(datenum(date));
Iterations=floor((TargetDateNum-TodayNum)/7);

for Count=1:Iterations+1
    DateLineNum(Count)=(TargetDateNum-((Iterations-Count+1)*7))
    DateLine{Count}=char(datestr(TargetDateNum-((Iterations-Count+1)*7)));
    TargetOut(1,Count)    = DateLine(Count);
    TargetMe(Count)=floor(StartingTime-(((StartingTime-TargetTime)/Iterations)*(Count-1)))
    TargetOut{2,Count} = TargetMe(Count); 
end

xlswrite ('TargetTimeSchedule.xlsx', TargetOut);

end

