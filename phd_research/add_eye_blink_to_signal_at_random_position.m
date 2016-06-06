%ADD_EYE_BLINK_TO_SIGNAL Add eye blink sample to given signal at rendom
%position.
%   Input:
%      • eye_blink          - eye blink's sample
%      • original_signal    - signal to add blink to
%   Output:
%      • mixed_signal               - signal with added eye blink
%      • eye_blink_start_position   - starting position of randomly added
%      eye blink
function [ mixed_signal, eye_blink_start_position] = add_eye_blink_to_signal_at_random_position( eye_blink, original_signal)
%% prepare extra signal
eye_blink_start_position = randi(.5 * length(original_signal) - length(eye_blink));

eye_blink_end_position = eye_blink_start_position + length(eye_blink) - 1;

extra_signal = zeros(1, length(original_signal));
extra_signal(eye_blink_start_position:eye_blink_end_position) = eye_blink;

%% mix extra signals with original data
mixed_signal = original_signal + extra_signal;

end

