%test of precision

freq5000(1,1)=0;
freq5000(1,2)=0;


for i=2:5002
    freq5000(i,1)=i/5000;
    freq5000(i,2)=freq5000(i,1)-freq5000(i-1,1);
end

freq256(1,1)=0;
freq256(1,2)=0;

for i=2:(floor(5000/256))
    freq256(i,1)=freq5000(floor(5000/256),1);
    freq256(i,2)=freq256(i,1)-freq256(i-1,1);
end

avg=mean(freq256(:,2))