%GENERATE_LINEAR_TREND generate symmetric linear trend with random slope
%                      within given interval
%   Input arguments:
%       • length        - resulting array length
%       • min_amplitude - min bound for random slope amplitude generation
%       • max_amplitude - max bound for random slope amplitude generation
function [ linear_trend ] = generate_linear_trend(length, min_amplitude, max_amplitude)

bound = length * .5;
slope_coeff = ((max_amplitude - min_amplitude)*rand() + min_amplitude) / bound;
linear_trend = (-bound + 1:bound) .* slope_coeff;

end

