function [freq]  = wisorPlot( filename, hertz, electrodes, start, stop )
% wisorPlot(filename, hertz, electrodes, start, stop)
% Outputs a plot of EEG recordings.
% filename is the name of the file inside single quotes.
% hertz is the sample rate (10000, 5000, 2000, 1000, etc).
% electrodes (make selection)
% start is the second the sample starts at.
% stop is the second the sample ends.

samplenum = (stop-start)*hertz; %the number of samples
try
    fid = fopen(filename);
catch err 
    error(['The file could not be loaded. '...
        'Be sure your file name is correct '...
        'and make sure you are in the correct directory. '...
        'If all else fails, try renaming the file.']);
end

textscan(fid,'%s',4,'delimiter','\n'); %Skips the first four lines of the document
start = start*hertz;    % convert start from sec to ms
textscan(fid,'%f %f %f %f %f %f %f %f %f',start);
text = textscan(fid,'%f %f %f %f %f %f %f %f %f',samplenum,'CollectOutput',1);
matrix = text{1};
colors = {[1,0,1],[1,.9,0],[0,1,1],[1,0,0],[0,1,0],[0,0,1],[0,0,0],[0,.5,0]};
figure(1);
for i = 2:electrodes+1
    color = colors(i-1);
    plot(matrix(:,1),matrix(:,9),'Color',color{1})
    hold on
end
hold off;

samplenum = pow2(nextpow2(samplenum));
y = fft(matrix(:,2),samplenum);        % DFT
f = (0:samplenum-1)*(hertz/samplenum); % Frequency range
p = y.*conj(y)/samplenum;              % Power of the DFT

% Plot single-sided amplitude spectrum.
figure(2);
plot(f(1:floor(samplenum/2)),p(1:floor(samplenum/2))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|y(f)|')
axis([0 50 0 10000000]);

[~, row] = max(p,[],1);
freq = f(row);
fclose('all');

end

