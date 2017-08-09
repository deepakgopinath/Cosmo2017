clear; clc; close all;
num_points = 5;
dirnames = {'Left', 'Right'};
cellL = cell(96, 1);
cellR = cell(96, 1);


num_frames_stackL = zeros(96, 1);
num_frames_stackR = zeros(96, 1);
timestampsL = cell(96,1);
timestampsR = cell(96,1);
qpoints = (0:0.05:2*pi);
interpolated_points = zeros(length(qpoints), num_points, 3);
indices = [9,11,12,14,15];
% indices = 1:1:15;
for i=1:length(dirnames) %over L and R
    fnames = dir(dirnames{1});
    for j=3:size(fnames, 1) %num of subjects %number of subjects in L or R
%       for j=36:36
        filename = fnames(j).name;
        fileID = fopen(filename,'r');
        delimiterIn = ',';
        headerlinesIn = 0;
        A = importdata(filename,delimiterIn,headerlinesIn);
        t_in_ms = A.data; %time vector for each subject
        if i==1
            num_frames_stackL(j-2) = length(t_in_ms);
            timestampsL{j-2} = t_in_ms;
        else
            num_frames_stackR(j-2) = length(t_in_ms);
            timestampsR{j-2} = t_in_ms;
        end
        
        point_dim_time = zeros(num_points, 3, length(t_in_ms)); 
        for m=1:size(A.textdata, 1) %num of time frames
            temp = A.textdata(m,:);
            s = '';
            for n = 1:size(temp, 2) %each row of the file as a string
                s = strcat(s, temp{n}, ',');
            end
            s(end) = [];
%             disp(s);
            r = '\[[-\d.,]*\]';
            matchStr = regexp(s, r, 'match');
            %maybe have it as time * num_points * dimension
            for p = 1:length(indices) %num of points (always 15)
                 ind = indices(p);
                 point_dim_time(p, :, m) = str2num(matchStr{ind});
            end
%             disp(frames_time(:,:,1));
        end
        
        time_point_dim = permute(point_dim_time, [3,1,2]);
%         time_point_dim = time_point_dim(:,:,[1,3,2]);
        
        %perform interpolation
        phasor_points = 0:(2*pi)/length(t_in_ms):2*pi-(2*pi)/length(t_in_ms)';
        for m=1:3 %for each dimension, all points
            V = time_point_dim(:,:,m);
            samplePoints = {phasor_points, 1:size(V,2)};
            F = griddedInterpolant(samplePoints,V);
            queryPoints = {(0:0.05:2*pi),1:size(V,2)}; %repmat the query phasor points for points
            Vq = F(queryPoints);
            interpolated_points(:,:,m) = Vq;
        end
        
        %normalization and unit std
        means = permute(mean(mean(interpolated_points, 1), 2), [2,3,1]);
        stds = permute(std(std(interpolated_points, 1)), [2,3,1]);
        diff_means = zeros(126, num_points, 3);
        diff_std = zeros(126, num_points, 3);
        for m=1:3
            diff_means(:,:,m) = repmat(means(m), 126, num_points);
            diff_std = repmat(stds(m), 126, num_points);
        end
        interpolated_points = (interpolated_points - diff_means)./diff_std;
        
        %for each one of the third dimension, perform interpolation along
        %first dimension (time) for each of the 5 points (second dimension(
        
        %make interpolation to make the stimulus length to be the same. 
        if i==1
%             cellL{j-2} = point_dim_time;
            cellL{j-2} = interpolated_points;
        else
%             cellR{j-2} = point_dim_time;
            cellR{j-2} = interpolated_points;
        end
    end
    
end



%for every category
% for i=1:size(cellL, 1) %over people
%     traj = cellL{i};
%     temp_cov = compute_cov(traj);
% end
% e
%For each category (L or R) for each walker (over files in a directory),
%bin time as 0.25, 0.5, 0.75, 1 of total time. compute covariance for each
%portion. There would be 4 covariances each of which is 15 by 15. Where 15
%re[presents the x,y,z coordinates of 5 points were are interested. 


