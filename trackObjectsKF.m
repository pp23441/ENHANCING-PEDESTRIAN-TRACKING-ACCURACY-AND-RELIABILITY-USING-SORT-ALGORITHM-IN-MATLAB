function trackedDetections = trackObjectsKF(KF, detections)
    % Kalman Filter prediction and update
    % Predict
    for k = 1:numel(detections)
        if isempty(KF(k).x)
            KF(k).x = [detections(k).X, 0]'; % Initialize state vector with position and velocity
        end
        KF(k).x = KF(k).A * KF(k).x; % Predict state
        KF(k).P = KF(k).A * KF(k).P * KF(k).A' + KF(k).Q; % Predict error covariance
    end
    
    % Update
    for k = 1:numel(detections)
        z = detections(k).X; % Measurement
        KF(k).S = KF(k).H * KF(k).P * KF(k).H' + KF(k).R; % Innovation covariance
        KF(k).K = KF(k).P * KF(k).H' / KF(k).S; % Kalman gain
        KF(k).x = KF(k).x + KF(k).K * (z - KF(k).H * KF(k).x); % Update state estimate
        KF(k).P = (eye(size(KF(k).x, 1)) - KF(k).K * KF(k).H) * KF(k).P; % Update error covariance
    end
    
    % Tracked detections
    trackedDetections = detections;
    for k = 1:numel(detections)
        trackedDetections(k).X = KF(k).x(1); % Update tracked position
    end
end