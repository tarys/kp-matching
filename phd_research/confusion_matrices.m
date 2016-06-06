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

threshold = 0.9;
kunchenko_threshold = 0.7;
generatedFunctions = integerPowers(6);

%% prepaing collection statistics storage
theshold_confusion = zeros(2);
kunchenko_confusion = zeros(2);

%% performing actual iterations to collect statistics
for i = 1:30
    signal = dataset(i, 1001:3000);
    %% calculating signal maximum for further scaling
    signal_max = max(signal);
    
    %% simulate eye blink
    eye_blink = generate_eye_blink(1000, 300, signal_max);
    
    %% mix extra signals with original data
    [mixed_signal, eye_blink_start_position] = add_eye_blink_to_signal_at_random_position(eye_blink, signal);
    
    %% setup false positive position
    false_eye_blink_start_position = 2 * eye_blink_start_position + 1;
    
    %% for first 20 of 30 signals we add eyeblinks
    if i <= 20
        %% run KP algorithm
        [~, ~, effectogram] = KunchenkoNew(mixed_signal, eye_blink, generatedFunctions);
        aligned_effectogram = [effectogram zeros(1, length(eye_blink) - 1)];
        
        %% THRESHOLD method check
        if max(abs(mixed_signal(eye_blink_start_position:eye_blink_start_position + 300 - 1)) >= threshold * signal_max) > 0
            theshold_confusion(1, 1) = theshold_confusion(1, 1) + 1; % True Positive case
        else
            theshold_confusion(1, 2) = theshold_confusion(1, 2) + 1; % False Negative case
        end
        
        %% KUNCHENKO method check
        if aligned_effectogram(eye_blink_start_position) >= kunchenko_threshold
            kunchenko_confusion(1, 1) = kunchenko_confusion(1, 1) + 1; % True Positive case
        else
            kunchenko_confusion(1, 2) = kunchenko_confusion(1, 2) + 1; % False Negative case
        end
    else % for remaining 10 of 30 signals we do NOT add eyeblinks
        %% run KP algorithm
        [~, ~, effectogram] = KunchenkoNew(signal, eye_blink, generatedFunctions);
        aligned_effectogram = [effectogram zeros(1, length(eye_blink) - 1)];
        
        %% check THRESHOLDING method
        if max(abs(signal(eye_blink_start_position:eye_blink_start_position + 300 - 1)) >= threshold * signal_max) == 0
            theshold_confusion(2, 2) = theshold_confusion(2, 2) + 1; % True Negative
        else
            theshold_confusion(2, 1) = theshold_confusion(2, 1) + 1; % False Positive
        end
        
        %% check KUNCHENKO method
        if aligned_effectogram(eye_blink_start_position) < kunchenko_threshold
            kunchenko_confusion(2, 2) = kunchenko_confusion(2, 2) + 1; % True Negative
        else
            kunchenko_confusion(2, 1) = kunchenko_confusion(2, 1) + 1; % False Positive
        end
    end
end
