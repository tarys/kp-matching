% Perform template matching for given params
% INPUT:
%   • signal                    - signal to be matched             
%
% OUTPUT:
%   • matchingResult - structure with following fields:
%                           • signal      - input signal to be approximated
%                           • polynomial  - resulting polynomial approximation
%                           • effectogram - resulting effectogram of approximation
function matchingResult = match(signal, template, step, generativeTransforms, cardinalFunctionIndex, calculateCorrelantFunction)

    % =========================================
    generatedFunctionsSystem = kunchenko.GeneratedFunctionsSystem.build(template, ...
    step, ...
    generativeTransforms, ...
    cardinalFunctionIndex, ...
    calculateCorrelantFunction);
    % =========================================

    signalSize = size(signal);
    templateSize = size(generatedFunctionsSystem.domain);

    signalIterator = createIterator(signal, templateSize);            
    effectogramIterator = createIterator(zeros(signalSize - templateSize + 1), size(1));            
    polynomialIterator = createIterator(zeros(signalSize), templateSize);
    temporaryEfficiencyIterator = createIterator(zeros(signalSize), templateSize); 

    while signalIterator.hasNext() && polynomialIterator.hasNext() && effectogramIterator.hasNext()                    
        windowSignal = signalIterator.next();
        windowEfficiency = temporaryEfficiencyIterator.next();
        windowPolynomial = polynomialIterator.next();

        
        
        functions = generatedFunctionsSystem;
        functions.insert(windowSignal, generatedFunctionsSystem.cardinalFunctionIndex);
        approximationResult = approximate(functions);
        functions.remove(generatedFunctionsSystem.cardinalFunctionIndex);
        
        
        
        effectogramIterator.next();
        effectogramIterator.setCurrentWindow(approximationResult.efficiency);

        replacementIndecies = abs(approximationResult.efficiency) >= abs(windowEfficiency);                

        windowPolynomial(replacementIndecies) = approximationResult.polynomial(replacementIndecies);
        polynomialIterator.setCurrentWindow(windowPolynomial);                

        windowEfficiency(replacementIndecies) = approximationResult.efficiency;
        temporaryEfficiencyIterator.setCurrentWindow(windowEfficiency);
    end

    matchingResult.signal = signalIterator.array;
    matchingResult.polynomial = polynomialIterator.array;
    matchingResult.effectogram = effectogramIterator.array;
end