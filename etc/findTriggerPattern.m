function [waves, randoms] = findTriggerPattern(eeg, ttl, msbefore, msafter)
% [waves, randoms] = findTriggerPattern(eeg, ttl, msbefore, msafter)

% Function findTriggerPattern takes snapshots of each wave
% around a TTL triggered event, averages them, and takes random
% snapshots of the signal to create a control average.

if nargin == 2
    msbefore = 100;
    msafter = 200;
end

fs = 5000; % sampling rate

samplestart = msbefore*fs/1000;
sampleend = msafter*fs/1000;
samplesperwave = samplestart+sampleend;

% Faster Solution
% ons = find(ttl > 0);
% onends = find(diff(ons) ~= 1);
% samplestarts = ons(onends+1)-samplestart;
% sampleends = ons(onends+1)+sampleend-1;
% % samplestarts = samplestarts(samplestarts > 0);
% % sampleends = sampleends(end-length(samplestarts):samplestarts);
% waves = zeros(length(sampleends),samplesperwave);
% for i = 1:length(sampleends)
%     waves(i,1:samplesperwave) = eeg(samplestarts(i):sampleends(i));
% end

randoms = zeros(size(waves));
% Create the randoms
for i = 1:length(waves(:,1))
    startIndex = round((length(eeg)-samplesperwave)*rand());
    randoms(i,1:samplesperwave) = eeg(startIndex:startIndex+samplesperwave-1);
end
% 
% randoms = zeros(size(waves));
% % Create the randoms
% for i = 1:length(waves(:,1))
%     startIndex = round(length(eeg)*rand());
%     while startIndex > length(eeg)-samplesperwave
%         startIndex = round(length(eeg)*rand());
%     end
%     randoms(i,1:samplesperwave) = eeg(startIndex:startIndex+samplesperwave-1);
% end

end

