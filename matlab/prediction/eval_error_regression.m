% Stores the indices of the closest quaternions in training data (2nd argument)when
% compared to the testing data(1st argument)
for i = 1:6
   eval(['closest_quat_indices{i} = find_closest_quaternions(face_' num2str(i) '_init_predicted, face_' num2str(i)  '_init);'])
end

% Then, for now this is the predicted pose. 
% Naivest regression eva. 
for i = 1:6
   eval(['face_' num2str(i) '_final_predicted_without_vrep = face_' num2str(i) '(cell2mat(closest_quat_indices(i)), :);'])
end

% Now find difference between euler angles of what actually happened in the
% simulator - face_n_final_predicted v/s what we did just now -
% face_n_final_predicted_without_vrep

% Another measure could be angle axis 
% On using eval with EulerAngles, somehow I get complex numbers.
% bug 

% In all rotation operations, the rotations operate from left to right on
% 3x1 column vectors and create rotated vectors, not representations of
% those vectors in rotated coordinate systems.
% For Euler angles, '123' means rotate the vector about x first, about y
% second, about z third, i.e.:
% vp = rotate(z,angle(3)) * rotate(y,angle(2)) * rotate(x,angle(1)) * v
error_cell = []
for i = 1:6
    eval(['predicted_euler = EulerAngles(quaternion(face_' num2str(i) '_final_predicted_without_vrep), ''zyx'');'])
    predicted_euler = real(predicted_euler);
    predicted_euler = permute(predicted_euler,[3 1 2]);
    predicted_euler = predicted_euler.*(180/pi);

    eval(['actual_euler = EulerAngles(quaternion(face_' num2str(i) '_final_predicted), ''zyx'');'])
    actual_euler = real(actual_euler);
    actual_euler = permute(actual_euler,[3 1 2]);
    actual_euler = actual_euler.*(180/pi);
   
    if (i==1|i==2)
        error = abs(predicted_euler(:,1) - actual_euler(:,1));
        % Now this error is in the range [0, 2*pi]
    end
    
     if (i==3|i==4|i==5|i==6)
        error = abs(predicted_euler(:,2) - actual_euler(:,2));
        % Now this error is in the range [0, 2*pi]
    end
    
    for j = 1:length(error)
        if error(j) > 180
            error(j) = error(j)-180;
        end
    end
    error_cell{i} = error;
end

[error_std error_mean error_mode error_median error_max error_min] = deal(zeros(6,1));
for i = 1:6
    error_std(i,1) = std(cell2mat(error_cell(i)));
    error_mean(i,1) = mean(cell2mat(error_cell(i)));
    error_mode(i,1) = mode(cell2mat(error_cell(i)));
    error_median(i,1) = median(cell2mat(error_cell(i)));
    error_max(i,1) = max(cell2mat(error_cell(i)));
    error_min(i,1) = min(cell2mat(error_cell(i)));

%     stem(cell2mat(error_cell(i)));
    count = 1:1:size(cell2mat(error_cell(i)), 1);
    plot_error(count, cell2mat(error_cell(i)));
end
error_stats = [error_mean error_mode error_median error_std error_max error_min];
latex_regression_error_stats(error_stats);

clearvars error predicted_euler actual_euler;