function mdDisplay(azimuth,speed,fps, varargin)
%   mdDisplay()  Plots motion data for an arbitary number of motion data
%   sets.
%   Complementary colours are used to display consecutive pairs of motion
%   data sets.
%
%   azimuth (real):  rotational point of view.
%   speed (real):  display speed multiple (use 1 for normal speed)
%   varargin (md):  one or more motion data (md) sets or motion move
%       structures, which are normally part of a session structure.
%
%   Example:  mdDisplay(0,1,session1.move{1}.mdData,session2.move{1});
%
%   Copyright 2012 BioMotionLab
%   Version: 1.4 (DOWNLOAD)

% Check function arguments.

% NT, Nov 10, 2016: I switched the function to use animatedlines rather
%                   than the old erase mode.


if nargin < 3
    error('Too few arguments.');
end

global go;
go = 1;
% fps = 120;
% Dot colours
clr{1} = [0.0 0.0 0.0];   % black
clr{2} = [1.0 0.0 0.0];   % red
clr{3} = [0.0 1.0 0.0];   % green
clr{4} = [0.0 0.0 1.0];   % blue
clr{5} = [1.0 0.5 0.0];   % orange
clr{6} = [1.0 1.0 0.0];   % yellow
clr{7} = [0.5 0.0 1.0];   % purple

for d = 1:numel(varargin)
    var_data_in = varargin{d};
    if(~isstruct(var_data_in))
        md = var_data_in;
    else
        if isfield(var_data_in,'mdData')
            md = var_data_in.mdData;
        else
            error('Structure does not contain mdData.');
        end
    end
    
    if numel(size(md)) == 3
        clear data;
        data = md;
        mdi{d} = data;
        
        % Map complementary colours to pairs of moves.
        c = mod(d,numel(clr));
        if c == 0
            c = numel(clr);
        end
        mdiclr{d} = clr{c};
    else
        error(['Motion data has wrong number of coordinates: ' ...
            int2str(d)]);
    end
end

azimuth = azimuth + 90;   % Rotate walker

figgy = figure;
axis equal;
% ax = [-600 600 -850 850 0 2100];
% axis(ax);
view([azimuth,0]);

% Set current figure (cf) properties.
% set(figgy,'Position',[64,64,512,512]);
set(figgy,'doublebuffer','on','color','white');
cameratoolbar(figgy);
hold on;

% Make stop button
button=uicontrol('Style','pushbutton');
button.FontSize = 14;
button.String = 'Stop';
button.Units = 'normalized';
button.Position = [0 0 0.2 0.06];
button.Callback = ['go=0;'];
hold on;

% Initialize animation
for d = 1:numel(varargin)
    h{d} = animatedline('LineStyle','none', 'Marker', '.','MarkerSize',15,'Color',clr{d});
end
drawnow;

maxlength = 0;
for d = 1:numel(mdi)
    maxlength = max(maxlength,size(mdi{d},1));
end

t = 0;
lastt = cputime();

%for f = 1:maxlength
while(t<(maxlength/fps)) & go
    curtime = cputime;
    dt = curtime - lastt;
    lastt = curtime;
    t = t + dt * speed;
    f = round(t*fps)+1;
    
    for d = 1:numel(mdi)
        clear data;
        data = mdi{d};
        clearpoints(h{d})
        if f<=size(data,1)
            addpoints(h{d},data(f,:,1),data(f,:,2),data(f,:,3));
%             addpoints(h{d},data(f,10:30,1),data(f,10:30,2),data(f,10:30,3));
        end
    end
    drawnow;
end

clear global figgy;
close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
