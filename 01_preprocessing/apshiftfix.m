% apshiftfix.m: Function to fix slice shift in s-fMRI
% Need to think about ghosting later
% Requires Matlab Image Processing Toolbox
%
% [V shifts] = apshiftfix(fnamein, fnameout, showplots, ctrslice, slabwidth, ...
%                            ignoreshift, fixslices, ignoreslices)
%
% Inputs:
%   fnamein -       Name of input NIFTI file
%   fnameout -      Name of output NIFTI file (optional)
%   showplots -     Display plots of images and profiles and shifts (bitmask) (optional)
%                       0 - Don't display plots - default
%                       1 - Display sagittal plot
%                       2 - Display slice profiles - very slow, not recommended
%                       4 - Print shifts to terminal
%                           eg, 7 displays all
%   ctrslice -      Index of centre slice (starts at 1, not 0)  (optional)
%   slabwidth -     Width of slab to average
%   ignoreshift -   Magnitude of shifts to ignore - default = 0  (optional)
%   fixslices -     Array of slices to fix - default all  (optional)
%                       Slices starts at 1, not 0 as in fslview
%                       Add 1 to slice number shown in fslview
%   ignoreslices -  if 1, uses fixslices as array of slices to ignore  (optional)
%                           default = 0
%
% All inputs except the first are optional and have defaults - see the code
% To set an empty argument, use []. For example, to set the centre slice
% but leave the output file name and showplots to their default settings:
%
% [V shifts] = apshiftfix('NameIn', [], [], 62);
%
% Outputs:
%   V -         4D "fixed" s-fMRI time series
%   shifts -    Array containing the shifts for each slice/volume

function [V shifts] = apshiftfix(fnamein, fnameout, showplots, ctrslice, slabwidth, ...
                                    ignoreshift, fixslices, ignoreslices)

% Strip the NIFTI extensions
AUTO = -1;   % For options

transpose_shifts = false;   % Transpose the shifts vs vol/slice array
flip_shifts = false;        % Flip the slice order of the vol/slice array


fnamein = stripniiext(fnamein);

% Get the options
if nargin > 1
    if isempty(fnameout)
        fnameout = [fnamein '_shifted'];
    else
        fnameout = stripniiext(fnameout);
    end
else
    fnameout = [fnamein '_shifted'];
end
fnameshifts = [fnameout '_shifts.txt'];
if nargin > 2
    if isempty(showplots) || showplots < 0 || showplots > 7
        showplots = 0;
    end
else
    showplots = 0;
end
if nargin > 3
    if isempty(ctrslice)
        ctrslice = AUTO;
    end
else
    ctrslice = AUTO;
end
if nargin > 4
    if isempty(slabwidth)
        slabwidth = 11;
    end
else
    slabwidth = 11;
end
if nargin > 5
    if isempty(ignoreshift)
        ignoreshift = 0;
    end
else
    ignoreshift = 0;
end
if nargin > 6
    if isempty(fixslices)
        fixslices = AUTO;
    end
else
    fixslices = AUTO;
end
if nargin > 7
    if isempty(ignoreslices)
        ignoreslices = 0;
    elseif ignoreslices ~= 0
        ignoreslices = 1;
    end
else
    ignoreslices = 0;
end

showsags = 0;
showprofiles = 0;
dispshifts = 0;
if bitget(showplots, 1)
    showsags = 1;
end
if bitget(showplots, 2)
    showprofiles = 1;
end
if bitget(showplots, 3)
    dispshifts = 1;
end

% Read the s-fMRI image
plotfrac = 0.8;    % Used to set the maximum value to be displayed

ninfo = niftiinfo(fnamein);
ydim = ninfo.ImageSize(1);
if ctrslice == AUTO
    ctrslice = round(ydim/2);
end
slabhalfwidth = floor(slabwidth/2);
if slabhalfwidth < 1
    slabhalfwidth = 1;
elseif slabhalfwidth > ydim
    slabhalfwidth = round(ydim/2)-1;
end

yposmin = ctrslice - slabhalfwidth;
yposmax = ctrslice + slabhalfwidth;

V = niftiread(ninfo);

% Create profiles by summing the signal along the L-R direction
profiles = squeeze(sum(V(yposmin:yposmax,:,:,:), 1));
profiles = permute(profiles, [2 1 3]);
% profiles = squeeze(max(V, [], 1));
dispmin = 0;
dispmax = plotfrac * max(profiles(:));

nslices = size(profiles, 1);
ydim = size(profiles, 2);
nvols = size(profiles, 3);

if showsags
    figure;
    % Plot the proffile for volume 1 of slice 1
    imshow(flip(profiles(:,:,1),1), [dispmin dispmax]);
    drawnow();
end

if showprofiles
    figure;
end

% Set to ignore, only make sense when fixslices is not AUTO
if ignoreslices == 1
    arr = [];    % Create an empty array
    for slice = 1:nslices
        if ~ismember(slice, fixslices)
            arr = [arr slice];
        end
    end
    fixslices = arr;
end

if fixslices == AUTO
    fixslices = 1:nslices;
end

shifts = zeros(nvols, nslices);

for slice = 1:nslices
    % Get the slice profile for the 1st vol
    baseprofile = squeeze(profiles(slice, :, 1));
    for vol = 2:nvols
        volprofile = squeeze(profiles(slice, :, vol));
        % figure;
        if showprofiles
            plot(baseprofile);
            hold on;
            plot(volprofile);
            hold off;
            lbl = ['Slice ' num2str(slice) ' vol ' num2str(vol)];
            title(lbl);
            pause(0.02);
        end
        
        % Calculate the cross correlation
        if ismember(slice, fixslices)
            cc = ifft(fft(baseprofile).*conj(fft(volprofile)));
            [~, apshift] = max(cc);   % Get the index of the shift which starts and 1 ...
            apshift = apshift - 1;    % ... but the shift starts at 0, so subtract 1
            if apshift > round(ydim/2)
                apshift = apshift - ydim;
            end
            if abs(apshift) <= ignoreshift
                apshift = 0;
            end
        else
            apshift = 0;
        end
        if dispshifts
            msg = ['Slice ' num2str(slice) ' vol ' num2str(vol) ...
                ' shift = ' num2str(apshift)];
            disp(msg);
        end
        shifts(vol, slice) = apshift;
        % apply the shift
        if apshift ~= 0
            V(:,:,slice,vol) = circshift(V(:,:,slice,vol), apshift, 2);
        end
    end
end

niftiwrite(V, fnameout, ninfo, 'Compressed', true);

if flip_shifts == true
    flip(shifts,2);
end
if transpose_shifts == true
    shifts = shifts';
end

dlmwrite(fnameshifts, shifts);


end

function nameout = stripniiext(namein)
% Strip leading .nii.gz from input filename
[~,name,ext] = fileparts(namein);
if strcmp(ext, '.gz')
    namein = name;
end
[~,name,ext] = fileparts(namein);
if strcmp(ext, '.nii')
    namein = name;
end
nameout = namein;
end
