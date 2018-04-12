 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Dark-Field microscopy image processing
%Authors: Manish Sriram and Philip R. Nicovich
%12/04/2018
%pAnalysis v3.1S
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%This script will run you through locating nanoparticles from a dark-field
%microscope image and allow you to analyse their colour. Hue2wl can be used
%to convert the hue to wavelength, currently calibrated to the Canon 100D.
%
%
%

%Clear workpace of variables.
clear all;
clc;


%% PROCESSING OF IMAGE:

% Image is read in and cropped to obtain centre area. This removes area due to
% vignetting from image capture. Image split converted to HSV colour
% space.
before = imread('IMG_0006.CR2');
crop_dim = [1650 850 2000 2000]; %This is the cropping coordinates for the image. Adjust this to suit needs. 

I_cropped =  imcrop(before,crop_dim); %Crop image.
Im_HSV = rgb2hsv(I_cropped); %Convert image to HSV colour space.
H = Im_HSV(:,:,1); %Separate hue channel.
V = Im_HSV(:,:,3); %Separate intensity channel.

%Image is filtered and particles localised.
%The bpass code was produced by John C. Crocker and David G. Grier.
V_filtered = bpass(V, 0,15); %Bandpass filtering to remove noise.
pk = pkfnd(V_filtered,0.05,10); %Locate particles based on pixel intensity.
centers = pk(:,1:2);

%Image is masked with kernel to obtain intensity-weighted colour information from each paricle.

maskImg = false(size(V_filtered, 1), size(V_filtered,2));

for k = 1 : size(centers, 1);
    maskImg(centers(k,2), centers(k,1)) = 1;
end

kernelRad = 3; %Number of pixels around each peak to use for averaging.
kern = strel('disk', kernelRad); 
maskImg = imdilate(maskImg, kern);
regs = regionprops(maskImg, 'PixelIdxList', 'PixelList');
avgHue = zeros(numel(regs), 1);
avgInt = zeros(numel(regs),1);
number = numel(regs);

% Colour information is obtained from each particle.

for k = 1 : number
    kernHue = H(regs(k).PixelIdxList);
    kernInt = V(regs(k).PixelIdxList);
    kernInt = kernInt - min(kernInt(:));
    avgHue(k) = sum(kernHue(:).*kernInt(:))./sum(kernInt(:));
    avgInt(k) = mean(kernInt(:));
    %avgHue(k) = sum(kernHue(:).*kernInt(:))./sum(kernInt(:));
    %%Intensity-based weighting.
end

wl_PSF = hue2wl(avgHue,numel(regs)); %Converting hue of each particle to wavelength.
mean_wl = mean(wl_PSF); %Calculating mean wavelength.

if numel(wl_PSF(:,1)) ~= numel(avgHue(:,1))
     wl_PSF=wl_PSF';
end

%% DISPLAY FIGURE: Displaying figure with nanoparticle marked.

figure();
imshow(I_cropped);
hold on
scatter(centers(:,1),centers(:,2),'MarkerEdgeColor','r');
hold off

%% HISTOGRAM: Setting up histogram of Hue values.

histRange = linspace(0, 1, 180);
aHhist_b = histc(avgHue, histRange);
aHhist_b = aHhist_b/sum(aHhist_b(:));

aHhist_a = histc(avgHue_after, histRange);
aHhist_a = aHhist_a/sum(aHhist_a(:));
 
Mean_H = mean(avgHue);
Std_H = std(avgHue);
aNum = length(avgHue(:));



