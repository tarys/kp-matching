function [] = thresholdEeg()    
    eeg = mainWindow.user_data;
    thresholdEditHandle = findobj("tag", "thresholdEdit"); 
    threshold = strtod(thresholdEditHandle.string);
    eeg(abs(eeg) <= threshold) = 0;
    
    delete(gca());
    plot(eeg);
endfunction


// load EEG for stationary mode
// to find out max amplitude of "zero-signal"
// The value of max will be used as threshold for EEG dataset
// where real artifact will be searched.


eegScilabDataFileName = uigetfile(["*.sod";], ".", "Выберите ЭЭГ в режиме покоя");
load(eegScilabDataFileName, "eeg");


mainWindow = gcf();
mainWindow.figure_name = 'Программа анализа ЭЭГ';
mainWindow.user_data = eeg;

plot(mainWindow.user_data);

// creating exit button
exitButton = uicontrol(mainWindow, ...
                       "style", "pushbutton", ...
                       "tag", "exitButton", ...
                       "string",  "Выход", ...
                       "position", [10 10 150 25], ...
                       "callback", "exit()");
                       
// creating filter value input field
thresholdEdit = uicontrol(mainWindow, ...
                       "style", "edit", ...
                       "tag", "thresholdEdit", ...
                       "string", "10.0", ...
                       "position", [170 10 150 25]);                    

// creating threshold button
thresholdButton = uicontrol(mainWindow, ...
                       "style", "pushbutton", ...
                       "tag", "thresholdButton", ..
                       "string",  "Отфильтровать", ...
                       "position", [330 10 150 25], ...
                       "callback", "thresholdEeg()");
