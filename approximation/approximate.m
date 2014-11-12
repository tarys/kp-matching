% Approximates cardinal function specified by generatedFunctionsSystem.cardinalFunctionIndex with rest of
% generated functions from generatedFunctionsSystem object
%
% INPUT:
%  • generatedFunctionsSystem   -   object with all info about generated functions system
%
% OUTPUT:
%  • result                     -   structure that contains following fields:
%                                       • correlantsMatrix
%                                       • centeredCorrelantsMatrix
%                                       • systemMatrix
%                                       • freeVector
%                                       • alphaVector
%                                       • inforkune
%                                       • alpha0
%                                       • polynomial
%                                       • efficiency
function result = approximate(generatedFunctionsSystem)

    correlantsMatrix = generatedFunctionsSystem.correlantsMatrix;
    centeredCorrelantsMatrix = calculateCenteredCorrelantsMatrix(correlantsMatrix);
    [systemMatrix freeVector] = buildLinearAlgebraicEquationSystemParameters(centeredCorrelantsMatrix, generatedFunctionsSystem.cardinalFunctionIndex);
    alphaVector = systemMatrix \ freeVector;
    inforkune = calculateInforcune(alphaVector, freeVector);
    alpha0 = calculateAlpha0(alphaVector, generatedFunctionsSystem.cardinalFunctionIndex, correlantsMatrix);
    polynomial = calculatePolynomial(alpha0, alphaVector, generatedFunctionsSystem);
    efficiency = calculateEfficiency(inforkune, centeredCorrelantsMatrix, generatedFunctionsSystem.cardinalFunctionIndex, freeVector);


    % preparing output data
    result.correlantsMatrix = correlantsMatrix;
    result.centeredCorrelantsMatrix = centeredCorrelantsMatrix;
    result.systemMatrix = systemMatrix;
    result.freeVector = freeVector;
    result.alphaVector = alphaVector;
    result.inforkune = inforkune;
    result.alpha0 = alpha0;
    result.polynomial = polynomial;
    result.efficiency = efficiency;
end
