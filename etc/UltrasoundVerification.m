function [] = UltrasoundVerification(filename, export)
    disp('Reading in file data...');
    [t,ttl,eeg] = ultrasoundMCRead(filename);
    disp('Smoothing data...');
    driftCorrected = movingSmoothing(eeg,150);
    
    % A bandstop filter that takes out 60Hz noise
    Fpass1 = 58;      % First Passband Frequency
    Fstop1 = 59;      % First Stopband Frequency
    Fstop2 = 61;      % Second Stopband Frequency
    Fpass2 = 62;      % Second Passband Frequency
    Apass1 = 0.5;     % First Passband Ripple (dB)
    Astop  = 60;      % Stopband Attenuation (dB)
    Apass2 = 1;       % Second Passband Ripple (dB)
    match  = 'both';  % Band to match exactly

    % Construct an FDESIGN object and call its ELLIP method.
    h  = fdesign.bandstop(Fpass1, Fstop1, Fstop2, Fpass2, Apass1, Astop, ...
                          Apass2, 5000);
    Hd = design(h, 'ellip', 'MatchExactly', match);
    
   driftCorrected = filter(Hd, driftCorrected);
    disp('Finding trigger patterns...');
    [waves,randoms] = findTriggerPattern(driftCorrected, ttl, t);
    if nargin == 2 && export == 1
        disp('Exporting waves to Excel...');
        exportToExcel(filename,waves,randoms)
    end
    disp('Objective complete.');
    
    % Plot the original signal
    figure
    subplot(2,3,1),plot(t,eeg);
    title(['Original Signal of ', filename]);

    
    % Plot the drift-corrected signal
    subplot(2,3,4),plot(t,driftCorrected);
    title(['Drift-Corrected Signal of ', filename]);

    % Plot all the triggered waveforms
    fs = 5000;
    wavetvec = 0:1/fs:.3; % ***THIS MUST BE MODIFIED IF THE WINDOW OF THE SNAPSHOT CHANGES
    subplot(2,3,2),plot(wavetvec,waves);
    title(['All Triggered Waveforms of ', filename]);
    meanwave = mean(waves(:,1:end));

    % Plot the mean of the triggered waveforms
    subplot(2,3,5),plot(wavetvec,meanwave)
    title(['Mean Triggered Waveform of ', filename]);
    axis([0 0.3 -1 1]);
  
    % Plot all the random waveforms
    subplot(2,3,3),plot(wavetvec,randoms);
    title(['All Random Waveforms of ', filename])
    meancontrol = mean(randoms(:,1:end));

    % Plot the mean of the randoms
    subplot(2,3,6),plot(wavetvec,meancontrol);
    title(['Control Waveform of ', filename])
    axis([0 0.3 -1 1]);
end