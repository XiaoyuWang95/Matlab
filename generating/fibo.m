function ff = fibo(n)
% FIBO - Generate Fibonacci numbers
% ff = FIBO(n) returns a vector containing the first N
% Fibonacci numbers, that is, the first part of the
% sequence (1, 1, 2, 3, 5, 8, ...).

ff = zeros(n, 1);
ff(1) = 1;
if n>1
    ff(2) = 1;
end
for k=3:n
    ff(k) = ff(k-2) + ff(k-1);
end