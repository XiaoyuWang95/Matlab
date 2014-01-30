clear all; % empties workspace
close all; %erases all figures
temp=uint8(zeros(400,400,3)); % creates a 400X400X3 array of 8-bit integer values.  All pixels are black because of zero assignment.
temp1= cell(10,1); %creates a cell array that can hold 10 matrices.

for i=1:10 
    temp(200,200,:)=255; % makes a white point at the midpoint of each 400X400 matrix.
    temp(200,240,:)=(i-1)*10; % inserts a target point 40 pixels to the right of the midpoint.  
                              % It will have ten values ranging from 0 to 90.
    temp1{i}=temp; %creates a new cell matrix for each of the ten target point brightness iterations.
end

h=figure %creates a handle to rapidly reference the figure that will be generated.

stimulusorder=randperm(200); %creates a random order for presentation of 200 stimuli.
stimulusorder=mod(stimulusorder,10); % all stimulusorder values from 1 to 200 will return values 0-9. Each value, 0-9 will be represented 20 times.
stimulusorder=stimulusorder+1; %  the range of stimulusorder values is now 1 o 10.

score=zeros(10,1); %this array will tally correct answers.  The subject starts with 0 correct.

for i=1:200 % each iteration of this loop is one trial
    image(temp1{stimulusorder(1,i)}); %Shows the image coded in array temp1 and selected by the vector stimulusorder.
    i %lists trial number on the screen... FYI for the subject.
    pause; %waits for the subject to respond.
    temp2=get(h,'CurrentCharacter');  %Get requires keypad press, either '.'to indicate that stimulus is detected, or ',' to indicate not detected.
    temp3=strcmp('.',temp2); %Compare strings and report true (binary 1) if subject indicated detection of stimulus by pressing '.' Else 0 for false.
    score(stimulusorder(1,i))=score(stimulusorder(1,i))+temp3; %if stimulus was detected, it will be added to tally for this stimulus intensity.
end