function [ matrix ] = avg10(m)
% matrix = compress(m, 5000, 2000, 8);
% Takes data sampled at 'hertz' and outputs data at a smaller sampling
% rate, 'desired_hertz'.

matrix = zeros(length(m(:,1)),length(m(1,:))/10);
for i = 1:length(matrix)
    matrix(:,i) = mean(m(:,10*(i-1)+1:10*(i-1)+10),2);
end

end