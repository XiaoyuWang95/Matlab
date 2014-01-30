M1 = xlsread ('Matrix1.xls');    %input an excel sheet obtained from M4N website.
M2 = xlsread ('Matrix2.xls'); %input another excel sheet obtained from M4N website.
M3 = xlsread ('Matrix3.xls'); %input another excel sheet obtained from M4N website.

Movies = [];

temp = [M1 M2 M3];  %Each xls is one column.  This statement merges them into one 1603 X 2 matrix.
k=1;  
for i=1:length(temp)
    if isnan(temp(i,2))==0 & isnan(temp(i,3))==0   
        % isnan means 'is not a number'
        % isnan returns 1 if the value at said element is not a number.
        % if it is a number, then isnan returns a 0.
        Movies(k,:)=temp(i,:);  %Movies is a new matrix, that contains ONLY those rows from M1 and M2 that contain two numbers.  
        k= k+1;  %Move to the next line of Movies so as to avoid writing over stored data.  This is brilliant!  We do not need to know how many data points are missing in M1 and M2!
    end
end

IntermovieCorrelation = corrcoef(Movies(:,2),Movies(:,3))  %function corrcoef calculates the correlation coefficient.

figure 

plot (Movies(:,2),Movies(:,3),'.','markersize',24)  

Averages = mean(Movies)

figure;
subplot (1,2,1);
hold on;
hist (Movies(:,2),9)  % make a histogram plot of the first column of values in Movies.  Divide it into 9 bins.
%histfit (Movies(:,1)) THE AUTHORS MAKE REFERENCE TO THE histfit
                    %function, which appears not to exist in my version of MatLab. 
xlim ([0 4]);
title ('Matrix II');
subplot (1,2,2)  %subplot(r,c,p) means there is more than one plot in the resulting window. r= # of rows.  c= # of columns.  n= position of the current graph, which is counted out by rows.
                % Position 2 in a 1 row, 2 column window is the right-side plot.  Position 3 in a 2 row, 2 column window is the bottom left-side plot.     
                
hold on;
hist (Movies(:,3),9)  % make a histogram plot of the second column of values in Movies.  Divide it into 9 bins.
%histfit (Movies(:,2),9)
xlim ([0 4]);
title ('Matrix III');

MT2=(Movies(:,2)*2)+1;  %These two lines remove the 0.5 unit gradations and the zeroes from the movie rating data set.
MT1=(Movies(:,3)*2)+1;
CountOccurrences= zeros(9,9);  %CountOccurrences = a 9 X 9 matrix of zeroes.

for i=1:length(Movies)    
    CountOccurrences(MT1(i,1),MT2(i,1))=CountOccurrences(MT1(i,1),MT2(i,1))+1;  %The matrix value corresponding to any given pair of ratings for Matrix 1 and Matrix 2 is incremented for each occurrence of that pair of ratings.
end;
figure
surf(CountOccurrences);  %Make a surface plot of CountOccurrences.
shading interp           %Smooth the shading by interpolation of color values across the surface plot.  
xlabel('Ratings for matrix 3');
ylabel('Ratings for matrix 2');
zlabel('frequency');   
xlim ([0 10]);
ylim ([0 10]);