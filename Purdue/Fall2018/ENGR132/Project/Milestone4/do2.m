filecool = "M3_Data_CoolingTimeHistories.csv";
fileheat = "M3_Data_HeatingTimeHistories.csv";

filecooldataOriginal = csvread(filecool);  %input the data
% the size of the cool data
[rowSizeCoolData, colSizeCoolData] = size(filecooldataOriginal);
timeCol = filecooldataOriginal(:,1);   % the first column is time
filecooldata = filecooldataOriginal(:,2:colSizeCoolData);
fileheatdata = csvread(fileheat, 0,1);

file = [filecooldata fileheatdata];  %combine two files into one file
[fileRowSize, fileColSize] = size(file); % the size of the file array

tempCol = file(:,43);

   [yL4, yH4, tS4, tau4, SSEmod4, string4] = ...
            Project_M4Algorithm_002_08(timeCol, tempCol);
  [yL3, yH3, tS3, tau3, string3] = Project_M3Algorithm_002_08(timeCol, tempCol);
        
yL4
yL3
yH4
yH3
tS4
tS3
tau4
tau3

if string3 == "cooling"
    z4 = exp(-(tau4-tS4)/tau4);
    z3 = exp(-(tau3-tS3)/tau3);
elseif string3 == "heating"
    z4 = 1-exp(-(tau4-tS4)/tau4);
    z3 = 1-exp(-(tau3-tS3)/tau3);
end

z4
z3