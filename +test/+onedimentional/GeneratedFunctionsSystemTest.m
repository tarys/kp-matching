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
            
            self.generativeTransforms = TransformsGenerator.generate('int', generativeTransformsCount);
            correlantCalculator = kunchenko.onedimentional.CorrelantCalculator();
            self.generatedFunctionsSystem = GeneratedFunctionsSystem.build(self.lowerBound:self.step:self.higherBound, self.step, self.generativeTransforms, self.cardinalFunctionIndex, correlantCalculator);
        end
        
        function testIntervalConstructor(self)
            assertEqual(self.step, self.generatedFunctionsSystem.step);
        end
        
        function testGetGeneratedFunction(self)
            for i = 1:length(self.generativeTransforms)
                assertEqual(self.generativeTransforms{i}(self.lowerBound:self.step:self.higherBound), self.generatedFunctionsSystem.getGeneratedFunction(i));
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
            correlantCalculator = kunchenko.onedimentional.CorrelantCalculator();
            generatedFunctionsSystemFromTemplate = GeneratedFunctionsSystem.build(template, self.step, self.generativeTransforms, self.cardinalFunctionIndex, correlantCalculator);
            generatedFunctions = generatedFunctionsSystemFromTemplate.generatedFunctions;
            for i = 1:length(generatedFunctionsSystemFromTemplate)
                assertEqual(self.generativeTransforms{i}(self.lowerBound:self.step:self.higherBound), generatedFunctions{i});
            end
        end
        
        function testInsertRemoveTemplate(self)
            template = self.generatedFunctionsSystem.getGeneratedFunction(self.cardinalFunctionIndex);
            oldSize = self.generatedFunctionsSystem.getSize();
            
            self.generatedFunctionsSystem.insert(template, self.cardinalFunctionIndex);
            
            assertEqual(oldSize + 1, self.generatedFunctionsSystem.getSize());
            assertEqual(template, self.generatedFunctionsSystem.getGeneratedFunction(self.cardinalFunctionIndex));
            
            self.generatedFunctionsSystem.remove(self.cardinalFunctionIndex);
            
            assertEqual(oldSize, self.generatedFunctionsSystem.getSize());
        end
        
        function testInsertAndCalculateNewCorrelant(~)
            import kunchenko.*;
            generativeTransformsLocal = TransformsGenerator.generate('int', 3);
            stepLocal = 0.01;
            domain = 0:stepLocal:1;
            cardinalFunctionIndexLocal = 2;
            correlantCalculator = kunchenko.onedimentional.CorrelantCalculator();
            generatedFunctionsSystemLocal = GeneratedFunctionsSystem.build(domain, stepLocal, generativeTransformsLocal, cardinalFunctionIndexLocal, correlantCalculator);
            
            cardinalFunctionIndexLocalBefore = [  1   0.5   1/3
                                                0.5   1/3  0.25
                                                1/3  0.25   0.2];
            assertElementsAlmostEqual(cardinalFunctionIndexLocalBefore, generatedFunctionsSystemLocal.correlantsMatrix, 'absolute', 10e-5);
            
            functionToInsert = generatedFunctionsSystemLocal.getGeneratedFunction(cardinalFunctionIndexLocal);
            insertionIndex = cardinalFunctionIndexLocal;
            generatedFunctionsSystemLocal.insert(functionToInsert, insertionIndex);
            
            cardinalFunctionIndexLocalAfter = [   1   0.5   0.5   1/3
                                                0.5   1/3   1/3  0.25
                                                0.5   1/3   1/3  0.25
                                                1/3  0.25  0.25   0.2];
            assertElementsAlmostEqual(cardinalFunctionIndexLocalAfter, generatedFunctionsSystemLocal.correlantsMatrix, 'absolute', 10e-5);
            
            generatedFunctionsSystemLocal.remove(insertionIndex);
            assertElementsAlmostEqual(cardinalFunctionIndexLocalBefore, generatedFunctionsSystemLocal.correlantsMatrix, 'absolute', 10e-5);
        end
    end
    
end