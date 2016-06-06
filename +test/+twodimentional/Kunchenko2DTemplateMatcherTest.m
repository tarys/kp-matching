classdef Kunchenko2DTemplateMatcherTest < TestCase
    %KUNCHENKORECOGNIZERTEST 2D recognition implementation tests
    
    methods
        % The first method in the methods block is the constructor.
        % It takes the desired test method name as its input argument,
        % and it passes that input along to the base class constructor
        function self = Kunchenko2DTemplateMatcherTest(name)
            self = self@TestCase(name);
        end
        
        % classic xUnit set up
        function setUp(self)
        end
        
        function testApproximate(self)
            import kunchenko.*;
            
            step = .01;
            x = 0:step:1;
            [X, Y] = meshgrid(x);
            template = X.^2 + Y.^2;
            
            cardinalFunctionIndex = 2;
            generativeTransformsWithIncludedCardinalFunction{1} = @(x)x.^0;
            generativeTransformsWithIncludedCardinalFunction{2} = @(x)x.^1;
            generativeTransformsWithIncludedCardinalFunction{3} = @(x)x.^1;
            generativeTransformsWithIncludedCardinalFunction{4} = @(x)x.^2;
            generativeTransformsWithIncludedCardinalFunction{5} = @(x)x.^3;
            
            generatedFunctionsSystem = buildGeneratedFunctionsSystem(template, step, generativeTransformsWithIncludedCardinalFunction, cardinalFunctionIndex, @calculateTwoDimentionalCorrelant);
            
            resultOfApproximationWithIncludedCardinalFunction = approximate(generatedFunctionsSystem);
            
            efficiency = resultOfApproximationWithIncludedCardinalFunction.efficiency;
            expectedEfficiency = 1;
            assertElementsAlmostEqual(expectedEfficiency, efficiency, 'absolute', 1.0e-5);
        end
        
        function testSameSignalTemplateSize(self)
            import kunchenko.*;
            
            step = 1;
            template = [1 2; 3 4];
            signal = template;
            
            cardinalFunctionIndex = 2;
            
            generativeTransformsWithIncludedCardinalFunction{1} = @(x)x.^0;
            generativeTransformsWithIncludedCardinalFunction{2} = @(x)x.^1;
            generativeTransformsWithIncludedCardinalFunction{3} = @(x)x.^2;
            generativeTransformsWithIncludedCardinalFunction{4} = @(x)x.^3;
            generativeTransformsWithIncludedCardinalFunction{5} = @(x)x.^4;
            
            result = match(signal, template, step, generativeTransformsWithIncludedCardinalFunction, cardinalFunctionIndex, @calculateTwoDimentionalCorrelant);
            
            assertEqual(signal, result.signal);
            assertEqual(signal, result.polynomial);
            assertEqual(1, result.effectogram);
        end
        
        function testUsualMatch(self)
            import kunchenko.*;
            
            step = 1;
            template = [1 2 3; 4 5 6; 7 8 9];
            signal = [zeros(size(template))    template zeros(size(template));
                        template  zeros(size(template))   template];
            
            cardinalFunctionIndex = 2;
            generativeTransformsWithIncludedCardinalFunction{1} = @(x)x.^0;
            generativeTransformsWithIncludedCardinalFunction{2} = @(x)x.^1;
            generativeTransformsWithIncludedCardinalFunction{3} = @(x)x.^2;
            generativeTransformsWithIncludedCardinalFunction{4} = @(x)x.^3;
            
            result = match(signal, template, step, generativeTransformsWithIncludedCardinalFunction, cardinalFunctionIndex, @calculateTwoDimentionalCorrelant);           
            
            assertEqual(signal, result.signal);
            expectedEffectogram = [                0 0.333396735481965  0.625418936522053                  1  0.183846799849406 -0.0335441511860352                 0;
                                   0.977150794208955 0.266768314696275 -0.452287698704464 -0.734924186345712 -0.433867865495954 -0.0980886546624302 0.977150794208955;
                                   0.997454604229822 0.146562893155480 -0.351446717038112 -0.775272196414990 -0.773281446577738  0.698704175164629  0.997454604229822;
                                                   1 0.183846799849406 -0.0335441511860352                 0  0.333396735481965  0.625418936522053                  1];
            assertElementsAlmostEqual(expectedEffectogram, result.effectogram, 'absolute', 10e-5);
        end        

        function testBinaryUsualMatch(self)
            import kunchenko.*;
            
            step = 1;
            template = [1 0 0; 0 1 0; 0 0 1];
            filling = zeros(size(template));
            signal = [ filling  template   filling;
                       filling   filling   filling;
                      template   filling  template];
            
            cardinalFunctionIndex = 2;
            generativeTransformsWithIncludedCardinalFunction{1} = @(x)x.^0;
            generativeTransformsWithIncludedCardinalFunction{2} = @(x)x.^1;
            generativeTransformsWithIncludedCardinalFunction{3} = @(x)x.^2;
            generativeTransformsWithIncludedCardinalFunction{4} = @(x)x.^3;
            
            result = match(signal, template, step, generativeTransformsWithIncludedCardinalFunction, cardinalFunctionIndex, @calculateTwoDimentionalCorrelant);

            assertElementsAlmostEqual(1, result.effectogram(1, 4), 'absolute', 10e-5);
            assertElementsAlmostEqual(1, result.effectogram(7, 1), 'absolute', 10e-5);
            assertElementsAlmostEqual(1, result.effectogram(7, 7), 'absolute', 10e-5);
        end 
        
        % classic xUnit tear down
        function tearDown(self)
        end
        
        % util methods
    end
end

