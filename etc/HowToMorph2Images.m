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

%figure
%subplot(1,2,1) 
%image(morphfrom)

%subplot(1,2,2) 
%image(morphto)

figure

for pictime=1:10
   for plane=1:3
       for column=0:10:790
          for row=1:1:600
              morphfrom(row,column+pictime,plane)=morphto(row,column+pictime,plane);
          end
       end
   end
   
   image(morphfrom)
   M(pictime)=getframe;
end

movie(M,3,2)

morphfrom=imread('filtering.jpg');

figure

for pictime=1:10
   for plane=1:3
       for column=1:1:800
          for row=0:10:590
              morphfrom(row+pictime,column,plane)=morphto(row+pictime,column,plane);
          end
       end
   end
   
   image(morphfrom)
   M(pictime)=getframe;
end

movie(M,3,2)
