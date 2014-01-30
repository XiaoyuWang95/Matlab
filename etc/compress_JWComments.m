function [ matrix ] = compress_BioPotentials( BioPotential_matrix, hertz, desired_hertz)

% Example of how to call this function: Biopotential_matrix = compress_BioPotentials(m, 5000, 2000, 8);
% Takes data in 'BioPotential_matrix' sampled at 'hertz' and outputs data at a smaller sampling rate, 'desired_hertz'.

electrodes = length(BioPotential_matrix(1,:))-1; %determines the number of columns to process 
%by measuring the number of columns in the first row of BioPotential_matrix ('length(BioPotential_matrix(1,:))') and subtracting out the time stamp column.

matrix = ones(floor(desired_hertz*length(BioPotential_matrix(:,1))/hertz),electrodes+1);  %the new matrix is set to the appropriate size and then populated with ones. 
% The number of columns is conveyed by the number of biopotential channels, plus one column of timestamps.
% The number of rows is the column length for the input matrix times the desired frequency/sampling frequency).
% This value must be rounded down with the floor function to avoid having any empties at the end.

for i = 1:(floor(desired_hertz*length(BioPotential_matrix(:,1))/hertz)); %do the following from the first row to the last row of the new matrix
    matrix(i,:) = BioPotential_matrix(floor((hertz/desired_hertz)*i),:);  %row i takes the values of the equivalent (rounded down) time point in the old.
end

end

