% This script builds confusion matrices for following EEG classification
% methods:
%
% • Extreme values
% • Data improbability
% • Kurtosis
% • Spectral pattern
% • Kunchenko polynomials

%% load original data
load('dataset.mat');

%% prepaing collection statistics storage
experiment_staistics = containers.Map();

experiment_staistics('threshold_tp') = 0;
experiment_staistics('threshold_tn') = 0;
experiment_staistics('threshold_fp') = 0;
experiment_staistics('threshold_fn') = 0;

experiment_staistics('kunchenko_tp') = 0;
experiment_staistics('kunchenko_tn') = 0;
experiment_staistics('kunchenko_fp') = 0;
experiment_staistics('kunchenko_fn') = 0;

%% performing actual iterations to collect statistics
for i = 1:30 
    signal = dataset(i, 1001:3000);
    if i <= 20
        %% simulate eye blink
        eye_blink = generate_eye_blink(1000, 300, max(signal));
        
        %% mix extra signals with original data
        [mixed_signal, eye_blink_start_position] = add_eye_blink_to_signal_at_random_position(eye_blink, signal);
        
        %% run KP algorithm
        generatedFunctions = integerPowers(6);
        [~, ~, effectogram] = KunchenkoNew(mixed_signal, eye_blink, generatedFunctions);
        aligned_effectogram = [effectogram zeros(1, length(eye_blink) - 1)];
        
        %% check True Positive case for THRESHOLDING method
        if signal
        end
    end
end




