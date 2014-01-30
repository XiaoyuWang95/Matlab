clear  %clears all pre-existing variables from the workspace so they do not impact processing in this run.

files = dir('*.txt')  ;     % the directory function returns a cell array containing the name, date, bytes and date-as-number as a single array for each txt file in this directory.

HowManyFiles = length(files) % Need to know the number of files to process.  This number is encoded as the variable "HowManyFiles". 

for FileCounter = 1:length(files)   %Runs the following set of commands for each file meeting criterion within the current directory.
  InputFileList {FileCounter,1} = files (FileCounter).name;  %InputFileList is a Cell Array of Strings, meaning an array of strings that are not necessarily uniform in number of characters.
  InputFileList {FileCounter,2} = FileCounter; %Each row in InputFileList contains the name of one *.txt file followed by the row number associated with that file in InputFileList. 
end  % the use of '{}' to signify array positions identifies this array as a cell array of strings.

%Here, InputFileList receives the names associated with each file in the directory that meets inclusion criteria.  (FileCounter,1) identifies a cell within InputFileList.  
% '.name' indicates that we need to add the name to InputFileList at element (FileCounter,1).  So now we have a cell array of Strings, in which all input files are listed. 
% For more information on batch processing, see: http://blogs.mathworks.com/steve/2006/06/06/batch-processing/#1

for FileCounter=1:length(files)  %this loop imports the data files one-by-one and processes the data in them into output files.   
  importDSILactateFftfile(files(FileCounter).name);  %importfile is a function (stored as the file'importfile.m' that imports a DSI output text file to produce two matrices.  
                                         % One matrix (textdata) holds the date/time stamp.  The other (data) holds the lactate and EEG data.
  %It is a major caveat that the headers from the txt file are retained in textdata but not in data, which means that data and textdata are not aligned with respect to epoch number
                                        
  figure  %declares that a figure will be produced
  hold on  %says that multiple curves can be printed on each plot.

  State=textdata(:,2);  % makes a vector of the state data, the second column of the matrix known as textdata.
  for TextShifter = 1:(length(State)-2)  
    State (TextShifter)= State (TextShifter+2); % this loop will shift each state classification within the vector so that its row now corresponds with that of the fft data in the data matrix.
  end
  
  fftonly = data (:,2:41); % fftonly is a matrix with as many rows as there are rows in the input file, and 40 columns corresponding to the EEG1 and EEG2 ffts in 1 Hz bins.

  for LineReader = 21:40  %this loop initializes the three vectors that will ultimately sum up the power spectra (0-20 Hz in 1 Hz bins) for each state within the file.
    SumFftNrem(LineReader-20)= 0;
    SumFftWake(LineReader-20)= 0;
    SumFftRems(LineReader-20)= 0;
  end  

  NumFftNrem= 0;  %these scalars count the number of epochs of each state used to calculate the power spectra.  They are initialized here. 
  NumFftWake= 0;
  NumFftRems= 0;

  for StateFinder=2:(length(data)-1) % this loop goes through the entire vector of state classifications and identifies those suitable for output and outputs them. 
    for LineReader = 21:40  % this loop counts 21 thru 40 so as to measure the EEG2 values rather than the EEG1 values.  
      if strcmp (State(StateFinder-1) , 'S') &  strcmp (State(StateFinder) , 'S') & strcmp (State(StateFinder+1) , 'S') %if an epoch is NREMS and surrounded by other NREMS epochs, it is included. 
        SumFftNrem(LineReader-20)=SumFftNrem(LineReader-20) + (fftonly(StateFinder,LineReader)); %data from Eeg2 is added to the SumFft vector (values 1-20) for NREMS. 
        NumFftNrem=NumFftNrem + 1;  %increment the number of NREMS epochs so we can use this as the denominator in calculating the average FFT power.
      end
      if strcmp (State(StateFinder-1) , 'W') &  strcmp (State(StateFinder) , 'W') & strcmp (State(StateFinder+1) , 'W') %if an epoch is wake and surrounded by other NREMS epochs, it is included. 
        SumFftWake(LineReader-20)=SumFftWake(LineReader-20) + (fftonly(StateFinder,LineReader));%data from Eeg2 is added to the SumFft vector (values 1-20) for Wake. 
        NumFftWake=NumFftWake + 1;  %increment the number of wake epochs so we can use this as the denominator in calculating the average FFT power.
      end
      if strcmp (State(StateFinder-1) , 'R') &  strcmp (State(StateFinder) , 'R') & strcmp (State(StateFinder+1) , 'R') %if an epoch is REMS and surrounded by other NREMS epochs, it is included. 
        SumFftRems(LineReader-20)=SumFftRems(LineReader-20) + (fftonly(StateFinder,LineReader));%data from Eeg2 is added to the SumFft vector (values 1-20) for REMS. 
        NumFftRems=NumFftRems + 1;  %increment the number of REMS epochs so we can use this as the denominator in calculating the average FFT power.
      end % of loop that accumulates REMS fft power data.
    end % of loop that runs through columns 21-40 to collect Fft data from EEG2.
  end % of loop that runs through the entire DSI file epoch by epoch in search of epochs suitable for inclusion.
  
  %From here on out, we add the data from this animal's FFTs into a set of matrices (one for each state) that will be outputted into a  spreadsheet. 
  
  %The vector array of strings StateType must be created so as to identify the data that will be outputted in subsequent columns on each line of the output spreadhseet.
  StateType{1} = 'Nrem_FFT'; 
  StateType{2} = 'Wake_FFT'; 
  StateType{3} = 'Rems_FFT';
  StateType{4} = 'FFts: Nrems... Wake... Rems in 20 1-Hz bins';
  
  %The first row of the line for this mouse within each matrix will identify the state from which the FFT data are derived.
  AllFftNrem(FileCounter,1) = StateType(1); 
  AllFftWake(FileCounter,1) = StateType(2);
  AllFftRems(FileCounter,1) = StateType(3);
  FftAllStates(FileCounter,1) = StateType(4); %FftAllStates will contain the data from all three states printed consecutively over 60 lines. 
    
  %The second row of the line for this mouse within each matrix will identify the mouse ID.
  FftAllStates(FileCounter,2) = InputFileList(FileCounter,1); 
  AllFftNrem(FileCounter,2) = InputFileList(FileCounter,1);
  AllFftWake(FileCounter,2) = InputFileList(FileCounter,1);
  AllFftRems(FileCounter,2) = InputFileList(FileCounter,1);
  
  %The third through 22nd row of the line for this mouse within each matrix will list the average FFT for all epochs meeting criteria for the state of interest.
  %First we must calculate the averages by dividing the sums by the number of epochs tallied.
  for LineReader = 1:20
    AverageFftNrem(LineReader) = (SumFftNrem(LineReader))/NumFftNrem;
    AverageFftWake(LineReader) = (SumFftWake(LineReader))/NumFftWake;
    AverageFftRems(LineReader) = (SumFftRems(LineReader))/NumFftRems;
    AllFftNrem{FileCounter,LineReader+2} = AverageFftNrem(LineReader);    %Next, output these avg values to columns 3-22 of the matrix.
    AllFftWake{FileCounter,LineReader+2} = AverageFftWake(LineReader);
    AllFftRems{FileCounter,LineReader+2} = AverageFftRems(LineReader);
    FftAllStates{FileCounter,LineReader+2} = AverageFftNrem(LineReader); %For the Ffts on all states, assign to the matrix the three states sequentially. 
    FftAllStates{FileCounter,LineReader+22} = AverageFftWake(LineReader);
    FftAllStates{FileCounter,LineReader+42} = AverageFftRems(LineReader);
  end


  % plot the averaged curves in Matlab.
  plot (AverageFftNrem,'b');  
  plot (AverageFftWake,'k');
  plot (AverageFftRems,'r');

  % format the plot t the averaged curves in Matlab.
  legendtext = cell(3,1) ;  %declares that legendtext is a 3 X 1 matrix.
  legendtext{1} = ['Nr'] ;
  legendtext{2} = ['Wk'] ;
  legendtext{3} = ['Rm'] ;

  legend(legendtext,'Location','SouthEast')

  xlabel (files(FileCounter).name)
                                                                               
end

xlswrite ('OutPutNr.xlsx', AllFftNrem)
xlswrite ('OutPutWk.xlsx', AllFftWake)
xlswrite ('OutPutRm.xlsx', AllFftRems)
xlswrite ('OutPutAll.xlsx', FftAllStates)