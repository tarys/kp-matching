classdef KunchenkoApproximator < handle
    %KUNCHENKOAPPROXIMATOR recognizer for 1D case. need to be generalized
    %after proper implementation
    
    methods
        
        % Constructs KunchenkoApproximator object.
        function object = KunchenkoApproximator()
        end
        
    end
    
    methods(Static)
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
            import kunchenko.KunchenkoApproximator;
            
            correlantsMatrix = generatedFunctionsSystem.correlantsMatrix;
            centeredCorrelantsMatrix = calculateCenteredCorrelantsMatrix(correlantsMatrix);
            [systemMatrix freeVector] = KunchenkoApproximator.buildLinearAlgebraicEquationSystemParameters(centeredCorrelantsMatrix, generatedFunctionsSystem.cardinalFunctionIndex);
            alphaVector = KunchenkoApproximator.solveLinearAlgebraicEquationSystem(systemMatrix, freeVector);
            inforkune = KunchenkoApproximator.calculateInforcune(alphaVector, freeVector);
            alpha0 = KunchenkoApproximator.calculateAlpha0(alphaVector, generatedFunctionsSystem.cardinalFunctionIndex, correlantsMatrix);
            polynomial = KunchenkoApproximator.calculatePolynomial(alpha0, alphaVector, generatedFunctionsSystem);
            efficiency = KunchenkoApproximator.calculateEfficiency(inforkune, centeredCorrelantsMatrix, generatedFunctionsSystem.cardinalFunctionIndex, freeVector);
            
            
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
        
        function submatrix = excludeRowFromMatrix(matrix, rowNumber)
            submatrix = [matrix(1:(rowNumber - 1), :); matrix((rowNumber + 1):end, :)];
        end
        
        function submatrix = excludeColFromMatrix(matrix, colNumber)
            submatrix = kunchenko.KunchenkoApproximator.excludeRowFromMatrix(matrix', colNumber)';
        end
        
        function [systemMatrix freeVector] = buildLinearAlgebraicEquationSystemParameters(centeredCorrelantsMatrix, cardinalFunctionIndex)
            import kunchenko.KunchenkoApproximator;
            % delete row corresponding to cardinal function, also deleting first col, because it corresponds to zero-indexed correlant;
            tempMatrix1 = KunchenkoApproximator.excludeRowFromMatrix(centeredCorrelantsMatrix, cardinalFunctionIndex);
            tempMatrix2 = KunchenkoApproximator.excludeRowFromMatrix(tempMatrix1, 1);
            
            % delete col corresponding to cardinal function, also deleting first col, because it corresponds to zero-indexed correlant;
            tempMatrix3 = KunchenkoApproximator.excludeColFromMatrix(tempMatrix2, cardinalFunctionIndex);
            tempMatrix4 = KunchenkoApproximator.excludeColFromMatrix(tempMatrix3, 1);
            
            systemMatrix = tempMatrix4;
            
            % selecting free variables vector
            tempVector1 = centeredCorrelantsMatrix(:, cardinalFunctionIndex);
            tempVector2 = KunchenkoApproximator.excludeRowFromMatrix(tempVector1, cardinalFunctionIndex);
            tempVector3 = KunchenkoApproximator.excludeRowFromMatrix(tempVector2, 1);
            
            freeVector = tempVector3;
        end
        
        function alphaVector = solveLinearAlgebraicEquationSystem(systemMatrix, freeVector)
            alphaVector = systemMatrix \ freeVector;
        end
        
        function alpha0 = calculateAlpha0(alphaVector, cardinalFunctionIndex, correlantsMatrix)
            tempVector1 = correlantsMatrix(1, :);
            tempVector2 = kunchenko.KunchenkoApproximator.excludeColFromMatrix(tempVector1, cardinalFunctionIndex);
            tempVector3 = kunchenko.KunchenkoApproximator.excludeColFromMatrix(tempVector2, 1);
            correlantSubVector = tempVector3;
            
            alpha0 = (correlantsMatrix(cardinalFunctionIndex, 1) - correlantSubVector * alphaVector) / correlantsMatrix(1, 1);
        end
        
        function inforkune = calculateInforcune(alphaVector, freeVector)
            inforkune = alphaVector' * freeVector;
        end
        
        function efficiency = calculateEfficiency(inforkune, centeredCorrelantsMatrix, cardinalFunctionIndex, freeVector)
            centeredMainCorrelant = centeredCorrelantsMatrix(cardinalFunctionIndex, cardinalFunctionIndex);
            if centeredMainCorrelant ~= 0
                efficiency = inforkune / centeredMainCorrelant;
            else
                efficiency = 0;
            end;
            
            if(kunchenko.KunchenkoApproximator.isInverted(freeVector))
                efficiency = -efficiency;
            end
        end
        
        % Criterion that inverted template was found are negative signs of free-vars
        % vector's coeffs (form system F * a1 = f ), so check this condition when calculating effectivity
        function inverted = isInverted(freeVector)
            inverted = (max(freeVector) <= 0);
        end
        
        function polynomial = calculatePolynomial(alpha0, alphaVector, generatedFunctionsSystem)
            import kunchenko.KunchenkoApproximator;
            
            alphaVectorWithAlpha0 = [alpha0; alphaVector];
            getGeneratedFunctionsWithoutCardinalFunction = generatedFunctionsSystem.getGeneratedFunctionsWithoutCardinalFunction();
            
            polynomial = zeros(size(generatedFunctionsSystem.domain));
            for i = 1:length(alphaVectorWithAlpha0)
                polynomial = polynomial + alphaVectorWithAlpha0(i) * getGeneratedFunctionsWithoutCardinalFunction{i};
            end
        end
    end
end
