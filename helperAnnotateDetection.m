function frame =  helperAnnotateDetection(frame, detections)
if isempty(detections)
    return
end
positions = vertcat(detections.Measurement);
scorelabels = arrayfun(@(x) x.ObjectAttributes.Score, detections);
frame = insertObjectAnnotation(frame, 'Rectangle',positions, scorelabels,'TextBoxOpacity',0.7,'FontSize',14,'LineWidth',2);