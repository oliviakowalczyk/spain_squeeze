function [physdata] = phys_merge(physfile, trigfile, mergedfile, secs2disp, sigfigs)
%phystrigs Adds "faked" triggers to physiology file
%   Outputs
%       physdata: Input physiology data with an additional column 
%       containing the "fake" scanner triggers.
%       The scanner triggers column is mostly zeros, but with ones where
%       the volume triggers are expected to be.
%
%   Inputs
%       physfile:   name of the file containing the physiology data
%       trigfile:   name of the file containing the trigger times
%       mergedfile: name of the output merged file (optional)
%       secs2disp:  (optional) Number of seconds of the diplay to plot
%                   -9999: special case - displays the whole plot
%                   +ve: 1st secs2disp seconds of the plot
%                   -ve: Last secs2disp seconds of the plot
%       sigfigs:    Significant places after decimal in times - default = 9

if nargin < 2 || nargin > 5
    nameFunc = mfilename;
    help(nameFunc);
    error('phystrigs must have 2-4 paramters');
end

if nargin < 5
    sigfigs = 9;
    if nargin < 4
        secs2disp = 0;
        if nargin < 3
            mergedfile = '';
        end
    end
end


if isempty(mergedfile)
    [~, mergedfile, ext] = fileparts(physfile);
    mergedfile = [mergedfile '_merged.txt'];
end

if isempty(secs2disp)
    secs2disp = 0;
end

% Open the physiology file
file_in = -1;
errmsg = 'Failed to open physiology file';
[file_in,errmsg] = fopen(physfile);

if file_in < 0
    error(errmsg);
end

% Skip over the comments
for i=1:6
    tline = fgetl(file_in);
    fprintf('%s\n', tline);
end

% Read the physiology file
tline = fgets(file_in);
if tline == -1
    error('No data in physio file');
end

i = 1;

vec = sscanf(tline, "%f %f %f");
physdata = [vec' 0];

while ~feof(file_in)
    i=i+1;
    tline = fgets(file_in);
    vec = sscanf(tline, "%f %f %f");
    physdata(i,:) = [vec' 0];
end

nphys = i;

fclose(file_in);

file_in = -1;
errmsg = 'Failed to open trigger times file';
[file_in,errmsg] = fopen(trigfile);

if file_in < 0
    error(errmsg);
end

% Read the physiology file
tline = fgets(file_in);
if tline == -1
    error('No data in trigger times file');
end

i = 1;

vec = sscanf(tline, "%fs %f");
trigdata = [vec'];

while ~feof(file_in)
    i=i+1;
    tline = fgets(file_in);
    vec = sscanf(tline, "%fs %f");
    trigdata(i,:) = [vec'];
end

ntrigs = i;

fclose(file_in);

if sigfigs < 9
    trigdata(:,1) = round(trigdata(:,1), sigfigs);
end

for i=1:ntrigs
    phystimes = physdata(:,1) - trigdata(i, 1);
    [~, idx] = min(phystimes.*phystimes);
    physdata(idx, 4) = 1;
end


% writematrix(physdata, name, 'space');   before 2019a
file_out = -1;
errmsg = 'Could not write merged physiology file';
[file_out,errmsg] = fopen(mergedfile, 'w');

if file_out < 0
    error(errmsg);
end

fprintf(file_out, '%f %i %i %i\n', physdata');

fclose(file_out);

if secs2disp ~= 0
    figure('Name', 'Physiology Data', ...
        'Units', 'normalized', ...
        'Position', [0.05 0.15 0.9 0.7], ...
        'IntegerHandle', 'off');
        
    rate = 1/mean(physdata(2:end,1)-physdata(1:end-1,1));
    if secs2disp > 0
        pts_s = 1;
        pts_e = secs2disp * rate;
        pts_e = round(pts_e);
        if pts_e > nphys
            pts_e = nphys;
        end
    elseif secs2disp == -9999
        pts_s = 1;
        pts_e = nphys;
    else
        % sec2disp needs to be positive. Do this next rather than adding
        % on the following line to make it clearer.
        secs2disp = -secs2disp;
        pts_s = nphys - secs2disp * rate;
        pts_s = round(pts_s);
        if pts_s < 1
            pts_s = 1;
        end
        pts_e = nphys;
    end
        
    subplot(3,1,1);
    plot(physdata(pts_s:pts_e,1), physdata(pts_s:pts_e,4));
    title('Scanner Volume "Triggers"');
    subplot(3,1,2);
    plot(physdata(pts_s:pts_e,1), physdata(pts_s:pts_e,2));
    title('Respiratory Recording');
    subplot(3,1,3);
    plot(physdata(pts_s:pts_e,1), physdata(pts_s:pts_e,3));
    title('Pulse Oximeter Trace');
end


end

