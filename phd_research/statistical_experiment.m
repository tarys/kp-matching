%% general experiment parameters
number_of_iterations = 100;
trusting_threshold = 0.5:0.05:1;
true_positive = zeros(size(trusting_threshold));
false_positive = zeros(size(trusting_threshold));

%% load original data
load('dataset.mat');
original_signal = dataset(3, 1001:3000);

%% modeled eye blink time courses using random noise band-pass filtered (FIR) between 1 and 3 Hz

% design FIR filter to filter noise to half of Nyquist rate
samplingRateHz = 1000;          % Hz, Sampling Rate (Frequency)
filterOrder = 64;               % Order
lowerCutoffFrequencyHz = 1;     % Hz, First Cutoff Frequency
higherCutoffFrequencyHz = 3;    % Hz, Second Cutoff Frequency

bandpass_filter = fir1(filterOrder, [lowerCutoffFrequencyHz higherCutoffFrequencyHz]/(0.5 * samplingRateHz));

for i = 1: length(trusting_threshold)
    successfully_found_eye_blinks = 0;
    wrongly_found_eye_blinks = 0;
    
    for k = 1:number_of_iterations
        
        % generate Gaussian (normally-distributed) white noise
        white_noise = randn(300, 1);
        % apply to filter to yield bandlimited noise
        band_limited_noise = filter(bandpass_filter, 1, white_noise);
        % scale eye blink
        eye_blink = band_limited_noise .* (max(original_signal) / max(band_limited_noise));
        
        %% prepare extra signal
        eye_blink_start_position = randi(length(original_signal) - length(eye_blink));
        eye_blink_end_position = eye_blink_start_position + length(eye_blink) - 1;
        
        extra_signal = zeros(1, length(original_signal));
        extra_signal(eye_blink_start_position:eye_blink_end_position) = eye_blink;
        
        %% mix extra signals with original data
        mixed_signal = original_signal + extra_signal;
        
        %% run KP algorithm and recognition get results
        generatedFunctions = integerPowers(6);
        [~, ~, effectogram] = KunchenkoNew(mixed_signal, eye_blink, generatedFunctions);
        aligned_effectogram = [effectogram zeros(1, length(eye_blink) - 1)];
        
        %% count true positive finding
        if aligned_effectogram(eye_blink_start_position) >= trusting_threshold(i)
            successfully_found_eye_blinks = successfully_found_eye_blinks + 1;
        end
        
        %% find false positive finding
        wrongly_found_eye_blinks = wrongly_found_eye_blinks + sum(aligned_effectogram > trusting_threshold(i)) - 1; % subtracting 1 for true positive case
        
    end
    true_positive(i) = successfully_found_eye_blinks / number_of_iterations;
    false_positive(i) = wrongly_found_eye_blinks / number_of_iterations;    
end

%% plot results
figure;

subplot(2, 1, 1);
plot(true_positive);
ylabel('True positive');

subplot(2, 1, 2);
plot(false_positive);
ylabel('False positive');