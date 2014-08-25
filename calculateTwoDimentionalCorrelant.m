function correlant = calculateTwoDimentionalCorrelant(function1, function2, step)
    function1Step = step;
    function2Step = step;
    correlant = trapz(trapz(function1 .* function2, 2)) * function1Step * function2Step;
end
