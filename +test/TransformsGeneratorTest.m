classdef TransformsGeneratorTest < TestCase
    properties
        dataArray
    end
    
    methods
        % The first method in the methods block is the constructor.
        % It takes the desired test method name as its input argument,
        % and it passes that input along to the base class constructor
        function self = TransformsGeneratorTest(name)
            self = self@TestCase(name);
        end
        
        % classic xUnit set up
        function setUp(self)
            self.dataArray = -31:17;
        end
        
        function testIntegerPowers(self)
            generativeTransforms = kunchenko.TransformsGenerator.generate('int', 5);
            for i = 1:length(generativeTransforms)
                assertEqual(generativeTransforms{i}(self.dataArray), self.dataArray.^(i-1));
            end
        end
        
        function testInvertIntegerPowers(self)
            generativeTransforms = kunchenko.TransformsGenerator.generate('invertInt', 5);
            assertEqual(generativeTransforms{1}(self.dataArray), self.dataArray.^0);
            for i = 2:length(generativeTransforms)
                assertEqual(generativeTransforms{i}(self.dataArray), self.dataArray.^(1/(i-1)));
            end
        end
        
        function testExpPowers(self)
            generativeTransforms = kunchenko.TransformsGenerator.generate('exp', 5);
            assertEqual(generativeTransforms{1}(self.dataArray), self.dataArray.^0);
            for i = 2:length(generativeTransforms)
                assertEqual(generativeTransforms{i}(self.dataArray), exp((i-1)*self.dataArray));
            end
        end
        
        function testSinPowers(self)
            generativeTransforms = kunchenko.TransformsGenerator.generate('sin', 5);
            for i = 1:length(generativeTransforms)
                assertEqual(generativeTransforms{i}(self.dataArray), sin(0.5*pi*self.dataArray).^(i-1));
            end
        end
        
        function testIllegalTypePowers(~)
            methodWithException = @()kunchenko.TransformsGenerator.generate('genious', 1);
            assertExceptionThrown(methodWithException, 'SwitchChk:NoSuchCase');
            
        end
        
        % classic xUnit tear down
        function tearDown(self)
            self.dataArray = [];
        end
    end
end

