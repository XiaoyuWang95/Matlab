clear
snopic=imread('blizzard006.jpg');
morphfrom=imread('filtering.jpg');

for plane=1:3
for columna=1:800
for rose=1:600
  morphto(rose,columna,plane)=snopic(3*rose,3*columna,plane);
end
end
end

figure
subplot(1,2,1)
image(snopic)
subplot(1,2,2)
image(morphto);
