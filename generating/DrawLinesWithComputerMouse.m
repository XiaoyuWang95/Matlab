figure;
hold on
xlim([0,1]);  %establishes axis range for x axis
ylim([0,1]);  %establishes axis range for y axis
for count5 = 1:5
    pointlocation=ginput(4);  %ginput is a function that allows a mouse-controlled input  of 4 points 
                  %via the graphical interface.  Just click on the graph 4
                  %times.  Each click is recorded as a row of 2 values (x
                  %and y coordinates) in the 4 X 2  matrix known as 'a'.
        
                  
    plot(pointlocation(:,1),pointlocation(:,2));  
end
    