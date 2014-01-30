figure
for count9=1:9
    subplot (3,3,count9) %each iteration (n=9) makes a new panel in a 3 X 3 matrix of graphic panels in the same figure window.  
    %h = bar (1,1);
    %set(h,'FaceColor',[0 0 count9/9])
    set(bar (1,4),'FaceColor',[count9/9 count9/9 count9/9])  
                    % bar followed by (m,n indicates the width (m) and
                    % height (n) of each bar.
                    %'FaceColor' follwed by brackets indicate 
                    % RGB color components for bars in the graph, all of
                    % which must be between 0 and 1.  The first is the
                    % relative contribution of red, the middle green and the
                    % last blue.
end