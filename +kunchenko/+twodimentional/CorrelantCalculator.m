classdef CorrelantCalculator
    %CORRELANTCALCULATOR Performs 2D correlant calculation
    
    properties
    end
    
    methods
        function correlant = calculateCorrelant(~, function1, function2, step)
            function1Step = step;
            function2Step = step;
            correlant = trapz(trapz(function1 .* function2, 2)) * function1Step * function2Step;
        end
    end
    
end

