for Interval = 1:10 
  tic 
  pause (0.5)
  Accuracy(Interval)=toc;

  a=rand(1,1)
  if a > 0.5
      b=1;
  else 
      b=0;
  end

end

MeanPause = mean (Accuracy);
MaxPause = mean (Accuracy);
MinPause = mean (Accuracy);


