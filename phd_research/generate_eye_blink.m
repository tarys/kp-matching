%GENERATE_EYE_BLINK modeling eye blink time courses using random noise band-pass filtered (FIR) between 1 and 3 Hz
%   Input arguments:
%       • samplingRateHz - Hz, Sampling Rate (Frequency)
%       • length - resulting array length
%       • originalSignalMax - maximum of original signal to scale eye blink
%       properly
function [ eye_blink ] = generate_eye_blink( samplingRateHz,  length, originalSignalMax)

%% design FIR filter to filter noise to half of Nyquist rate
filterOrder = 64;               % Order
lowerCutoffFrequencyHz = 1;     % Hz, First Cutoff Frequency
higherCutoffFrequencyHz = 3;    % Hz, Second Cutoff Frequency

bandpass_filter = fir1(filterOrder, [lowerCutoffFrequencyHz higherCutoffFrequencyHz]/(0.5 * samplingRateHz));

%% generate Gaussian (normally-distributed) white noise
white_noise = randn(length, 1);
%% apply to filter to yield bandlimited noise
band_limited_noise = filter(bandpass_filter, 1, white_noise);
%% scale eye blink
eye_blink = band_limited_noise .* (originalSignalMax / max(band_limited_noise));

end

