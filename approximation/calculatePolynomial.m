function polynomial = calculatePolynomial(alpha0, alphaVector, generatedFunctionsSystem)

    alphaVectorWithAlpha0 = [alpha0; alphaVector];
    getGeneratedFunctionsWithoutCardinalFunction = generatedFunctionsSystem.getGeneratedFunctionsWithoutCardinalFunction();

    polynomial = zeros(size(generatedFunctionsSystem.domain));
    for i = 1:length(alphaVectorWithAlpha0)
        polynomial = polynomial + alphaVectorWithAlpha0(i) * getGeneratedFunctionsWithoutCardinalFunction{i};
    end
end