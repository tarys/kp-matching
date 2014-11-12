function inverted = isInverted(freeVector)
% ISINVERTED
% Criterion that inverted template was found are negative signs of free-vars
% vector's coeffs (form system F * a1 = f ), so check this condition when calculating effectivity
    inverted = (max(freeVector) <= 0);
end
