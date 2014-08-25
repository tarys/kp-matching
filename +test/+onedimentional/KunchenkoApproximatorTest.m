classdef KunchenkoApproximatorTest < TestCase
    properties
        step
        domain
        generated4FunctionsSystem
        generated5FunctionsSystem        
        absoluteTolerance
        resultOfApproximationWithIncludedCardinalFunction
    end
    
    methods
        % The first method in the methods block is the constructor.
        % It takes the desired test method name as its input argument,
        % and it passes that input along to the base class constructor
        function self = KunchenkoApproximatorTest(name)
            self = self@TestCase(name);
        end
        
        % classic xUnit set up
        function setUp(self)
            import kunchenko.*;
            
            self.step = .01;
            self.domain = 0:self.step:1;
            
            cardinalFunctionIndex = 2;
            self.generated4FunctionsSystem = GeneratedFunctionsSystem.build(self.domain, self.step, generateGenerativeTransforms('int', 4), cardinalFunctionIndex, @calculateOneDimentionalCorrelant);
            self.generated5FunctionsSystem = GeneratedFunctionsSystem.build(self.domain, self.step, generateGenerativeTransforms('int', 5), cardinalFunctionIndex, @calculateOneDimentionalCorrelant);
            
            generativeTransformsWithIncludedCardinalFunction{1} = @(x)x.^0;
            generativeTransformsWithIncludedCardinalFunction{2} = @(x)x.^1;
            generativeTransformsWithIncludedCardinalFunction{3} = @(x)x.^1;
            generativeTransformsWithIncludedCardinalFunction{4} = @(x)x.^2;
            generativeTransformsWithIncludedCardinalFunction{5} = @(x)x.^3;
            generatedFunctionsSystem = GeneratedFunctionsSystem.build(self.domain, self.step, generativeTransformsWithIncludedCardinalFunction, cardinalFunctionIndex, @calculateOneDimentionalCorrelant);
            
            self.resultOfApproximationWithIncludedCardinalFunction = KunchenkoApproximator.approximate(generatedFunctionsSystem);
            self.absoluteTolerance = 1.0e-5;
        end
        
        % numeric example from Kunchenko's book
        function testCenteredCorrelantsCalculationInt5(self)
            import kunchenko.*;
            
            result = KunchenkoApproximator.approximate(self.generated5FunctionsSystem);
            
            assertEqual(result.centeredCorrelantsMatrix, result.centeredCorrelantsMatrix'); % check symmetry
            
            assertElementsAlmostEqual(result.centeredCorrelantsMatrix(2, 2), 1/12, 'absolute', self.generated5FunctionsSystem.step);
            assertElementsAlmostEqual(result.centeredCorrelantsMatrix(2, 2), 1/12, 'absolute', self.generated5FunctionsSystem.step);
            assertElementsAlmostEqual(result.centeredCorrelantsMatrix(2, 3), 1/12, 'absolute', self.generated5FunctionsSystem.step);
            assertElementsAlmostEqual(result.centeredCorrelantsMatrix(2, 4), 3/40, 'absolute', self.generated5FunctionsSystem.step);
            assertElementsAlmostEqual(result.centeredCorrelantsMatrix(2, 5), 1/15, 'absolute', self.generated5FunctionsSystem.step);
            
            assertElementsAlmostEqual(result.centeredCorrelantsMatrix(3, 3), 4/45, 'absolute', self.generated5FunctionsSystem.step);
            assertElementsAlmostEqual(result.centeredCorrelantsMatrix(3, 4), 1/12, 'absolute', self.generated5FunctionsSystem.step);
            assertElementsAlmostEqual(result.centeredCorrelantsMatrix(3, 5), 8/105, 'absolute', self.generated5FunctionsSystem.step);
            
            assertElementsAlmostEqual(result.centeredCorrelantsMatrix(4, 4), 9/112, 'absolute', self.generated5FunctionsSystem.step);
            assertElementsAlmostEqual(result.centeredCorrelantsMatrix(4, 5), 3/40, 'absolute', self.generated5FunctionsSystem.step);
            
            assertElementsAlmostEqual(result.centeredCorrelantsMatrix(5, 5), 16/225, 'absolute', self.generated5FunctionsSystem.step);
        end
        
        % numeric example from Kunchenko's book
        function testApproximationForIntegerSystemWithFourElements(self)
            import kunchenko.KunchenkoApproximator;
            
            result = KunchenkoApproximator.approximate(self.generated4FunctionsSystem);
            
            assertEqual(result.systemMatrix, result.systemMatrix'); % check symmetry
            assertElementsAlmostEqual(result.alphaVector, [2.25; -1.4], 'absolute', 0.01);
            assertElementsAlmostEqual(result.inforkune, 0.0825, 'absolute', 0.0001);
            assertElementsAlmostEqual(result.alpha0, 0.1, 'absolute', 0.1);
            assertElementsAlmostEqual(result.efficiency, 0.99, 'absolute', 0.01);
        end
        
        % numeric example from Kunchenko's book
        function testApproximationForIntegerSystemWithFiveElements(self)
            import kunchenko.KunchenkoApproximator;
            
            result = KunchenkoApproximator.approximate(self.generated5FunctionsSystem);
            
            assertEqual(result.systemMatrix, result.systemMatrix'); % check symmetry
            assertElementsAlmostEqual(result.alphaVector, [3.9375; -5.6; 2.625], 'absolute', 0.01);
            assertElementsAlmostEqual(result.inforkune, 0.083125, 'absolute', 0.0001);
            assertElementsAlmostEqual(result.alpha0, 0.0625, 'absolute', 0.001);
            assertElementsAlmostEqual(result.efficiency, 0.9975, 'absolute', 0.0001);
        end
        
        function testCalculateCenteredCorrelantsMatrix(self)            
            centeredCorrelantsMatrix = self.resultOfApproximationWithIncludedCardinalFunction.centeredCorrelantsMatrix;
            expectedCenteredCorrelantsMatrix = [0,       0,       0,       0,       0;
                0, 0.08335, 0.08335, 0.08335, 0.07502;
                0, 0.08335, 0.08335, 0.08335, 0.07502;
                0, 0.08335, 0.08335, 0.08891, 0.08336;
                0  0.07502, 0.07502, 0.08336, 0.08039];
            assertElementsAlmostEqual(expectedCenteredCorrelantsMatrix, centeredCorrelantsMatrix, 'absolute', self.absoluteTolerance);
        end
        
        function testBuildLinearAlgebraicEquationSystemParameters(self)
            systemMatrix = self.resultOfApproximationWithIncludedCardinalFunction.systemMatrix;            
            expectedSystemMatrix = [0.08335, 0.08335, 0.07502;
                0.08335, 0.08891, 0.08336;
                0.07502, 0.08336, 0.08039];
            assertElementsAlmostEqual(expectedSystemMatrix, systemMatrix, 'absolute', self.absoluteTolerance);
            
            freeVector = self.resultOfApproximationWithIncludedCardinalFunction.freeVector;
            expectedFreeVector = [0.08335;
                0.08335;
                0.07502];
            assertElementsAlmostEqual(expectedFreeVector, freeVector, 'absolute', self.absoluteTolerance);
        end
        
        function testSolveLinearAlgebraicEquationSystem(self)
            alphaVector = self.resultOfApproximationWithIncludedCardinalFunction.alphaVector;
            expectedAlphaVector = [1;
                0;
                0];
            assertElementsAlmostEqual(expectedAlphaVector, alphaVector, 'absolute', self.absoluteTolerance);
        end
        
        function testCalculateInforcune(self)
            inforkune = self.resultOfApproximationWithIncludedCardinalFunction.inforkune;
            expectedInforkune = 0.08335;
            assertElementsAlmostEqual(expectedInforkune, inforkune, 'absolute', self.absoluteTolerance);
        end
        
        function testCalculateAlpha0(self)
            alpha0 = self.resultOfApproximationWithIncludedCardinalFunction.alpha0;
            expectedAlpha0 = 0;
            assertElementsAlmostEqual(expectedAlpha0, alpha0, 'absolute', self.absoluteTolerance);
        end
        
        function testCalculatePolynomial(self)
            polynomial = self.resultOfApproximationWithIncludedCardinalFunction.polynomial;
            assertElementsAlmostEqual(self.domain, polynomial, 'absolute', self.absoluteTolerance);
        end
        
        function testCalculateEfficiency(self)
            efficiency = self.resultOfApproximationWithIncludedCardinalFunction.efficiency;
            expectedEfficiency = 1;
            assertElementsAlmostEqual(expectedEfficiency, efficiency, 'absolute', self.absoluteTolerance);
        end
        
        % classic xUnit tear down
        function tearDown(self)
            self.generated4FunctionsSystem = {};
            self.generated5FunctionsSystem = {};
        end
        
    end
end