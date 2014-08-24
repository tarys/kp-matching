classdef CorrelantCalculatorTest < TestCase
    properties
        func
        step
        correlantsQuantity
        a
        b
        x
    end
    
    methods
        % The first method in the methods block is the constructor.
        % It takes the desired test method name as its input argument,
        % and it passes that input along to the base class constructor
        function self = CorrelantCalculatorTest(name)
            self = self@TestCase(name);
        end
        
        % classic xUnit set up
        function setUp(self)
            import kunchenko.*;
            
            self.func = @(x)x.^2;
            self.step = 10e-5;
            self.correlantsQuantity = 4;
            % interval [a; b] for integrating
            self.a = 0;
            self.b = 1;
            self.x = self.a:self.step:self.b;
        end
        
        function testQuad(self)
            integralValue = quad(self.func, 0, 1);
            assertEqual(integralValue, 1/3);
        end
        
        function testTrapz(self)
            integralValue  = self.step*trapz(self.func(0:self.step:1));
            assertElementsAlmostEqual(integralValue, 1/3);
        end
        
        function testCompareTrapzAndQuad(self)
            trapzIntegralValue = self.step*trapz(self.func(self.a:self.step:self.b));
            quadIntegralValue = quad(self.func, self.a, self.b);
            assertElementsAlmostEqual(trapzIntegralValue, quadIntegralValue);
        end
        
        function testCorrelantsSystemCalculation(self)
            import kunchenko.*;
            
            generativeTransformName = {'int', 'invertInt', 'exp', 'sin'};
            % testin all generative transforms types
            for k = 1:length(generativeTransformName)
                generativeTransforms = TransformsGenerator.generate(generativeTransformName{k}, self.correlantsQuantity);
                calculateCorrelantFunction = @calculateCorrelant;
                generatedFunctionsSystem = GeneratedFunctionsSystem.build(self.x, self.step, generativeTransforms, 2, calculateCorrelantFunction);
                for i = 1:self.correlantsQuantity
                    for j = 1:self.correlantsQuantity
                        correlant = generatedFunctionsSystem.correlantsMatrix(i, j);
                        f = @(z)generativeTransforms{i}(z) .* generativeTransforms{j}(z);
                        quadValue = quad(f, self.a, self.b);
                        assertElementsAlmostEqual(correlant, quadValue, 'absolute', self.step);
                    end
                end
            end
        end
        
        % classic xUnit tear down
        function tearDown(self)
            self.func = [];
            self.step = [];
            self.correlantsQuantity = [];
            self.a = [];
            self.b = [];
            self.x = [];
        end
    end
end