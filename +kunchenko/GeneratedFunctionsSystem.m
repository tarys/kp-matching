classdef GeneratedFunctionsSystem < handle
    %GENERATEDFUNCTIONSSYSTEM Represents 1D immutable data-class that contains ALL information about generated functions system +
    %holds correlants
    properties(SetAccess = public, GetAccess = public)
        domain
        step
        generatedFunctions
        cardinalFunctionIndex
        calculateCorrelantFunction
        correlantsMatrix
    end
    
    methods (Static)
        % Constructs IntervalData object with given params
        %
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
        function generatedFunctionsSystem = build(domain, step, generativeTransforms, cardinalFunctionIndex, calculateCorrelantFunction)
            generatedFunctionsSystem = kunchenko.GeneratedFunctionsSystem(domain, step, generativeTransforms, cardinalFunctionIndex, calculateCorrelantFunction);
        end
        
    end
    
    methods(Access = private)   
        
        function obj = GeneratedFunctionsSystem(domain, step, generativeTransforms, cardinalFunctionIndex, calculateCorrelantFunction)            
            obj.domain = domain;
            obj.step = step;
            obj.generatedFunctions =  cell(1, length(generativeTransforms));
            for i = 1:length(obj.generatedFunctions)
                obj.generatedFunctions{i} = generativeTransforms{i}(domain);
            end
            obj.cardinalFunctionIndex = cardinalFunctionIndex;
            obj.calculateCorrelantFunction = calculateCorrelantFunction;
            obj.correlantsMatrix = calculateCorrelantsMatrix(calculateCorrelantFunction, obj.generatedFunctions, step);
        end
        
    end
end
