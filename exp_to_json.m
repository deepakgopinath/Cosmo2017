function [  ] = exp_to_json( cellL, cellR, trials, filename )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
data_string = '{"trials":['; 
for i=1:trials
    data_string = strcat(data_string, '{"positions":');
    data_text = jsonencode(cellL{i});
    data_string = strcat(data_string, data_text);
    data_string = strcat(data_string, ',"direction": "LEFT"},');
end

for i=1:trials
    data_string = strcat(data_string, '{"positions":');
    data_text = jsonencode(cellR{i});
    data_string = strcat(data_string, data_text);
    data_string = strcat(data_string, ',"direction": "RIGHT"},');
end

data_string(end) = [];
data_string = strcat(data_string, ']}');
fid = fopen(filename, 'w');
fprintf(fid, '%s\r\n', data_string);
fclose(fid);

end

