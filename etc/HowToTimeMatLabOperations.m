format long;
Interval = 1;
TimeCard=[];
while Interval < 100000
    tic;
    Interval=Interval+1;
    TimeCard (Interval,1)=toc;
end

MeanInterval = mean(TimeCard)
MinInterval = min(TimeCard)
MaxInterval = max(TimeCard)

figure ;
plot (TimeCard);
