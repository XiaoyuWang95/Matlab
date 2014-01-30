%This is code I have written in fulfilment of exercise 5.2 in chapter 5 of the book Matlab for Neuroscientists.  


test_disp = uint8(zeros(25,25,3))



test_disp(12,25,:)=255

figure

for i=1:25
  image (test_disp);
  test_disp = circshift(test_disp,[0 1 0]);
  M(i)=getframe;
end  

movie(M,6,24)


for i=1:25
  image (test_disp);
  test_disp = circshift(test_disp,[0 -1 0]);
  M(i)=getframe;
end  

movie(M,6,24)