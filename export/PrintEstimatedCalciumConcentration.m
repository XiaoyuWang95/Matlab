CaBase=100;
kD=700;

figure
hold on

data = imread ('flash4.jpg','jpg');
data2= data';

for i=1:512
  Inverter = 513-i;
  for LineReader = 1:634
    data3(i,LineReader)=data2(Inverter,LineReader);
  end
end

spikecurve = data3(240:290,:);
NoSpikeCurve = data3 (340:390,:);
Normalizer = data3 (:,100:150);
Averagizer = mean(mean(Normalizer));

%imagesc(spikecurve);
%imagesc(NoSpikeCurve);

for LineReader = 1:length(spikecurve)
    Flash(LineReader)=mean(spikecurve(1:51,LineReader));
    NoFlash(LineReader)=mean(NoSpikeCurve(1:51,LineReader));
end

for LineReader = 1:length(spikecurve)
    RFlash(LineReader)=Flash(LineReader)/Averagizer;
    RNoFlash(LineReader)=NoFlash(LineReader)/Averagizer;
end

for CaReader   = 1:length(spikecurve)
    CaFlash(CaReader)=(RFlash(CaReader)*kD)/((kD/CaBase) - (RFlash(CaReader) + 1));
    CaNoFlash(CaReader)=(RNoFlash(CaReader)*kD)/((kD/CaBase) - (RNoFlash(CaReader) + 1));
end

plot (CaFlash,'r');
plot (CaNoFlash,'k');

