function trueobjects = helperReadMOTGroundTruth(sequenceInfo)

opts = delimitedTextImportOptions("NumVariables", 9);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["FrameID", "TruthID", "Top", "Left", "Width", "Height", "Valid", "ClassID", "Visible"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "skip";

% Import the data
filenameparts = split(sequenceInfo.ImagePath,filesep);
filename = filenameparts(1) + filesep + "gt" + filesep + "gt.txt";
gt = readtable(filename, opts);
gtstruct = table2struct(gt);

% Structure format for trackCLEARMetrics
trueobjects = repmat(struct('Time',0,'TruthID',0,'BoundingBox',[0 0 0 0], 'ClassID', 0), size(gtstruct));
framerate = sequenceInfo.FrameRate;
for i=1:numel(trueobjects)
    trueobjects(i).Time = (gtstruct(i).FrameID -1) * 1/framerate;
    trueobjects(i).TruthID = gtstruct(i).TruthID;
    trueobjects(i).BoundingBox = [gtstruct(i).Top gtstruct(i).Left gtstruct(i).Width gtstruct(i).Height];
    trueobjects(i).ClassID = gtstruct(i).ClassID;
    trueobjects(i).Visible = gtstruct(i).Visible;
end