function polynomial = calculatePolynomial(alpha0, alphaVector, generatedFunctionsSystem)

    alphaVectorWithAlpha0 = [alpha0; alphaVector];
    generatedFunctionsWithoutCardinalFunction = getGeneratedFunctionsWithoutCardinalFunction(generatedFunctionsSystem.generatedFunctions, generatedFunctionsSystem.cardinalFunctionIndex);

    polynomial = zeros(size(generatedFunctionsSystem.domain));
    for i = 1:length(alphaVectorWithAlpha0)
        polynomial = polynomial + alphaVectorWithAlpha0(i) * generatedFunctionsWithoutCardinalFunction{i};
    end
end