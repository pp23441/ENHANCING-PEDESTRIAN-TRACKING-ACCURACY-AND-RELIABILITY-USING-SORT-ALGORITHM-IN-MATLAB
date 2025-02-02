% Define dataset name and paths
datasetName = "PedestrianTracking";
seqinfoPath = fullfile(datasetName, 'seqinfo.ini');
gtFilePath = fullfile(datasetName, 'gt', 'gt.txt');
detFilePath = fullfile(datasetName, 'det', 'det.txt');
videoOutputFile = datasetName + "Video.avi";

% Display sequence information
disp("Sequence Information:");
type(seqinfoPath);

% Display ground truth (gt.txt)
disp("Ground Truth (gt.txt):");
dbtype(gtFilePath, "1:10");

% Display detections (det.txt)
disp("Detections (det.txt):");
dbtype(detFilePath, "1:10");

% Read sequence information
sequenceInfo = helperReadMOTSequenceInfo(seqinfoPath);

% Create and save video if it doesn't exist
if ~exist(videoOutputFile, "file")
    v = VideoWriter(videoOutputFile);
    v.FrameRate = sequenceInfo.FrameRate;
    open(v);
    for i = 1:sequenceInfo.SequenceLength
        frameName = fullfile(datasetName, sequenceInfo.ImagePath, sprintf("%06d%s", i, sequenceInfo.ImageExtension));
        writeVideo(v, imread(frameName));
    end
    close(v);
end

% Read ground truth and detections
truths = helperReadMOTGroundTruth(sequenceInfo);
detections = helperReadMOTDetection(sequenceInfo);

% Display some information about the data
disp("Ground Truths:");
disp(truths);
disp("Detections:");
disp(detections);
disp("Attributes of the first detection:");
disp(detections(1).ObjectAttributes);

% Set visualization options
showDetections = false;
showGroundTruth = true;

% Process frames
reader = VideoReader(videoOutputFile);
groundTruthHistoryDuration = 3 / sequenceInfo.FrameRate; % Time persistence (s) of ground truth trajectories
pastTruths = [];
for i = 1:sequenceInfo.SequenceLength
    % Find truths and detection in the i-th frame
    time = (i - 1) / sequenceInfo.FrameRate;
    curDets = detections(ismembertol([detections.Time], time));
    curTruths = truths(ismembertol([truths.Time], time));

    frame = readFrame(reader);
    
    % Annotate frame with detections and ground truth
    if showDetections
        frame = helperAnnotateDetection(frame, curDets);
    end
    if showGroundTruth
        frame = helperAnnotateGroundTruth(frame, curTruths, pastTruths);
    end
    
    % Update past truths
    pastTruths = [pastTruths; curTruths]; 
    pastTruths([pastTruths.Time] < time - groundTruthHistoryDuration) = [];
    
    imshow(frame);
end
