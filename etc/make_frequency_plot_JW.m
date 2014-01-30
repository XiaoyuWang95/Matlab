function [LA,UA]=make_frequency_plot(DataMatrix,signal)
% USAGE: [LA,UA]=make_frequency_plot(DataMatrix,signal)
%
% this function reads in a sleep data file like those
% given to me by J. Wisor 2011. 
% signal is 'lactate' or 'delta'
% uses 1-4 Hz as delta, but this could easily be changed by
% changing the line data=mean(DataMatrix(:,4:6),2) 
% to data=mean(DataMatrix(:,3:6),2)

if strcmp(signal,'delta')
  data=mean(DataMatrix(:,4:6),2);
elseif strcmp(signal,'lactate')
  data=DataMatrix(:,2);
end

% flag for plotting, if 1 you get a plot of the histogram for the
% moving window of the data, showing UA and LA as they change with
% time
animation=0;

if strcmp(signal,'delta')
  % If using delta power like Franken 2001 does, 
  % to find LA (lower assymptote), the intersection of the REM
  % histogram and SWS histogram

  % Find all the rows where sleep state is SWS (denoted by a 1)
  rowsleep=find(DataMatrix(:,1)==1);
  sleepdata=data(rowsleep);
  
  % Find all the rows where sleep state is REM (denoted by a 2)
  rowrem=find(DataMatrix(:,1)==2);
  remdata=data(rowrem);
  
  % Find all the rows where sleep state is wake (denoted by 0)
  rowwake=find(DataMatrix(:,1)==0);
  wakedata=data(rowwake);
  
  xbins=linspace(0,max(sleepdata),30);
  
  % make the histograms
  figure
  [ns,xs]=hist(sleepdata,xbins);  %sleep data
  bar(xs,ns)
  h = findobj(gca,'Type','patch');
  set(h,'FaceColor',[1 0 0],'EdgeColor','w')
  hold off
  
  [nr,xr]=hist(remdata,xbins);   %REM data
  bar(xr,nr)
  % h = findobj(gca,'Type','patch');
  % set(h,'FaceColor',[0 0.5 0.5],'EdgeColor','w')
  
  %[nw,xw]=hist(wakedata,xbins)  % wake data
  % h = findobj(gca,'Type','patch');
  % set(h,'FaceColor',[0 1 0],'EdgeColor','w')
  
  
  difference=ns-nr;  % need to find where this is 0
  id=find(diff(difference >= 0)); % finds crossings of the difference
                                  % vector, (keep only last one)
  
  if(isempty(id)) % if they don't cross
    loc=find(nr>0);  % find first non-zero bin of REM
    LA=xr(loc(1)); % set to first non-zero bin  
  else
    id=id(end);
    LA = xs(id)-(difference(id)*(xs(id+1)-xs(id))/(difference(id+1)-difference(id)));
  end
  %plot(LA,0:max(ns)) % plot vertical line at LA
  
  % UA (upper assymptote)
  UA=quantile(sleepdata,.9);
  %plot(UA,0:max(ns))
  hold off
end


% --- Case where lactate is the signal --------
%
% For this case use a sliding 2-hour window to compute UA and LA.
% Compute the frequency plot of all states (sleep, wake, REM) for
% the 2-hour window centered at that time. Compute UA and LA for
% these data and use them in the next step of S.  Compute UA and LA
% again for the next window and use this in the next update of S.

if strcmp(signal,'lactate')
  
  % plotting stuff
  if(animation)
    figure
    xbins=linspace(0,max(data(1:721)),30);
    [nall,xall]=hist(data(1:721),xbins);
    h=bar(xall,nall)
    axis([0 19.5 0 500]) 
  end
  
  for i=361:(length(data)-360)
    % if using lactate, the histograms for SWS and REM will overlap,
    % so just use the 1st percentile for SWS
    LA(i-360)=quantile(data(i-360:i+360),.05);
    UA(i-360)=quantile(data(i-360:i+360),.95);
    
    
    if(animation)
      xbins=linspace(0,max(data(i-360:i+360)),30);
      [nall,xall]=hist(data(i-360:i+360),xbins);
      set(h,'XData',xall,'YData',nall)
      l1=line([LA(i-360) LA(i-360)],[0 max(nall)]);
      l2=line([UA(i-360) UA(i-360)],[0 max(nall)]);
      %drawnow
      delete(l1)
      delete(l2)
    end
    
  end
  
  delete(findall(0,'Type','figure'))

end



