figure
a = -8:0.2:4;
[x,y] = meshgrid(a,a);
z = sin(x)-(sin(y*2)/10)+y/2
subplot (1,2,2)  % (r,c,n) indicates that there will be r rows of plots, 
                 % c columns of plots within each row and the relative
                 % position of the plot called in the next line of code
                 % within that grid.
surf (z)    % make a surface plot of z against X and Y
shading interp  %applies only for surface plots- allows colors on surface
subplot (1,2,1)  %specifies that the next line will plot on top row, left
mesh(z)     % make a mesh plot of z against X and Y
    %plot to bleed together.
colormap hot  %applies for both surface and mesh plots
