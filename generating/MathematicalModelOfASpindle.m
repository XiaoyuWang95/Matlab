%This script creates an array x, then generates from it 
%a normal distribution (normcurve) and a sine curve (sincurve).
%Multiply the two together and you have a spindle.
x = [-50:0.1:50]; %array
sincurve = sin(x);  %sine curve on x
normcurve = normpdf(x,0,8);  %normal distribution w/baseline @ zero and peak @ 0.0499. 
both = sincurve .* normcurve; %multiply two curves element-wise. 
plot(both);figure(gcf);
%The resulting curve looks strikingly similar to a sleep slow wave.  
