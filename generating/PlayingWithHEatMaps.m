%we are going to generate three heat maps here.
clear all
bigmatrix=zeros(40,30,3,3);
bigmatrix(:,:,:,:)=0;



%populate 4-dimensional matrix (bigmatrix) with zeroes.
%When reformated as uint8 and plotted as an image, the matrix will encode a
%4 row by 3 column image with adjustable-intensity RGB color.
%Dimension 1 = encodes the row in which a pixel resides 
%Dimension 2 = encodes the column in which a pixel resides
%Dimension 3 = the color dimension... 1=red, 2 = green, 3 blue  
%Dimension 4 = creates four separate images as part of one image file.  
%Any given image can only be processed as a 3-dimensional array.  So
%when one adds a dimension beyond the third, it is adding another
%image.
%An element in this array can vary from 0 (black) to 255 (maximal
%intensity of this color). By way of example, this command: 
%colormatrix (2,3,1)=255 will give the point 2 pixels from the top
%and 3 pixels from the left maximal intensity red light
    
for rowcount=1:40
    for colcount=1:30
        bigmatrix(41-rowcount,colcount,1,1)=255/rowcount*colcount;
        bigmatrix(41-rowcount,colcount,2,1)=255-255/rowcount*colcount/5;
        bigmatrix(41-rowcount,colcount,3,1)=255-255/rowcount*colcount;
    end
end
for rowcount=1:40
    for colcount=1:30
        bigmatrix(41-rowcount,colcount,2,2)=255/rowcount*colcount;
        bigmatrix(41-rowcount,colcount,3,2)=255-255/rowcount*colcount;
        bigmatrix(41-rowcount,colcount,1,2)=255-255/rowcount*colcount;   
    end
end
for rowcount=1:40
    for colcount=1:30
        bigmatrix(41-rowcount,colcount,3,3)=255/rowcount*colcount;
        bigmatrix(41-rowcount,colcount,1,3)=255-255/rowcount*colcount;
        bigmatrix(41-rowcount,colcount,2,3)=255-255/rowcount*colcount;
    end
end
subplot(2,2,2)
upazila= uint8(bigmatrix(:,:,:,1));
image(upazila)

subplot(2,2,3)
upazila= uint8(bigmatrix(:,:,:,2));
image(upazila)

subplot(2,2,4)
upazila= uint8(bigmatrix(:,:,:,3));
image(upazila)

