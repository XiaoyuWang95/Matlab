figure;
    hold on
    xlim([0.5,6.5]);  %establishes axis range for x axis
    ylim([0.5,6.5]);  %establishes axis range for y axis
    pointlocation=ginput(1)  %ginput is a function that allows a mouse-controlled input  of 4 points 
                  %via the graphical interface.  Just click on the graph 4
                  %times.  Each click is recorded as a row of 2 values (x
                  %and y coordinates) in the 4 X 2  matrix known as 'a'.
    XAxisSpot = pointlocation(1)
    YAxisSpot = pointlocation(2)
    