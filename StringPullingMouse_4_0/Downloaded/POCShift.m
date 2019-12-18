function shift = POCShift(fixed, moving, varargin)
%POCSHIFT Estimates the translation between two noisy images by phase-only correlation.
%   Phase-only correlation (POC) should be used to correct a pure translation shift between two images. 
%   'fixed' and 'moving' must be of consistent size.
%   Usage: 
%            shift=POCShift(fixed, moving); % for a max cut-off of 60%
%            shift=POCShift(fixed, moving, C); % with 0<C<1 for a max cut-off of 100*C%
%            shift=POCShift(fixed, moving, 0); % to disable filtering
%   The algorithm works as follows:
%       
%     1. The FFT of both images are calculated as well as the normalized
%        cross spectrum R.
%     2. The inverse Fourier transform r of a low-pass filtered R is computed
%        with a cut-off frequency varying from 5% to 'cutoff' (default is
%        60%). Use cutoff=0 to disable filtering.
%     3. The translation is computed from the position of the peak in r
%   
%   See: Takita et al. 'High-accuracy subpixel image registration based on phase-only correlation', 
%        IEICE transactions on fundamentals of electronics, communications and computer sciences 86(8), 1925-1934, 2003.
%% Parsing arguments:
   p = inputParser;
   
   addRequired(p,'fixed', @(x) validateattributes(x, {'numeric'}, {'2d'}));
   addRequired(p,'moving', @(x) validateattributes(x, {'numeric'}, {'2d'}));
   
   defaultCutoff = 0.6;
   addOptional(p,'cutoff', defaultCutoff, @(x) validateattributes(x, {'numeric'}, {'scalar', 'nonnegative', 'nonnan', '<=', 1}));
   parse(p, fixed, moving, varargin{:});
    
   cutoff=p.Results.cutoff;
   [n,m]=size(fixed);
%% Machine
% 1. Calculate the FFT of both images and the normalized cross-spectrum
F=fftshift(fft2(im2double(fixed)));
M=fftshift(fft2(im2double(moving)));
R=(F.*conj(M))./abs((F.*conj(M)));
% 2. Swept cut-off filtering of the cross-spectrum and inverse FFT:
% 2.1 Initialisation:
   
  N = min(n,m);
  r = ones(n,m);
  
  if cutoff == 0;
      
      r = fftshift(abs(ifft2(R)));
      
  else
  
      for k = 0.1:0.05:cutoff
          % 2.2 Masking:
    
          D=k*N/2;
          Mask = fspecial('disk',D)~=0;
          Mask = imresize(padarray(Mask, [floor((n/2)-D) floor((m/2)-D)], 0, 'both'), [n m]);
          % 2.3 Calculate the most frequent phase shift:
      
          R(Mask==0)=0;
          r = r.*fftshift(abs(ifft2(R)));
      
      end
  end
  
% 3. Estimate the translation:
rmax = max(max(r));
[x , y] = find(r == rmax);
x=ceil(n/2)-x; y=ceil(m/2)-y;
shift=[x, y];
end
