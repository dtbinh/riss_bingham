% Note bmx file is written in this format:
% B <c> <i> <w> <d> <F> <dF> <Z> <V>

% TODO WARNING. Discrepency in naming scheme. face_i_init v/s face_init_i.
% Resolve to correct confusion
for i=1:6
    eval(['face_init_' num2str(i) '_sampled_from_fitted_BMM = importdata(''face_' num2str(i) '_init_quat_samples.csv'');'])
    eval(['face_final_' num2str(i) '_sampled_from_fitted_BMM = importdata(''face_' num2str(i) '_final_quat_samples.csv'');'])
end

for k=1:2
    for j=1:6
        BM_result = [];
       
        if (k==1)
            eval(['BM_current = importdata(''face_' num2str(j) '_init_BM.txt'');'])
        else
            eval(['BM_current = importdata(''face_' num2str(j) '_final_BM.txt'');'])
        end
        
        for i = 1:size(BM_current.data, 1)

            V = [BM_current.data(i,12) BM_current.data(i,16) BM_current.data(i,20);
                 BM_current.data(i,13) BM_current.data(i,17) BM_current.data(i,21);
                 BM_current.data(i,14) BM_current.data(i,18) BM_current.data(i,22);
                 BM_current.data(i,15) BM_current.data(i,19) BM_current.data(i,23);]

            Z = [BM_current.data(i,9) BM_current.data(i,10) BM_current.data(i,11)];

            F = BM_current.data(i,5)

            dF = [BM_current.data(i,6) BM_current.data(i,7) BM_current.data(i,8)];

            d = 4 % For this repo, d == 4 always,. Hardcoding d==4 accounts for possible errors in V/Z. 

            % TODO use computed F and dF. create_bingham(d,V) 
            % create_bingham(d,V,Z) computes F and dF. 
            % I am assuming that doesn't make much differnce, where "much" is subjective to (my) intuition
            % WARNING: this computes F and dF using bingham_F(B.Z)

            BM_current_eval = create_bingham(d,V,Z, F, dF);

            %append the Bingham to BMM
            %WARNING TODO appending in this way is not memory efficient. This is low priority for now though, considering the max size will be 10-15.
            BM_result = [BM_result; BM_current_eval]
        end

        %for using the visualization functions. 
        BM_result = BM_result';
        
        if (k==1)
            eval(['face_init_' num2str(j) '_fitted_BMM = BM_result;'])
        else
            eval(['face_final_' num2str(j) '_fitted_BMM = BM_result;'])
        end
        
    end
end