function detsout = helperReadMOTDetection(sequenceInfo, asCell)
if nargin == 1
    asCell = false;
end

opts = delimitedTextImportOptions("NumVariables", 10);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["FrameID", "TruthID", "Top", "Left", "Width", "Height", "Score", "WorldX", "WorldY", "WorldZ"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "skip";

% Import the data
filenameparts = split(sequenceInfo.ImagePath,filesep);
filename = filenameparts(1) + filesep + "det" + filesep + "det.txt";
det = readtable(filename, opts);
detstruct = table2struct(det);


% objectDetection is the interface for detections in SFTT
detections = repmat(objectDetection(0,[0 0 0 0]),size(detstruct));

for i=1:numel(detections)
    detections(i).Time = (detstruct(i).FrameID -1) * 1/sequenceInfo.FrameRate;
    detections(i).Measurement = [detstruct(i).Top detstruct(i).Left detstruct(i).Width detstruct(i).Height];
    detections(i).ObjectAttributes = struct('Score', detstruct(i).Score);
end

if asCell
    numFrames = sequenceInfo.SequenceLength;
    detsout = cell(1,numFrames);
    allframeids = [detstruct.FrameID];
    for i=1:numFrames
        detsout{i} = detections(allframeids == i);
    end
else
    detsout = detections;
end
