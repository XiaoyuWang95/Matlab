function [] = exportToExcel( filename, stimMean, randMean, row )
% exportToExcel(filename, waves, randoms)
    path = 'C:\Users\wisorlab\Documents\MATLAB\Matlab Scripts\Michele UltraSound Experiments\Excel Files\';
    [~,filename,~] = fileparts(filename);
    savename = [path,'Opto-Ultrasound Wave Trials 60Hz Bandstop Filtered.xlsx'];
    
    if ~isempty(strfind(lower(filename),'us'))
        type = 'US';
    elseif ~isempty(strfind(lower(filename),'opto'))
        type = 'Opto';
    else
        type = ' ';
        disp(['US/Opto Stimulation type cannot be determined from file name', filename]);
    end
    triggerRowInfo = {filename,type,'Stimulated'};
    controlRowInfo = {filename,type,'Random'};
    
    write = 0;
    while write == 0
        try
            xlswrite(savename, triggerRowInfo, 'M. Moore Ultrasound Trials',['A',num2str(row)]);
            xlswrite(savename, stimMean, 'M. Moore Ultrasound Trials',['D',num2str(row)]);
            xlswrite(savename, controlRowInfo, 'M. Moore Ultrasound Trials',['A',num2str(row+1)]);
            xlswrite(savename, randMean, 'M. Moore Ultrasound Trials',['D',num2str(row+1)]);
            write = 1;
        catch err
            response = questdlg(err.message,'Other application(s) using file','Resume','Cancel','Resume');  % Tell user to close file.
            if strcmp(response,'Cancel')
                return;
            end
        end
    end
    deleteEmptyExcelSheets(savename);
end

