function liveplot4Calibrate
% Clear everything
close all; clear all;
% reset all ports; otherwise might be unable to connect to port
instrreset;

% create our clean up object for interrupt
cleanupObj = onCleanup(@cleanMeUp);

% NAME THE TEST FIRST
% The code will read from the previous data, or establish a new file if no
% data present. 
% MUST CHANGE NAME OR DELETE PREVIOUS FILE IF DIFFERENT NUMBER OF DATA POINTS PASSED IN EACH TIME
fileName = 'test1';
% NAME THE FOLDER YOU WANT THE TEST TO BE IN
folderName = 'Test_Data_1';
% Name the sensors
testDevice = 'PT'

dataFileExist = 0;
prevArray = [];
if exist([fileName,'.xls'])
   dataFileExist = 1;
   prevTable = readtable([fileName,'.xls']);
   prevArray = table2array(prevTable);
   prevArray = prevArray(2:end,:)
end



% set up table to collect data (CHANGE)

dataLabels = ["PT1","PT2","PT3","PT4","PT5","PT6","PT7","PT_Reading"];
% sz = [1,7];

finalArray = 0;
reading = 0;

data1 = 0;
data2 = 0;
data3 = 0;
data4 = 0;
data5 = 0;
data6 = 0;
data7 = 0;

% set up serial object
serialPortName = '/dev/cu.SLAB_USBtoUART'
% serialPortName = 'COM6'; % on Windows would be COMx
%s = serialport(serialPortName,115200);
s = serial(serialPortName,'BaudRate',115200);

% open serial port
fopen(s);



% for storing data sequentially in data1 and data2
i = 1;

% read data
flushinput(s);
fscanf(s);


while(1)
    str = split(fscanf(s));

    % each data line represents one sensor data


    % data1 receives flowrate in L/min
    % data1(i) = str2double(str{2})/10000;
    if i == 1
        % data1 receives PT1
        data1 = str2double(str{1});
        % data2 receives PT2
        data2 = str2double(str{2});
        data3 = str2double(str{3});
        data4 = str2double(str{4});
        data5 = str2double(str{5});
        data6 = str2double(str{6});
        data7 = str2double(str{7});
    elseif i <= 5
        data1 = [data1;str2double(str{1})];
        data2 = [data2;str2double(str{2})];
        data3 = [data3;str2double(str{3})];
        data4 = [data4;str2double(str{4})];
        data5 = [data5;str2double(str{5})];
        data6 = [data6;str2double(str{6})];
        data7 = [data7;str2double(str{7})];
    else
        data1 = [data1(2:end);str2double(str{1})];
        data2 = [data2(2:end);str2double(str{2})];
        data3 = [data3(2:end);str2double(str{3})];
        data4 = [data4(2:end);str2double(str{4})];
        data5 = [data5(2:end);str2double(str{5})];
        data6 = [data6(2:end);str2double(str{6})];
        data7 = [data7(2:end);str2double(str{7})];
    end
    i = i+1;
end
    function cleanMeUp()
        % saves data to file (or could save to workspace)
        fprintf('saving test data as %s.xls\n',fileName);

        prompt = "What is the pressure gage reading?"
        reading = input(prompt);
        reading
%         str2double(reading);
%         while (isnumeric(reading) == false)
%             prompt = "What is the pressure gage reading?"
%             reading = input(prompt);
%         end
%         reading = str2double(reading);
        if ~exist(folderName, 'dir')
            mkdir(folderName);
            addpath(folderName);
            fprintf("test data folder created\n");
        else
            fprintf("folder already exists\n")
        end


        % calculate values
        data1 = rmoutliers(data1)
        data2 = rmoutliers(data2)
        data3 = rmoutliers(data3)
        data4 = rmoutliers(data4)
        data5 = rmoutliers(data5)
        data6 = rmoutliers(data6)
        data7 = rmoutliers(data7)

        processArray = [mean([data1,data2,data3,data4,data5,data6,data7]),reading];
        prevArray

        processArray

        processArray = [prevArray;processArray];

        a = [];
        endsol = [];
        l = length(processArray(:,1));
     
   
        for j = 1:length(dataLabels)-1
            X = [processArray(:,j),ones(l,1)];
            Y = processArray(end);
            X_T = transpose(X);
            [sol] = mldivide(X_T*X,X_T*Y);
            a = [a;sol(1)];
            endsol = [endsol,sol];
        end
        [processArray]
%         [a;zeros(l-length(a),1)]
% zeros(length(processArray(1)),1)



a
endsol
       
    finalArray = [[a',0];processArray];
%         finalArray = [[prevArray;processArray],[a;zeros(l-j+1,1)]];


        testDataTable = array2table(finalArray,'VariableNames',dataLabels);

        fileString = fileName + ".xls";

        if dataFileExist == 1
            writetable(testDataTable,fileString,'WriteMode','overwrite')
            movefile(fileString,folderName);
        else
            writetable(testDataTable,fileName,"FileType","spreadsheet");
            movefile(fileString,folderName);
   
        end
        fclose(s);
        instrreset;
        dataProcessingGraphing(processArray,endsol)

    end

    function dataProcessingGraphing(array,solution)
        figure;
        plotNumber = length(array(1,:))-1;
       
        for k = 1:plotNumber
            nexttile
            sortedArray = sort(array(:,k));

            x = linspace(sortedArray(1),sortedArray(end),100);
            titleString = [testDevice,num2str(k)];
            plot(array(:,k),array(:,end),'o')
            title(titleString);
            hold on
            y = solution(1,k)*x+solution(2,k);
            plot(x,y,'-r')
            hold off
           

        end
            
        







        


    end



end


