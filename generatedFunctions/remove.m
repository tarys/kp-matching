% Remove generated function by its index
function [generatedFunctions correlantsMatrix] = remove(index, generatedFunctions, correlantsMatrix)
    % removeCorrelantsOfGeneratedFunction
    tempMatrix1 = correlantsMatrix;
    tempMatrix2 = [tempMatrix1(:, 1:(index - 1)) tempMatrix1(:, (index + 1):end)];
    newCorrelantsMatrix = [tempMatrix2(1:(index - 1), :);
        tempMatrix2((index + 1):end, :)];


    correlantsMatrix = newCorrelantsMatrix;
    % removeGeneratedFunction
    generatedFunctions = [generatedFunctions(1:(index - 1)) generatedFunctions((index + 1):end)];
end
