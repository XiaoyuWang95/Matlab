clear

files = dir('*.txt')       % the directory function returns a cell array containing the name, date, bytes and date-as-number as a single array for each file meeting criterion.

HowManyFiles = length(files) % Need to know the number of files to process.  This number is encoded as the variable "HowManyFiles". 

for FileCounter = 1:length(files)   %Runs the following command for each file meeting criterion within the current directory.
  InputFileList {FileCounter,1} = files (FileCounter).name  %InputFileList is a Cell Array of Strings, meaning an array of strings that are not necessarily uniform in number of characters.
  InputFileList {FileCounter,2} = FileCounter
end  % the use of '{}' to signify array positions identifies this array as a cell array of strings.
%Here, InputFileList receives the names associated with each file in the directory that meets inclusion criteria.  (FileCounter,1) identifies a subarray of the cell array files.  
% '.name' indicates that we need to add the name to InputFileList at element (FileCounter).  So now we have a cell array of Strings, in which all input files are listed. 
% For more information on batch processing, see: http://blogs.mathworks.com/steve/2006/06/06/batch-processing/#1

for FileCounter=1:length(files)  %this loop imports the data files one-by-one and processes them into output files.   
  importfile(files(FileCounter).name)  %importfile is a function that imports a DSI output text file to produce two matrices.  One matrix is holds the date/time stamp
                                         %the other holds the lactate and EEG data.
  figure
  hold on

  State=textdata(:,2);
  for TextShifter = 1:(length(State)-2)
    State (TextShifter)= State (TextShifter+2);
  end
  
  fftonly = data (:,2:41);

  for LineReader = 1:20
    AverageFft1(LineReader)=mean(fftonly(:,LineReader));
    AverageFft2(LineReader)=mean(fftonly(:,LineReader+20));
  end    

  for LineReader = 21:40
    SumFftNrem(LineReader-20)= 0
    SumFftWake(LineReader-20)= 0
    SumFftRems(LineReader-20)= 0
  end  

  NumFftNrem= 0;
  NumFftWake= 0;
  NumFftRems= 0;
  NumFftBrWk= 0;

  for StateFinder=2:(length(data)-1)
    for LineReader = 21:40  % this loop counts 21 thru 40 so as to measure the EEG2 values rather than the EEG1 values.  
      if strcmp (State(StateFinder-1) , 'S') &  strcmp (State(StateFinder) , 'S') & strcmp (State(StateFinder+1) , 'S') 
        SumFftNrem(LineReader-20)=SumFftNrem(LineReader-20) + (fftonly(StateFinder,LineReader));
        NumFftNrem=NumFftNrem + 1;
      end
      if strcmp (State(StateFinder-1) , 'W') &  strcmp (State(StateFinder) , 'W') & strcmp (State(StateFinder+1) , 'W') 
        SumFftWake(LineReader-20)=SumFftWake(LineReader-20) + (fftonly(StateFinder,LineReader));
        NumFftWake=NumFftWake + 1;
      end
      if strcmp (State(StateFinder-1) , 'R') &  strcmp (State(StateFinder) , 'R') & strcmp (State(StateFinder+1) , 'R') 
        SumFftRems(LineReader-20)=SumFftRems(LineReader-20) + (fftonly(StateFinder,LineReader));
        NumFftRems=NumFftRems + 1;
      end
    end
  end

  for LineReader = 1:20
    AverageFftNrem(LineReader) = (SumFftNrem(LineReader))/NumFftNrem;
    AverageFftWake(LineReader) = (SumFftWake(LineReader))/NumFftWake;
    AverageFftRems(LineReader) = (SumFftRems(LineReader))/NumFftRems;
    AllFftNrem(FileCounter,LineReader) = AverageFftNrem(LineReader);
    AllFftWake(FileCounter,LineReader) = AverageFftWake(LineReader);
    AllFftRems(FileCounter,LineReader) = AverageFftRems(LineReader);
  end



  plot (AverageFftNrem,'b');
  plot (AverageFftWake,'k');
  plot (AverageFftRems,'r');

  legendtext = cell(3,1) ;
  legendtext{1} = ['Nr'] ;
  legendtext{2} = ['Wk'] ;
  legendtext{3} = ['Rm'] ;

  legend(legendtext,'Location','SouthEast')

  xlabel (files(FileCounter).name)
                                                                               
end

xlswrite ('OutPutNr.xls', AllFftNrem)
xlswrite ('OutPutWk.xls', AllFftWake)
xlswrite ('OutPutRm.xls', AllFftRems)