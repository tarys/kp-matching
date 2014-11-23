% Returns cell-array of generated functions without cardinal function
function generatedFunctionsWithoutCardinalFunction = getGeneratedFunctionsWithoutCardinalFunction(generatedFunctions, cardinalFunctionIndex)
    tempVector1 = [generatedFunctions(1: (cardinalFunctionIndex - 1)) generatedFunctions((cardinalFunctionIndex + 1):end)];
    generatedFunctionsWithoutCardinalFunction = tempVector1;
end
