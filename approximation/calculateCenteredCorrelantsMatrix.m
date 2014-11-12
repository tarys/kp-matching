function centeredCorrelantsMatrix = calculateCenteredCorrelantsMatrix(correlantsMatrix)

    rowCount = length(correlantsMatrix);
    colCount = length(correlantsMatrix(1, :));
    centeredCorrelantsMatrix = zeros(rowCount, colCount);
    for i = 1:rowCount
        for j = 1:colCount
            centeredCorrelantsMatrix(i, j) = correlantsMatrix(i, j) - (correlantsMatrix(1, i) * correlantsMatrix(1, j)) / correlantsMatrix(1, 1);
        end
    end
end