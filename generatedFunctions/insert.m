% Insert generated function into specified position
function [generatedFunctions correlantsMatrix] = insert(functionToInsert, insertionIndex, generatedFunctions, correlantsMatrix, step, calculateCorrelantFunction)
    generatedFunctions = [generatedFunctions(1:(insertionIndex - 1)) functionToInsert generatedFunctions((insertionIndex):end)];

    generatedFunctionsCount = length(generatedFunctions);
    correlantsColToAdd = zeros(generatedFunctionsCount, 1);
    for i = 1:generatedFunctionsCount
        correlantsColToAdd(i) = calculateCorrelantFunction(generatedFunctions{i}, generatedFunctions{insertionIndex}, step);
    end


    % populateCorrelantsMatrix
    tempMatrix1 = correlantsMatrix;
    tempMatrix2 = [tempMatrix1(:, 1:(insertionIndex - 1)) zeros(generatedFunctionsCount - 1, 1) tempMatrix1(:, insertionIndex:end)];
    newCorrelantsMatrix = [tempMatrix2(1:(insertionIndex - 1), :);
        zeros(1, generatedFunctionsCount);
        tempMatrix2(insertionIndex:end, :)];
    newCorrelantsMatrix(:, insertionIndex) = correlantsColToAdd;
    newCorrelantsMatrix(insertionIndex, :) = correlantsColToAdd';
    correlantsMatrix = newCorrelantsMatrix;
end        
