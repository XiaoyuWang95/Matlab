clear all
temp = imread('Blizzard006.jpg');  %read my photoimage 'Blizzard006' into the 3-D matrix known as temp. It is recognized as being a matrix of 8-bit unsigned integers
temp(201:220,:,:)=0;
figure           %prepare to make a figure
subplot(2,2,1) %the figure will consist of a 2 X 2 array of panels.  Plot the following image into the top left of the four panels (i.e., panel # 1).
image(temp) %the image to be plotted is temp.

for i=1:3
    bigmatrix(:,:,:,i)=zeros(size(temp,1),size(temp,2),3); %populate 4-dimensional matrix (bigmatrix), one 3-D submatrix at a time:
    % first (:,:,:,1), then (:,:,:,2), then (:,:,:,3).  Each of these three submatrices will hold an image. 
    %Dimension 1 = same as dimension 1 of temp.  This encodes the row in which a pixel resides 
    %Dimension 2 = same as dimension 2 of temp.  This encodes the column in which a pixel resides
    %Dimension 3 = the color dimension... 1=red, 2 = green, 3 blue.  
    %An element in this array can vary from 0 (no brightness) to 255
    %(maximal brightness, equivalent to 
    %Dimension 4 = creates four separate images as part of one image file.  
    %Any given image can only be processed as a 3-dimensional array.  So
    %when one adds a dimension beyond the third, it is adding another
    %image.
    bigmatrix(:,:,i,i)=temp(:,:,i);
    %if i==1
       bigmatrix(:,:,1,1)=255;
       bigmatrix(:,:,2,1)=0;
       bigmatrix(:,:,3,1)=0;
   % end    
    subplot(2,2,i+1)
    upazila= uint8(bigmatrix(:,:,:,i));
    image(upazila)
  
end
    
%bigmatrix2(:,:,:,1)=bigmatrix(:,:,:,1)+1; %bigmatrix(:,:,:,3)+bigmatrix(:,:,:,3);
%bigmatrix2(:,:,:,2)=bigmatrix(:,:,:,1)+bigmatrix(:,:,:,2);
%bigmatrix2(:,:,:,3)=bigmatrix(:,:,:,1)+bigmatrix(:,:,:,3);
%bigmatrix2(:,:,:,4)=bigmatrix(:,:,:,3)+bigmatrix(:,:,:,2);

