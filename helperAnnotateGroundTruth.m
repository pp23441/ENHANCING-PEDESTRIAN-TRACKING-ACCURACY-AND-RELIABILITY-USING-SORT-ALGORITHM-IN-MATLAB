function frame = helperAnnotateGroundTruth(frame, truths, pastTruths)

if ~isempty(truths)
    bbox = vertcat(truths.BoundingBox);
    truthlabels = [truths.TruthID];
    colors = getColorByID(truths);
    frame = insertObjectAnnotation(frame, 'Rectangle',bbox, truthlabels,'Color',colors, 'TextBoxOpacity',0.8,'LineWidth',3,'FontSize',18);
end

if ~isempty(pastTruths)
    bbox = vertcat(pastTruths.BoundingBox);
    colors = getColorByID(pastTruths);
    frame = insertShape(frame, 'filled-rectangle',bbox, 'Color',colors,'Opacity',0.2);
end

end

function colors = getColorByID(truths)

colors = zeros(numel(truths), 3);
coloroptions = 255*lines(7);
for i=1:numel(truths)
    colors(i,:) = coloroptions(mod(truths(i).TruthID, 7)+1,:);
end
end