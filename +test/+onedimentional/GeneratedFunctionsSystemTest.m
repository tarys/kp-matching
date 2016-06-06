classdef GeneratedFunctionsSystemTest < TestCase
    
    properties
        lowerBound
        higherBound
        step
        generativeTransforms
        cardinalFunctionIndex
        generatedFunctionsSystem
    end
    
    methods
        % The first method in the methods block is the constructor.
        % It takes the desired test method name as its input argument,
        % and it passes that input along to the base class constructor
        function self = GeneratedFunctionsSystemTest(name)
            self = self@TestCase(name);
        end
        
        function setUp(self)
            import kunchenko.*;
            
            self.lowerBound = -5;
            self.higherBound = 14.6;
            self.step = 0.2;
            self.cardinalFunctionIndex = 2;
            
            generativeTransformsCount = 15;
            
            self.generativeTransforms = generateGenerativeTransforms('int', generativeTransformsCount);
            calculateCorrelantFunction = @calculateOneDimentionalCorrelant;
            self.generatedFunctionsSystem = buildGeneratedFunctionsSystem(self.lowerBound:self.step:self.higherBound, self.step, self.generativeTransforms, self.cardinalFunctionIndex, calculateCorrelantFunction);
        end
        
        function testIntervalConstructor(self)
            assertEqual(self.step, self.generatedFunctionsSystem.step);
        end
        
        function testGetGeneratedFunction(self)
            for i = 1:length(self.generativeTransforms)
                assertEqual(self.generativeTransforms{i}(self.lowerBound:self.step:self.higherBound), self.generatedFunctionsSystem.generatedFunctions{i});
            end
        end
        
        function testGetGeneratedFunctions(self)
            generatedFunctions = self.generatedFunctionsSystem.generatedFunctions;
            for i = 1:length(generatedFunctions)
                assertEqual(self.generativeTransforms{i}(self.lowerBound:self.step:self.higherBound), generatedFunctions{i});
            end
        end
        
        function testBuild(self)
            import kunchenko.*;
            template = self.generativeTransforms{self.cardinalFunctionIndex}(self.lowerBound:self.step:self.higherBound);
            calculateCorrelantFunction = @calculateOneDimentionalCorrelant;
            generatedFunctionsSystemFromTemplate = buildGeneratedFunctionsSystem(template, self.step, self.generativeTransforms, self.cardinalFunctionIndex, calculateCorrelantFunction);
            generatedFunctions = generatedFunctionsSystemFromTemplate.generatedFunctions;
            for i = 1:length(generatedFunctionsSystemFromTemplate)
                assertEqual(self.generativeTransforms{i}(self.lowerBound:self.step:self.higherBound), generatedFunctions{i});
            end
        end
        
        function testInsertRemoveTemplate(self)
            template = self.generatedFunctionsSystem.generatedFunctions{self.cardinalFunctionIndex};
            oldSize = length(self.generatedFunctionsSystem.generatedFunctions);
            
            [self.generatedFunctionsSystem.generatedFunctions self.generatedFunctionsSystem.correlantsMatrix] = insert(template, self.cardinalFunctionIndex, self.generatedFunctionsSystem.generatedFunctions, self.generatedFunctionsSystem.correlantsMatrix, self.generatedFunctionsSystem.step, self.generatedFunctionsSystem.calculateCorrelantFunction);
            
            assertEqual(oldSize + 1, length(self.generatedFunctionsSystem.generatedFunctions));
            assertEqual(template, self.generatedFunctionsSystem.generatedFunctions{self.cardinalFunctionIndex});
            
            [self.generatedFunctionsSystem.generatedFunctions self.generatedFunctionsSystem.correlantsMatrix] = remove(self.cardinalFunctionIndex,...
                self.generatedFunctionsSystem.generatedFunctions,...
                self.generatedFunctionsSystem.correlantsMatrix);
            
            assertEqual(oldSize, length(self.generatedFunctionsSystem.generatedFunctions));
        end
        
        function testInsertAndCalculateNewCorrelant(~)
            import kunchenko.*;
            generativeTransformsLocal = generateGenerativeTransforms('int', 3);
            stepLocal = 0.01;
            domain = 0:stepLocal:1;
            cardinalFunctionIndexLocal = 2;
            calculateCorrelantFunction = @calculateOneDimentionalCorrelant;
            generatedFunctionsSystemLocal = GeneratedFunctionsSystem.build(domain, stepLocal, generativeTransformsLocal, cardinalFunctionIndexLocal, calculateCorrelantFunction);
            
            cardinalFunctionIndexLocalBefore = [  1   0.5   1/3
                                                0.5   1/3  0.25
                                                1/3  0.25   0.2];
            assertElementsAlmostEqual(cardinalFunctionIndexLocalBefore, generatedFunctionsSystemLocal.correlantsMatrix, 'absolute', 10e-5);

            functionToInsert = generatedFunctionsSystemLocal.generatedFunctions{cardinalFunctionIndexLocal};
            insertionIndex = cardinalFunctionIndexLocal;
            [generatedFunctionsSystemLocal.generatedFunctions generatedFunctionsSystemLocal.correlantsMatrix] = insert(functionToInsert, insertionIndex, generatedFunctionsSystemLocal.generatedFunctions, generatedFunctionsSystemLocal.correlantsMatrix, generatedFunctionsSystemLocal.step, generatedFunctionsSystemLocal.calculateCorrelantFunction);
            
            cardinalFunctionIndexLocalAfter = [   1   0.5   0.5   1/3
                                                0.5   1/3   1/3  0.25
                                                0.5   1/3   1/3  0.25
                                                1/3  0.25  0.25   0.2];
            assertElementsAlmostEqual(cardinalFunctionIndexLocalAfter, generatedFunctionsSystemLocal.correlantsMatrix, 'absolute', 10e-5);
            
            [generatedFunctionsSystemLocal.generatedFunctions generatedFunctionsSystemLocal.correlantsMatrix] = remove(insertionIndex,...
                generatedFunctionsSystemLocal.generatedFunctions,...
                generatedFunctionsSystemLocal.correlantsMatrix);
            assertElementsAlmostEqual(cardinalFunctionIndexLocalBefore, generatedFunctionsSystemLocal.correlantsMatrix, 'absolute', 10e-5);
        end
    end
    
end
