function correlant = calculateCorrelant(function1, function2, step)
    correlant = trapz(function1 .* function2) * step;
end

