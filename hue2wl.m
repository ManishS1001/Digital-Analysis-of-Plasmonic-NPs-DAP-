function wl_PSF = hue2wl(Hue, N)

%FUNCTION: hue2wl Converts a given hue value to it's corresponding wavelength for the
%Canon 100D camera.
% 
%   v1.0 (21/06/16)
% 
%   hue2wl converts a given value ('Hue') to it's corresponding wavelength,
%   calculated using the Canon 100D and varying wavelengths of light. The
%   wavelength of light was stepped from 450 - 650 nm in 5 nm steps. The
%   hue value at each wavelength was then calculated using MATLAB. This
%   code interpolates the value of hue that is inputted to the known
%   values. The wavelength is then given.
% 
%   INPUT: 
% 
%   Hue - The value of hue required to be converted to wavelength. The hue 
%   value should be normalised to 1 (from 0-360).
% 
%   
%   N (OPTIONAL) - This is the number of hue values to be converted. If N = 1, then
%   you do not need to put in a value. N = 1 by default.
% 
%       EXAMPLE: a = hue2wl(0.5)
%                ans = 495.5156
% 
%   OUTPUT:
% 
%   wl_PSF - This is the calculated wavelength from a given
%   colour-wavelength calibration for the Canon 100D.
% 
%   NOTE: This code is calibrated for the CANON 100D only.
% 
%   M.S & P.R.N

if nargin < 2
    N = 1;
end

Hx_values1 = [450;455;460;465;470;475;480;485;490;495;500;505;510;515;520;525;530;535;540;545;550;555;560;565;570;575;580;585;590;595;600;605;610;615;620;625];
Hx_values2 = [630;635;640;645;650];
Hy_values1 = [0.78144;0.75736;0.71968;0.62748;0.5795;0.54853;0.53625;0.52476;0.51461;0.50129;0.48878;0.47494;0.46093;0.45028;0.44328;0.43549;0.42789;0.41894;0.40678;0.39039;0.35815;0.31502;0.28738;0.24915;0.20779;0.17394;0.14352;0.12153;0.11808;0.10668;0.089137;0.078143;0.068797;0.052639;0.02463;0.005692];
Hy_values2 = [0.99316;0.98048;0.96577;0.96096;0.96003];


for k = 1:N
    if Hue(k,1) < 0.71
        wl_PSF(k) = interp1(Hy_values1, Hx_values1, Hue(k));
    else
        if Hue(k,1) < 0.89
            wl_PSF(k) = 0;
        else
            wl_PSF(k) = interp1(Hy_values2, Hx_values2, Hue(k));
    end
end

wl_PSF = wl_PSF.';

end

