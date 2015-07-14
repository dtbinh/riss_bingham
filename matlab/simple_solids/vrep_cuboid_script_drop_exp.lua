-- DO NOT WRITE CODE OUTSIDE OF THE if-then-end SECTIONS BELOW!! (unless the code is a function definition)

if (sim_call_type==sim_childscriptcall_initialization) then
    handle=simGetObjectHandle('Cuboid')
    init_pose=io.open("/home/ratnesh/projects/riss/windows_riss_code/bingham/matlab/simple_solids/data/vrep_cube_0.35/1/init_pose.csv", "w");
    final_pose=io.open("/home/ratnesh/projects/riss/windows_riss_code/bingham/matlab/simple_solids/data/vrep_cube_0.35/1/final_pose.csv", "w");
    init_pose_euler=io.open("/home/ratnesh/projects/riss/windows_riss_code/bingham/matlab/simple_solids/data/vrep_cube_0.35/1/init_pose_euler.csv", "w");
    final_pose_euler=io.open("/home/ratnesh/projects/riss/windows_riss_code/bingham/matlab/simple_solids/data/vrep_cube_0.35/1/final_pose_euler.csv", "w");

    count=0;
    -- debug=0;
    no_of_trials = 6000;
    threshold = 100*(no_of_trials+1);
    threshold_final_pose = 100*no_of_trials;
    r2a = 180/math.pi;
end


if (sim_call_type==sim_childscriptcall_actuation) then
    if count < threshold then 
        local position=simGetObjectPosition(handle,-1)
        local quaternion=simGetObjectQuaternion(handle,-1)
        local orientation=simGetObjectOrientation(handle, -1)

        if (count%100==0) then
            
            if count ~= 0 then 
                -- no final pose written at the beginning of the simulation 
                final_pose:write(count/100,",", position[1], ",", position[2], ",", position[3], ",", quaternion[1], ","
                    , quaternion[2], ",", quaternion[3], ",", quaternion[4], "\n")
                final_pose_euler:write(position[1], ",", position[2], ",", position[3], ",", r2a*orientation[1], ","
                    , r2a*orientation[2], ",", r2a*orientation[3], "\n")
            end

            position[1] =  math.random(); 
            position[2] =  math.random();
            position[3] =  2.5+math.random();

            --because setting random orientation via euler angles is easier than setting it via random quaternions
            orientation[1] =  math.random(-180,180)*math.pi/180.0;
            orientation[2] =  math.random(-180,180)*math.pi/180.0;
            orientation[3] =  math.random(-180,180)*math.pi/180.0;

            simSetObjectPosition(handle,-1,position);
            simSetObjectOrientation(handle,-1,orientation)
            quat_test = simGetObjectQuaternion(handle, -1)
            -- euler_test = simGetObjectOrientation(handle, -1)

            --last value is garbage
            if count < threshold_final_pose then
                init_pose:write(count/100, ",",position[1], ",", position[2], ",", position[3], ",", quat_test[1], ","
                    , quat_test[2], ",", quat_test[3], ",", quat_test[4], "\n")
                init_pose_euler:write(position[1], ",", position[2], ",", position[3], ",", r2a*orientation[1], ","
                    , r2a*orientation[2], ",", r2a*orientation[3], "\n")
            end
         
        end

        count = count+1;
    end
end


if (sim_call_type==sim_childscriptcall_sensing) then

-- Put your main SENSING code here

end


if (sim_call_type==sim_childscriptcall_cleanup) then
    erlFile:close()

-- Put some restoration code here

end