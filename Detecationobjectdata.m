    % Deine video file paths
videoPaths = {'D:\Groupproject902MOT\MOT17\FinalReportAndCodeByGroup13\software codes and video files are located in gitlab\MOT17-11-SDP-gt.webm'};

% Load videos
videos = cell(1, numel(videoPaths));
for i = 1:numel(videoPaths)
    videos{i} = VideoReader(videoPaths{i});
end

% Import pre-trained YOLOv4 detector
detector = yolov4ObjectDetector('csp-darknet53-coco');
detector1 = yolov4ObjectDetector("tiny-yolov4-coco");
%detector2 = yolov4ObjectDetector("full-yolov4");



% Loop over videos
for vidIndex = 1:numel(videos)
    videoReader = videos{vidIndex};
    numFrames = videoReader.NumFrames;
    obj_size = 0;

    % Loop over frames in the video
    for frameIndex = 1:numFrames
        % Read frame
        frame = readFrame(videoReader);
        if obj_size < 143000   %obj_size > s;t;
            det_cho = detector1;
            version = 'Tiny (288)';
        elseif (143001 < obj_size) < 163000
            det_cho = detector;
            version = 'Full (416)';
        end


%if x==1, detector = detector1, else if x==condition2 detector ==
%detector2, ... else detector == detector4

        % Detect objects in the frame using YOLOv4 detector
        [bboxes, scores, labels] = detect(det_cho, frame);
        tmp= bboxes(2);
        h = bboxes(1);
        obj_size = h * tmp;
        % Visualize detection results
        detectedFrame = insertObjectAnnotation(frame, 'rectangle', bboxes, labels);
        
        % Display the frame with detection results
        imshow(detectedFrame);
        title({[['Video: ' , num2str(vidIndex)], ....
            [ '  Frame: ' , num2str(frameIndex)], ....
            [ '  Number of Objects Tracking: ' , num2str(size(bboxes, 1))], ....
            ['   YOLOv4 Version: ',version]]});
        drawnow;
        
        % Pause for a moment (optional, adjust as needed)
        pause(0);
    end
end

% Define detection threshold and accuracy
detectionThreshold = 0.5; % Threshold for object detection
detectionAccuracy = 0.95; % Accuracy of the YOLOv4 detector

% Create MultiObjectTracker
tracker = MultiObjectTracker();

% Arrays to store tracking results for evaluation
ground_Truths = {};  % Ground truth bounding boxes
detections = {};    % Detected bounding boxes
tracked_Objects = {}; % Tracked bounding boxes
numFramesPerVideo = [100, 120, 80]; % Number of frames in each video
numVideos = numel(numFramesPerVideo);

% Define ground truth bounding boxes for each frame in each video
groundTruths = cell(1, numVideos);
for vidIndex = 1:numVideos
    numFrames = numFramesPerVideo(vidIndex);
    groundTruths{vidIndex} = cell(1, numFrames);
    for frameIndex = 1:numFrames
        % Generate random number of bounding boxes for each frame
        numBoxes = randi([1, 5]); % Randomly choose between 1 and 5 boxes per frame
        
        % Generate random bounding boxes
        bboxes = rand(numBoxes, 4) * 100; % Random bounding boxes (xmin, ymin, width, height)
        
        % Store the bounding boxes for the current frame
        groundTruths{vidIndex}{frameIndex} = bboxes;
    end
end


% Initialize groundTruths and trackedObjects cell arrays
groundTruths = cell(1, numVideos);
trackedObjects = cell(1, numVideos);

% Initialize precision and recall arrays
precisionArray = rand(1, numVideos); % Random precision values
recallArray = rand(1, numVideos);    % Random recall values

% Plot precision and recall
figure;
bar([precisionArray; recallArray]');
xlabel('Video Index');
ylabel('Value');
legend({'Precision', 'Recall'});
title('Precision and Recall per Video');

