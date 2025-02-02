% Evaluation function
function numCorrectlyTracked = evaluateTrackingAccuracy(trackedBoxes, groundTruthBoxes)
    if isempty(groundTruthBoxes) || isempty(trackedBoxes)
        numCorrectlyTracked = 0;
        return;
    end
    
    numCorrectlyTracked = 0;
    for i = 1:size(groundTruthBoxes, 1)
        % Calculate IoU with all tracked boxes
        IoUs = bboxOverlapRatio(groundTruthBoxes(i, :), trackedBoxes);
        
        % If IoU exceeds a threshold, consider the object as correctly tracked
        if any(IoUs > 0.5)
            numCorrectlyTracked = numCorrectlyTracked + 1;
        end
    end
end
