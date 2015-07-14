function plot_quaternions_cluster(quat_cluster, flag_plot_type)

% RGB Value
% [1 1 0] y yellow
% [1 0 1] m magenta
% [0 1 1] c cyan
% [1 0 0] r red
% [0 1 0] g green
% [0 0 1] b blue
% [0 0 0] k black
% flag_plot_type
% [1 1 1] w white DO NOT USE!

color_cell = {'k' 'm' 'c' 'r' 'g' 'b' 'y'};


% 
% for i = 1:size(bingham_cluster, 2)
%     subplot(ceil(size(bingham_cluster,2)/2), 2, i) 
%     eval(['plot_bingham_sample(bingham_cluster(' num2str(i) '), no_of_samples, flag_plot_type, color_cell{' num2str(i) '});'])
% end
% 
% decide colors first and then call plot_bingham_sample
% Randomize RGB matrix if number of samples > 7, else use the colors above

% if nargin > 2
if strcmp(flag_plot_type, 'robotics_toolbox')
    if size(bingham_cluster, 2) < 8;
        for i = 1:size(bingham_cluster, 2)
             i   
             subplot(ceil(size(bingham_cluster,2)/2), 2, i);
             eval(['plot_bingham_sample(bingham_cluster(' num2str(i) '), no_of_samples, flag_plot_type, color_cell{' num2str(i) '});'])
        end
    else
        for i = 1:size(bingham_cluster, 2)
            i
            subplot(ceil(size(bingham_cluster,2)/2), 2, i);
            eval(['plot_bingham_sample(bingham_cluster(' num2str(i) '), no_of_samples, flag_plot_type, rand(1,3));'])
        end
    end   
    
elseif strcmp(flag_plot_type, 'axis_angle')
    for i = 1:size(bingham_cluster, 2)
        i
        figure;
        eval(['plot_bingham_sample(bingham_cluster(' num2str(i) '), no_of_samples, flag_plot_type);'])
    end
    
elseif strcmp(flag_plot_type, 'animate')
    for i = 1:size(bingham_cluster, 2)
        i
        eval(['plot_bingham_sample(bingham_cluster(' num2str(i) '), no_of_samples, flag_plot_type);'])
    end

elseif strcmp(flag_plot_type, 'sphere')
     for i = 1:length(quat_cluster)
        i
        subplot(ceil(length(quat_cluster)/2), 2, i);
        eval(['plot_quaternions_sphere(cell2mat(quat_cluster(' num2str(i) ')));'])
     end
     
elseif strcmp(flag_plot_type, 'quat_orig')
     for i = 1:size(bingham_cluster, 2)
        i
        subplot(ceil(size(bingham_cluster,2)/2), 2, i);
        eval(['plot_bingham_sample(bingham_cluster(' num2str(i) '), no_of_samples, flag_plot_type);'])
     end

elseif strcmp(flag_plot_type, 'just_bingham')
    for i = 1:size(bingham_cluster, 2)
    i
    figure;
%     subplot(ceil(size(bingham_cluster,2)/2), 2, i);
    eval(['plot_bingham_sample(bingham_cluster(' num2str(i) '), no_of_samples, flag_plot_type);'])
    end

elseif strcmp(flag_plot_type, 'bingham_projections')
    for i = 1:size(bingham_cluster, 2)
    i
    figure;
%     subplot(ceil(size(bingham_cluster,2)/2), 2, i);
    eval(['plot_bingham_sample(bingham_cluster(' num2str(i) '), no_of_samples, flag_plot_type);'])
    end
    
elseif strcmp(flag_plot_type, 'rotations')
%     vector = rand(3,1);
    for i = 1:length(quat_cluster)
    i
    figure;
%     subplot(ceil(size(bingham_cluster,2)/2), 2, i);
    eval(['plot_quaternions_rotations(cell2mat(quat_cluster(' num2str(i) ''')));'])
    set(gcf,'units','normalized','outerposition',[0 0 0.5 0.333])
    end
    
elseif strcmp(flag_plot_type, 'rotations_rand')
    n=1;
    theta=pi*rand(1,n);
    phi=2*pi*rand(1,n);
    [x,y,z]=sph2cart(theta,phi,ones(1,n));
    v = [x, y, z]';
    
    for i = 1:length(quat_cluster)
    i
    subplot(ceil(length(quat_cluster)/2), 2, i);
    eval(['plot_quaternions_rotations_rand(cell2mat(quat_cluster(' num2str(i) ')), v);'])
    end
    
end
