%   INPUT:
%       • domain                        -   domain, over which generative transforms will be applied
%       • step                          -   step-distance between two successive values
%       • generativeTransforms          -   cell-array of handles that represents generative transforms
%                                           The size of this array = Size of polynomial + 1
%                                           (as we must take into account generative transform f0).
%
%                                              f0, f1, f2 , ..., fN
%
%                                           cell-array looks like:
%
%                                               A = {fHandler0 fHandler1 fHandler2 ... fHandlerN}
%
%       • cardinalFunctionIndex         -   index of the cardinal (main)
%                                           function that will be treated
%                                           as target of approximation
%       • calculateCorrelantFunction    -   handle for calculate
%                                         correlant function
function generatedFunctionsSystem = buildGeneratedFunctionsSystem(domain, step, generativeTransforms, cardinalFunctionIndex, calculateCorrelantFunction)
    generatedFunctionsSystem.domain = domain;
    generatedFunctionsSystem.step = step;
    generatedFunctionsSystem.generatedFunctions =  cell(1, length(generativeTransforms));
    for i = 1:length(generatedFunctionsSystem.generatedFunctions)
        generatedFunctionsSystem.generatedFunctions{i} = generativeTransforms{i}(domain);
    end
    generatedFunctionsSystem.cardinalFunctionIndex = cardinalFunctionIndex;
    generatedFunctionsSystem.calculateCorrelantFunction = calculateCorrelantFunction;
    generatedFunctionsSystem.correlantsMatrix = calculateCorrelantsMatrix(calculateCorrelantFunction, generatedFunctionsSystem.generatedFunctions, step);
end
