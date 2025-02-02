function trackedDetections = trackObjectsSORT(tracker, detections)
    % Placeholder for SORT or DeepSORT-based tracking
     tracker.Detections = tracker.track(detections);
    
    % For simplicity, let's return dummy tracked detections
    trackedDetections = detections;
end
