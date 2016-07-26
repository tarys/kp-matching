%% load original data
load('dataset.mat');
signal = dataset(1, 1001:3000);

%% calculating signal maximum for further scaling
signal_max = max(signal);

%% simulate eye blink
eye_blink = generate_eye_blink(1000, 300, signal_max);

%% simulate muscle activity
temporal_muscle_activity = generate_temporal_muscle_activity(1000, 300, signal_max);

%% linear trend 
 linear_trend = generate_linear_trend(300, signal_max * .5, signal_max);
 