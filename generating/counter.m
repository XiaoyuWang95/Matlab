function [Interval]= Counter(Start,Finish)

Initializer=Start
while Initializer<Finish
  Initializer=Initializer+1;
end

Interval=Finish-Start;
