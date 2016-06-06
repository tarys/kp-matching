function correlantsMatrix = calculateCorrelantsMatrix(calculateCorrelantFunction, generatedFunctions, step)
    generatedFunctionsCount = length(generatedFunctions);
    correlantsMatrix = zeros(generatedFunctionsCount, generatedFunctionsCount);
    for i = 1:generatedFunctionsCount
        for j = 1:generatedFunctionsCount
            correlantsMatrix(i, j) = calculateCorrelantFunction(generatedFunctions{i}, generatedFunctions{j}, step);
        end
    end
end
