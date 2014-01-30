clear
pic=imread('filtering.jpg');

for flipper=1:3
    pic90(:,:,flipper)=pic(:,:,flipper)';
end

figure
for i=1:6;
     pic90 = circshift(pic90,[0 0 1]);
     subplot(2,3,i)
    image(pic90)
    axis equal
    axis off
   
end

for flipper=1:3
    pic180(:,:,flipper)=pic90(:,:,flipper)';
end

figure
for i=1:6;
     pic180 = circshift(pic180,[0 0 1]);
     subplot(2,3,i)
    image(pic180)
    axis equal
    axis off
   
end