% run this script immediately after clicking the 'Run Analysis' button in 'Main.m'

clear NewEpochs_OPTO values output; figure; hold on

utils = getUtils; % import the 'utils' module, which contains various functions we'll be using later
datatank = CurrentTank;
datablock = CurrentBlock;

% Open an ActiveX connection with TDT software
TTX = actxcontrol('TDevAcc.X');
TTX.ConnectServer('Local');
TT = actxcontrol('TTank.X');
TT.ConnectServer('Local','Me');
TT.OpenTank(datatank,'R');
%recblock = TT.GetHotBlock
TT.SelectBlock(datablock);
TT.CreateEpocIndexing;
TT.SetGlobals('Channel=2; T1=0; T2=0; Options=NEW');
N=TT.ReadEventsSimple('TRGR');
EEG = TT.ParseEvV(0, N);
timestamps = TT.ParseEvInfoV(0, N, 6);
MyEpocs_OPTO = TT.GetEpocsV('OPTO',0,0,1000);
MyEpocs_PEAK=TT.GetEpocsV('PEAK',0,0,1000);
n=0;

% this part fixes the data
for j=1:numel(MyEpocs_PEAK)/4
    if j>numel(timestamps)
        break
    end
    if MyEpocs_PEAK(2,j+n)-timestamps(j)<0.9
        n=n+1;
    end
    NewEpocs_PEAK(j)=MyEpocs_PEAK(2,j+n);
    NewEpocs_OPTO(j)=MyEpocs_OPTO(1,j+n);
end

pause on
Av=N;
while TTX.GetSysMode>1
    pause(7);
    N=TT.ReadEventsSimple('TRGR');
    if N>0
        MyEpocs_OPTO = TT.GetEpocsV('OPTO',0,0,1000);
        Av=N+Av;
        NEEG=TT.ParseEvV(0, N);
        EEG =cat(2,EEG,NEEG);
        Av=N+Av;
        EEGS=sum(EEG,2)/Av;
        plot(EEGS);
    end
end
TT.CloseTank;
TT.ReleaseServer;

% at this point, the data should be 'fixed', now create output structure
output = struct('eegs',[]);
stimtypes = [0,20,40,50,100,250,500];
for i=1:numel(stimtypes)
    indices = find(NewEpocs_OPTO==stimtypes(i));
    values = EEG(:,indices(indices<size(EEG,2)));
    eval(['output.eegs.EEG' num2str(stimtypes(i)) '=values;']);
end

% then average & plot
fields = fieldnames(output.eegs);
set(gca,'Color','black');
colors = {'red','blue','white','yellow','magenta','cyan','green'};
for i=1:numel(fields)
    plot(mean(output.eegs.(fields{i}),2),colors{i});
end

% open an Excel ActiveX Connection with the data
Excel = actxserver('Excel.Application');
set(Excel, 'Visible', 1);
Workbooks = Excel.Workbooks;
Workbook.triggered = invoke(Workbooks, 'Add');
sheetnames = {'0 msec','20 msec','40 msec','50 msec','100 msec','250 msec','500 msec'};
Sheets = Excel.ActiveWorkBook.Sheets;
for i = 1:4
    invoke(Sheets,'Add');
end
for i = 1:7
    sheet = get(Sheets, 'Item', i);
    invoke(sheet, 'Activate');
    sheet.name = sheetnames{i};

    % write to the sheet
    chunk = output.eegs.(fields{i});
    for j = 1:size(chunk,2)
        dsampled = downsample(chunk(:,j)',20,0);
        sheetRange = get(sheet,'Range',['A' num2str(j) ':' upper(utils.hexavigesimal(numel(dsampled))) num2str(j) ]);
        set(sheetRange, 'Value', dsampled);
    end
end
hold off
