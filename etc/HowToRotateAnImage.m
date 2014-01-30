clear
pic=imread('blizzard006.jpg');
pic2=imread('filtering.jpg');

for plane=1:3
for columna=1:800
for rose=1:600
  pic1(rose,columna,plane)=pic(3*rose,3*columna,plane);
end
end
end

for flipper=1:3
    pic90(:,:,flipper)=pic1(:,:,flipper)';
end

figure
for i=1:6;
     pic90 = circshift(pic90,[0 0 1]);
     subplot(2,3,i)
    image(pic1)
    axis equal
    axis off
   
end

figure
image(pic2);
