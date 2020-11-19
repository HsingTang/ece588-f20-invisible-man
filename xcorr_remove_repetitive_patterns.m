fullFileName = 'data/IM_10.png';
I = imread(fullFileName);
[rows columns numberOfColorBands] = size(I);
if numberOfColorBands > 1
	I = rgb2gray(I);
end
% Show image
subplot(2, 2, 1);
colormap gray;
imagesc(I, [0 255]);
% You have to select a part of single occurrence of the pattern (a template) on the image! See below image.
rect = round(getrect);
% In case it is a multiband image make grayscale image
if size(I,3)>1
    BW = rgb2gray(I);
else
    BW = I;
end
% Extract template from BW
template = BW(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3),:);
% Show template - this is the extent you selected during "getrect"
subplot(2, 2, 2);
imagesc(template);

% Calculate how much said template correlates on each pixel in the image
C = normxcorr2(template,BW);
% Remove padded borders from correlation
pad = floor(size(template)./2);
center = size(I);
C = C([false(1,pad(1)) true(1,center(1))], ...
        [false(1,pad(2)) true(1,center(2))]);
% Plot the correlation
subplot(2, 2, 3);
surf(C), shading flat

% Get all indexes where the correlation is high. Value read from previous figure.
% The lower the cut-off value, the more pixels will be altered
idx = C>0.1;
% Dilate the idx because else masked area is too small
idx = imdilate(idx,strel('disk',1));
% Replicate them if multiband image. Does nothing if only grayscale image
idx = repmat(idx,1,1,size(I,3));
% Replace pattern pixels with NaN
I(idx) = 0;
% Fill Nan values with 4x4 median filter
% I = fillmissing(I,'movmedian',[4 4]);
% Display new image
subplot(2, 2, 4);
imagesc(I);