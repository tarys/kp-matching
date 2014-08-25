classdef Kunchenko1DTemplateMatcherTest < TestCase
    %KUNCHENKORECOGNIZERTEST 1D recognition implementation tests
    
    properties
        step
        generativeTransforms
        template
        signal
        matcher
    end
    
    methods
        % The first method in the methods block is the constructor.
        % It takes the desired test method name as its input argument,
        % and it passes that input along to the base class constructor
        function self = Kunchenko1DTemplateMatcherTest(name)
            self = self@TestCase(name);
        end
        
        % classic xUnit set up
        function setUp(self)
            import kunchenko.*;
            
            self.step = .1;
            [~, self.template] = template1(self.step);
            zeroPattern = zeros(1, length(self.template));
            self.signal = [zeroPattern self.template zeroPattern -self.template zeroPattern self.template zeroPattern];
            
            cardinalFunctionIndex = 2;
            self.generativeTransforms = TransformsGenerator.generate('int', 4);
            calculateCorrelantFunction = @calculateOneDimentionalCorrelant;
            generatedFunctionsSystem = GeneratedFunctionsSystem.build(self.template, self.step, self.generativeTransforms, cardinalFunctionIndex, calculateCorrelantFunction);            
            self.matcher = KunchenkoTemplateMatcher(self.signal, generatedFunctionsSystem);
        end
        
        function testCompareOOPAndProceduralRecognition(self)
            tic;
            
            oopRecognitionResult = self.matcher.match();
            
            oopElapsed = toc;
            
            tic;
            
            [polynomial, ~, effectogram] = KunchenkoNew(self.signal, self.template, self.generativeTransforms);
            proceduralRecognitionResult.signal = self.signal;
            proceduralRecognitionResult.polynomial = polynomial;
            proceduralRecognitionResult.effectogram = effectogram;
            
            proceduralElapsed = toc;
            
            display([oopElapsed proceduralElapsed]);
            
            test.onedimentional.Kunchenko1DTemplateMatcherTest.plotRecognitionResults(oopRecognitionResult, proceduralRecognitionResult);
            
            absoluteTolerance = 10e-5;
            assertElementsAlmostEqual(proceduralRecognitionResult.polynomial, oopRecognitionResult.polynomial, 'absolute', absoluteTolerance);
            assertElementsAlmostEqual(proceduralRecognitionResult.effectogram, oopRecognitionResult.effectogram, 'absolute', absoluteTolerance);
        end
        
        % classic xUnit tear down
        function tearDown(self)
            self.template = [];
            self.signal = [];
        end
        
        % util methods
    end
    
    methods(Static)
        function plotRecognitionResults(oopRecognitionResult, proceduralRecognitionResult)
            figure('Color','white');
            subplot(5, 1, 1);
            plot(oopRecognitionResult.signal, '-.k');
            axis([0 length(oopRecognitionResult.signal) min(oopRecognitionResult.signal) max(oopRecognitionResult.signal)]);
            legend('Вихідний сигнал');
            grid on;
            
            subplot(5, 1, 2);
            plot(oopRecognitionResult.polynomial, '-k');
            hold on;
            plot(oopRecognitionResult.effectogram, '--k');
            axis([0 length(oopRecognitionResult.polynomial)  min(oopRecognitionResult.polynomial) max(oopRecognitionResult.polynomial)]);
            legend('Апроксимація ОО підходу', 'Ефектограма ОО підходу');
            grid on;
            
            subplot(5, 1, 3);
            plot(proceduralRecognitionResult.polynomial, '-k');
            hold on;
            plot(proceduralRecognitionResult.effectogram, '--k');
            axis([0 length(proceduralRecognitionResult.polynomial)  min(proceduralRecognitionResult.polynomial) max(proceduralRecognitionResult.polynomial)]);
            legend('Апроксимація процедурного підходу', 'Ефектограма процедурного підходу');
            grid on;
            
            subplot(5, 1, 4);
            plot(abs(oopRecognitionResult.polynomial - proceduralRecognitionResult.polynomial), '-k');
            axis([0 length(proceduralRecognitionResult.polynomial)  min(proceduralRecognitionResult.polynomial) max(proceduralRecognitionResult.polynomial)]);
            legend('Абсолютна різниця апроксимацій');
            grid on;
            
            subplot(5, 1, 5);
            plot(abs(oopRecognitionResult.effectogram - proceduralRecognitionResult.effectogram), '-k');
            axis([0 length(proceduralRecognitionResult.effectogram)  min(proceduralRecognitionResult.effectogram) max(proceduralRecognitionResult.effectogram)]);
            legend('Абсолютна різниця ефектограм');
            grid on;
        end
    end
    
end

