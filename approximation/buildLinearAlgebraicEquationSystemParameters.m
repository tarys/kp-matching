function [systemMatrix freeVector] = buildLinearAlgebraicEquationSystemParameters(centeredCorrelantsMatrix, cardinalFunctionIndex)
    % delete row corresponding to cardinal function, also deleting first col, because it corresponds to zero-indexed correlant;
    tempMatrix1 = excludeRowFromMatrix(centeredCorrelantsMatrix, cardinalFunctionIndex);
    tempMatrix2 = excludeRowFromMatrix(tempMatrix1, 1);

    % delete col corresponding to cardinal function, also deleting first col, because it corresponds to zero-indexed correlant;
    tempMatrix3 = excludeColFromMatrix(tempMatrix2, cardinalFunctionIndex);
    tempMatrix4 = excludeColFromMatrix(tempMatrix3, 1);

    systemMatrix = tempMatrix4;

    % selecting free variables vector
    tempVector1 = centeredCorrelantsMatrix(:, cardinalFunctionIndex);
    tempVector2 = excludeRowFromMatrix(tempVector1, cardinalFunctionIndex);
    tempVector3 = excludeRowFromMatrix(tempVector2, 1);

    freeVector = tempVector3;
end

