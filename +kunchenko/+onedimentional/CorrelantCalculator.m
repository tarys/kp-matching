classdef CorrelantCalculator
    %CORRELANTCALCULATOR Performs 1D correlant calculation
    
    properties
    end
    
    methods
        function correlant = calculateCorrelant(~, function1, function2, step)
            correlant = trapz(function1 .* function2) * step;
        end
    end
    
end

