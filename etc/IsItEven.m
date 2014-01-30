function [Outputter] = IsItEven(InputNumber)
%UNTITLED2 Summary of this function goes here
%   This function will return 2 if InputNumber is even and 1 if InputNumber is odd. 

Tester = mod (InputNumber,2)

if Tester ==0
    Outputter=2;
else  Outputter=1;
end

end

