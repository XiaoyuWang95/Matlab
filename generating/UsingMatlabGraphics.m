clear
temp = imread('UofC.jpg')
figure
subplot(2,2,1)
image(temp)

for i=1:3
    bigmatrix(:,:,:,i)=zeros(size(temp,1),size(temp,2),3);
    bigmatrix(:,:,i,i)=temp(:,:,i);
    subplot(2,2,i+1)
    upazila= uint8(bigmatrix(:,:,:,i));
    image(upazila)
end
    
bigmatrix2(:,:,:,1)=bigmatrix(:,:,:,1)+bigmatrix(:,:,:,2)+bigmatrix(:,:,:,3)
bigmatrix2(:,:,:,2)=bigmatrix(:,:,:,1)+bigmatrix(:,:,:,2)
bigmatrix2(:,:,:,3)=bigmatrix(:,:,:,1)+bigmatrix(:,:,:,3)
bigmatrix2(:,:,:,4)=bigmatrix(:,:,:,3)+bigmatrix(:,:,:,2)

figure
for i=1:4
    subplot(2,2,i)
    image(uint8(bigmatrix2(:,:,:,i)))
end

figure
subplot (2,2,1)
image(uint8(bigmatrix2(:,:,:,1)))
subplot(2,2,2)
image(uint8(bigmatrix2(:,:,:,1)+50))
subplot(2,2,3)
image(uint8(bigmatrix2(:,:,:,1)-50))
subplot(2,2,4)
bigmatrix2(:,:,1,1)=bigmatrix2(:,:,1,1)+100;
image(uint8(bigmatrix2(:,:,:,1)))
