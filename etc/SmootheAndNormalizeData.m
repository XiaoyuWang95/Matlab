function[SmoothedPercent,SmoothedData,NormalizedData]=SmootheLactate(InputMatrix);

SmoothedData(:,1)=InputMatrix(:,1);
SmoothedData(1:10,2)=InputMatrix(1:10,1);
SmoothedCount=0;

for counter=11:length(InputMatrix)
    if InputMatrix(counter,1)-mean(InputMatrix(counter-10:counter-1,1))>10*std(InputMatrix(counter-10:counter-1,1))
        SmoothedData(counter,2)=mean(InputMatrix(counter-10:counter-1,1));
        SmoothedCount=SmoothedCount+1;
    elseif mean(InputMatrix(counter-10:counter-1,1))-InputMatrix(counter,1)>10*std(InputMatrix(counter-10:counter-1,1))
        SmoothedData(counter,2)=mean(InputMatrix(counter-10:counter-1,1));
        SmoothedCount=SmoothedCount+1;
    else
        SmoothedData(counter,2)=InputMatrix(counter,1);
    end
end
SmoothedPercent=SmoothedCount/length(SmoothedData)*100;
%plot(SmoothedData(:,1),'r')
%hold on
%plot(SmoothedData(:,2),'k')

NormalizedData=SmoothedData(:,2)/mean(SmoothedData(:,2));

return
