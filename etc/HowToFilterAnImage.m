clear
pic=imread('filtering.jpg')
figure
subplot(2,2,1)
image(pic)

filter=ones(3,3)
lp3=convn(pic,filter)
lp3=lp3./9;
subplot(2,2,2)
image(uint8(lp3))

filter=ones(25,25)
lp25=convn(pic,filter)
lp25=lp25./625;
subplot(2,2,3)
image(uint8(lp25))

lp25cor=lp25(13:612,13:812,:);
lp25cor=lp25cor./625;
subplot(2,2,4)

hp=pic-uint8(lp25cor);

picsharp=pic+hp
image(picsharp)
