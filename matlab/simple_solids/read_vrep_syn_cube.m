for i=1:6   
    eval(['quat_syn_vrep_cube_face_' num2str(i) '= importdata(''quat_' num2str(i) '.csv'');'])    
    eval(['euler_syn_vrep_cube_face_' num2str(i) '= importdata(''euler_' num2str(i) '.csv'');'])    
    %WARNING. rounding off -> unnormalized quaternions
    eval(['quat_syn_vrep_cube_face_' num2str(i) '= round(quat_syn_vrep_cube_face_' num2str(i) ',4);'])    
    eval(['euler_syn_vrep_cube_face_' num2str(i) '= round(euler_syn_vrep_cube_face_' num2str(i) ');'])    
    eval(['bing_syn_vrep_cube_face_' num2str(i) '= bingham_fit(quat_syn_vrep_cube_face_' num2str(i) ');'])
end

%TODO
%appending in loop is slow. Copies generated for each iteration. Do
%following in an optimized manner when free. 

quat_syn_vrep_cube_face_net = [quat_syn_vrep_cube_face_1;
    quat_syn_vrep_cube_face_2;
    quat_syn_vrep_cube_face_3;
    quat_syn_vrep_cube_face_4;
    quat_syn_vrep_cube_face_5,;
    quat_syn_vrep_cube_face_6];

quat_syn_vrep_cube_cluster = {quat_syn_vrep_cube_face_1,
    quat_syn_vrep_cube_face_2,
    quat_syn_vrep_cube_face_3,
    quat_syn_vrep_cube_face_4,
    quat_syn_vrep_cube_face_5,
    quat_syn_vrep_cube_face_6};

quat_syn_vrep_cube_cluster = {quat_syn_vrep_cube_face_1,
    quat_syn_vrep_cube_face_2,
    quat_syn_vrep_cube_face_3,
    quat_syn_vrep_cube_face_4,
    quat_syn_vrep_cube_face_5,
    quat_syn_vrep_cube_face_6};

bing_syn_vrep_cluster = [bing_syn_vrep_cube_face_1;
                     bing_syn_vrep_cube_face_2;
                     bing_syn_vrep_cube_face_3;
                     bing_syn_vrep_cube_face_4;
                     bing_syn_vrep_cube_face_5;
                     bing_syn_vrep_cube_face_6];
bing_syn_vrep_cluster = bing_syn_vrep_cluster';

csvwrite('/home/ratnesh/projects/riss/windows_riss_code/bingham/matlab/simple_solids/data/vrep_synthetic_cube/1/quat_all.csv', quat_syn_vrep_cube_face_net);