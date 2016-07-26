%TEMPORAL_MUSCLE_ACTIVITY modeling temporal muscle activity time courses
%                         using random noise band-pass filtered (FIR) between 20 and 60 Hz
%   Input arguments:
%       • samplingRateHz - Hz, Sampling Rate (Frequency)
%       • length - resulting array length
%       • originalSignalMax - maximum of original signal to scale properly
function [ temporal_muscle_activity ] = generate_temporal_muscle_activity( samplingRateHz,  length, originalSignalMax)

%% design FIR filter to filter noise to half of Nyquist rate
filterOrder = 64;               % Order
lowerCutoffFrequencyHz = 20;     % Hz, First Cutoff Frequency
higherCutoffFrequencyHz = 60;    % Hz, Second Cutoff Frequency

bandpass_filter = fir1(filterOrder, [lowerCutoffFrequencyHz higherCutoffFrequencyHz]/(0.5 * samplingRateHz));

%% generate Gaussian (normally-distributed) white noise
white_noise = randn(length, 1);
%% apply to filter to yield bandlimited noise
band_limited_noise = filter(bandpass_filter, 1, white_noise);
%% scale
temporal_muscle_activity = band_limited_noise .* (originalSignalMax / max(band_limited_noise));

end

