% TODO implement graphical experiment for joint probabilities approach
%% load original data
load('dataset.mat');
signal = dataset(1, 1001:3000);

%% calculating signal maximum for further scaling
signal_max = max(signal);

%% simulate eye blink
eye_blink = generate_eye_blink(1000, 300, signal_max);

%% mix extra signals with original data
[mixed_signal, eye_blink_start_position] = add_eye_blink_to_signal_at_random_position(eye_blink, signal);

joint_probability_values = zeros(1, length(signal) - length(eye_blink) + 1);

%% classical windowing approach
for i = 1:(length(signal) - length(eye_blink) + 1)
    %% window signal cut
    window_signal = mixed_signal(i:i + length(eye_blink) - 1);
    pd = fitdist(window_signal','Normal');
    joint_probability_values(i) = sum(-log(pdf(pd, window_signal)));
end

display(eye_blink_start_position);
[v, i] = max(joint_probability_values);
display(i);