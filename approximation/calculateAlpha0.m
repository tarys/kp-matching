function alpha0 = calculateAlpha0(alphaVector, cardinalFunctionIndex, correlantsMatrix)
    tempVector1 = correlantsMatrix(1, :);
    tempVector2 = excludeColFromMatrix(tempVector1, cardinalFunctionIndex);
    tempVector3 = excludeColFromMatrix(tempVector2, 1);
    correlantSubVector = tempVector3;

    alpha0 = (correlantsMatrix(cardinalFunctionIndex, 1) - correlantSubVector * alphaVector) / correlantsMatrix(1, 1);
end