% Stores the indices of the closest quaternions in training data (2nd argument)when
% compared to the testing data(1st argument)

% Evaluate errors only for the correct classifications
% Beware of euler angle range. Can be [-pi, pi] and also [-pi/2, pi2]! And
% different colums. 

for i = 1:6
   eval(['closest_quat_indices{i} = find_closest_quaternions(pred_face_' num2str(i) '_as_' num2str(i) '_init, face_' num2str(i)  '_init);'])
end

% Then, for now this is the predicted pose. 
% Naivest regression eva. 
for i = 1:6
   eval(['face_' num2str(i) '_final_predicted_without_vrep = face_' num2str(i) '_final(cell2mat(closest_quat_indices(i)), :);'])
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

% Because euler angles are so awesome, I had to hardcode different
% conventions, so that there is no ambiguity for each pair of opposite
% faces.

error_cell = [];
euler_predicted_cell = [];
euler_actual_cell = [];
for i = 1:6
%   Only calculate errors for those points which were correctly classified.
    if(i==1|i==2)
        eval(['euler_predicted = EulerAngles(quaternion(face_' num2str(i) '_final_predicted_without_vrep), ''zyx'');'])
        eval(['euler_actual = EulerAngles(quaternion(pred_face_' num2str(i) '_as_' num2str(i) '_final), ''zyx'');'])
    elseif(i==3|i==4)
        eval(['euler_predicted = EulerAngles(quaternion(face_' num2str(i) '_final_predicted_without_vrep), ''xyz'');'])
        eval(['euler_actual = EulerAngles(quaternion(pred_face_' num2str(i) '_as_' num2str(i) '_final), ''xyz'');'])
    elseif(i==5|i==6)
        eval(['euler_predicted = EulerAngles(quaternion(face_' num2str(i) '_final_predicted_without_vrep), ''xzx'');'])
        eval(['euler_actual = EulerAngles(quaternion(pred_face_' num2str(i) '_as_' num2str(i) '_final), ''xzx'');'])
    end
    
    euler_predicted = real(euler_predicted);% weird bug
    euler_predicted = permute(euler_predicted,[3 1 2]);
    euler_predicted = euler_predicted.*(180/pi);
    euler_actual = real(euler_actual);
    euler_actual = permute(euler_actual,[3 1 2]);
    euler_actual = euler_actual.*(180/pi);
   
    if(i==1|i==2)
        % zyx convention            
        % Pattern is [theta 0 0]         
        % 1st column. Range is (-pi,pi). Don't know interval closed on which side. 
        euler_predicted = euler_predicted(:,1)+180;
        euler_actual = euler_actual(:,1)+180;
        euler_error = abs(euler_predicted - euler_actual);
        % Now this error is in the range [0, 2*pi]
        
    elseif(i==3|i==4)
        % xyz convention 
        % Pattern is [90 0 theta]         
        euler_predicted = euler_predicted(:,3)+180;
        euler_actual = euler_actual(:,3)+180;
        euler_error = abs(euler_predicted - euler_actual);
    
    elseif(i==5|i==6)
        % xzx convention 
        % Pattern is [theta 90 90]          
        euler_predicted = euler_predicted(:,1)+180;
        euler_actual = euler_actual(:,1)+180;
        euler_error = abs(euler_predicted - euler_actual);
    end
    
    error_cell{i} = euler_error;
    euler_predicted_cell{i} = euler_predicted;
    euler_actual_cell{i} = euler_actual;
end

clearvars error euler_predicted euler_actual;

stats_actual = [];
stats_predicted = [];
stats_error = [];
% %%%CIRC_STATS%%%
for i = 1:6
% i = 1
    actual_circ = [];
    actual_circ = cell2mat(euler_actual_cell(i));
    actual_circ = circ_ang2rad(actual_circ);
    circ_eval = circ_stats(actual_circ);
    stats_actual(i).mean = circ_rad2ang(circ_eval.mean);
    stats_actual(i).median = circ_rad2ang(circ_eval.median);
    stats_actual(i).var = circ_rad2ang(circ_eval.var);
    stats_actual(i).std = circ_rad2ang(circ_eval.std);
    stats_actual(i).skewness = circ_rad2ang(circ_eval.skewness);
    stats_actual(i).kurtosis = circ_rad2ang(circ_eval.kurtosis); 
    stats_actual(i).res_vector_length = circ_r(actual_circ);

    figure;
    subplot(3,2,1);
    circ_plot(actual_circ,'pretty','bo',true,'linewidth',2,'color','r');
    subplot(3,2,2);
    circ_plot(actual_circ,'hist',[],20,true,true,'linewidth',2,'color','r');

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    predicted_circ = [];
    predicted_circ = cell2mat(euler_predicted_cell(i));
    predicted_circ = circ_ang2rad(predicted_circ);
    circ_eval = circ_stats(predicted_circ);
    stats_predicted(i).mean = circ_rad2ang(circ_eval.mean);
    stats_predicted(i).median = circ_rad2ang(circ_eval.median);
    stats_predicted(i).var = circ_rad2ang(circ_eval.var);
    stats_predicted(i).std = circ_rad2ang(circ_eval.std);
    stats_predicted(i).skewness = circ_rad2ang(circ_eval.skewness);
    stats_predicted(i).kurtosis = circ_rad2ang(circ_eval.kurtosis); 
    stats_predicted(i).res_vector_length = circ_r(predicted_circ);    
    subplot(3,2,3);
    circ_plot(predicted_circ,'pretty','bo',true,'linewidth',2,'color','r');
    subplot(3,2,4);
    circ_plot(predicted_circ,'hist',[],20,true,true,'linewidth',2,'color','r');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    error_circ = [];
    error_circ_findmax = [];
    error_circ = cell2mat(error_cell(i));
    error_circ_findmax = error_circ;

    for j = 1:length(error_circ_findmax)
        if error_circ_findmax(j) > 180
            error_circ_findmax(j) = 360-error_circ_findmax(j);
        end 
    end

    error_circ = circ_ang2rad(error_circ);
    circ_eval = circ_stats(error_circ);
    stats_error(i).mean = circ_rad2ang(circ_eval.mean);
    stats_error(i).median = circ_rad2ang(circ_eval.median);
    stats_error(i).var = circ_rad2ang(circ_eval.var);
    stats_error(i).std = circ_rad2ang(circ_eval.std);
    stats_error(i).max = max(error_circ_findmax)
    stats_error(i).min = min(error_circ_findmax)
    stats_error(i).skewness = circ_rad2ang(circ_eval.skewness);
    stats_error(i).kurtosis = circ_rad2ang(circ_eval.kurtosis); 
    stats_error(i).res_vector_length = circ_r(error_circ);
    [c,p] = circ_corrcc(actual_circ, predicted_circ);
    stats_error(i).correlation = c;
    stats_error(i).correlation_p_value = p;
    clearvars c p;

    subplot(3,2,5);
    circ_plot(error_circ,'pretty','bo',true,'linewidth',2,'color','r');
    subplot(3,2,6);
    circ_plot(error_circ,'hist',[],20,true,true,'linewidth',2,'color','r');
end
latex_regression_error_stats(stats_error);