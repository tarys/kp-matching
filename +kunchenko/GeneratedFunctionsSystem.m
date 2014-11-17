classdef GeneratedFunctionsSystem < handle
    %GENERATEDFUNCTIONSSYSTEM Represents 1D immutable data-class that contains ALL information about generated functions system +
    %holds correlants
    properties(SetAccess = private, GetAccess = public)
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
    
    methods
        
        % Insert generated function into specified position
        function insert(self, functionToInsert, insertionIndex)
            self.generatedFunctions = [self.generatedFunctions(1:(insertionIndex - 1)) functionToInsert self.generatedFunctions((insertionIndex):end)];
            
            generatedFunctionsCount = length(self.generatedFunctions);
            correlantsColToAdd = zeros(generatedFunctionsCount, 1);
            for i = 1:generatedFunctionsCount
                correlantsColToAdd(i) = self.calculateCorrelantFunction(self.generatedFunctions{i}, self.generatedFunctions{insertionIndex}, self.step);
            end
            
            
            % populateCorrelantsMatrix
            tempMatrix1 = self.correlantsMatrix;
            tempMatrix2 = [tempMatrix1(:, 1:(insertionIndex - 1)) zeros(generatedFunctionsCount - 1, 1) tempMatrix1(:, insertionIndex:end)];
            newCorrelantsMatrix = [tempMatrix2(1:(insertionIndex - 1), :);
                zeros(1, generatedFunctionsCount);
                tempMatrix2(insertionIndex:end, :)];
            newCorrelantsMatrix(:, insertionIndex) = correlantsColToAdd;
            newCorrelantsMatrix(insertionIndex, :) = correlantsColToAdd';
            self.correlantsMatrix = newCorrelantsMatrix;
        end
        
        % Remove generated function by its index
        function remove(self, index)
            % removeCorrelantsOfGeneratedFunction
            tempMatrix1 = self.correlantsMatrix;
            tempMatrix2 = [tempMatrix1(:, 1:(index - 1)) tempMatrix1(:, (index + 1):end)];
            newCorrelantsMatrix = [tempMatrix2(1:(index - 1), :);
                                   tempMatrix2((index + 1):end, :)];
            self.correlantsMatrix = newCorrelantsMatrix; 
            
           % removeGeneratedFunction 
           self.generatedFunctions = [self.generatedFunctions(1:(index - 1)) self.generatedFunctions((index + 1):end)]; 
            
        end
        
        % Returns cell-array of generated functions without cardinal function
        function generatedFunctionsWithoutCardinalFunction = getGeneratedFunctionsWithoutCardinalFunction(self)
            tempVector1 = [self.generatedFunctions(1: (self.cardinalFunctionIndex - 1)) self.generatedFunctions((self.cardinalFunctionIndex + 1):end)];
            generatedFunctionsWithoutCardinalFunction = tempVector1;
        end
        
    end
    
    methods(Access = private)
        

       
    end
end
