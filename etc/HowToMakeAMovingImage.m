clear
pic=imread('filtering.jpg')

%figure
%pic3=circshift(pic,[-100 -110 0]);
%image(pic3)

%figure
pic4=pic;

for i=1:size(pic4,1)/10+1
  image(pic4)
  pic4=circshift(pic4,[-40 40 0]);
  M(i)=getframe;
end
for i=1:size(pic4,1)/10+1
  image(pic4)
  pic4=circshift(pic4,[40 40 0]);
  M(i)=getframe;
end
for i=1:size(pic4,1)/10+1
  image(pic4)
  pic4=circshift(pic4,[40 -40 0]);
  M(i)=getframe;
end
for i=1:size(pic4,1)/10+1
  image(pic4)
  pic4=circshift(pic4,[-40 -40 0]);
  M(i)=getframe;
end

movie(M,1,128)