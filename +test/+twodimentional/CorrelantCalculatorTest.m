classdef CorrelantCalculatorTest < TestCase
    properties
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
            
        end
        
        function testCalculateCorrelant(self)
            lowBound = 0;
            step = .01;
            upperBound = 1;
            f = @(x, y)x.^2 + y.^2;
            [X, Y] = meshgrid(lowBound:step:upperBound);
            functionValues = f(X, Y);
            correlant = calculateTwoDimentionalCorrelant(functionValues, functionValues, step);
            dblquadResult = dblquad(@(x, y)(f(x, y).*f(x, y)), lowBound, upperBound, lowBound, upperBound);
            assertElementsAlmostEqual(correlant, dblquadResult, 'absolute', step);
        end
        % classic xUnit tear down
        function tearDown(self)
        end
    end
end