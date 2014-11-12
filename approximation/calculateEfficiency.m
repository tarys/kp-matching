function efficiency = calculateEfficiency(inforkune, centeredCorrelantsMatrix, cardinalFunctionIndex, freeVector)
    centeredMainCorrelant = centeredCorrelantsMatrix(cardinalFunctionIndex, cardinalFunctionIndex);
    if centeredMainCorrelant ~= 0
        efficiency = inforkune / centeredMainCorrelant;
    else
        efficiency = 0;
    end;

    if(isInverted(freeVector))
        efficiency = -efficiency;
    end
end