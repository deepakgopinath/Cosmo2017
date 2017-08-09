clear; clc; close all;

load('cellLR_LM_Perturbed_15.mat');
trials = 100;
exp_to_json(cellL_LM, cellR_LM, trials, 'trials_json_perturbed.json');
% data_string = '{"trials":['; 
% for i=1:trials
%     data_string = strcat(data_string, '{"positions":');
%     data_text = jsonencode(cellL{i});
%     data_string = strcat(data_string, data_text);
%     data_string = strcat(data_string, ',"direction": "LEFT"},');
% end
% 
% for i=1:trials
%     data_string = strcat(data_string, '{"positions":');
%     data_text = jsonencode(cellR{i});
%     data_string = strcat(data_string, data_text);
%     data_string = strcat(data_string, ',"direction": "RIGHT"},');
% end
% 
% data_string(end) = [];
% data_string = strcat(data_string, ']}');
% 
% filename = 'trials_full_json.json';
% fid = fopen(filename, 'w');
% fprintf(fid, '%s\r\n', data_string);
% fclose(fid);

% trials = 96;
% for i=1:trials
%     traj = cellR{i};
%     text = jsonencode(traj);
%     filename = strcat('tR_', num2str(i), '.json');
%     fid = fopen(filename, 'w');
%     fprintf(fid, '%s\r\n', text);
%     fclose(fid);
% end




