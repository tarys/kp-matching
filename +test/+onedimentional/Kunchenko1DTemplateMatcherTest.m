classdef Kunchenko1DTemplateMatcherTest < TestCase
    %KUNCHENKORECOGNIZERTEST 1D recognition implementation tests
    
    methods
        % The first method in the methods block is the constructor.
        % It takes the desired test method name as its input argument,
        % and it passes that input along to the base class constructor
        function self = Kunchenko1DTemplateMatcherTest(name)
            self = self@TestCase(name);
        end
        
        % classic xUnit set up
        function setUp(self)
        end
        
        function testCompareOOPAndProceduralRecognition(self)
            step = .1;
            [~, template] = template1(step);
            zeroPattern = zeros(1, length(template));
            signal = [zeroPattern template zeroPattern -template zeroPattern template zeroPattern];
            
            cardinalFunctionIndex = 2;
            generativeTransforms = generateGenerativeTransforms('int', 4);
            calculateCorrelantFunction = @calculateOneDimentionalCorrelant;

            
            tic;

            oopRecognitionResult = match(...
                signal, ...
                template, ...
                step, ...
                generativeTransforms, ...
                cardinalFunctionIndex, ...
                calculateCorrelantFunction);
            
            oopElapsed = toc;
            
            tic;
            
            [polynomial, ~, effectogram] = KunchenkoNew(signal, template, generativeTransforms);
            proceduralRecognitionResult.signal = signal;
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
        end
        
        % util methods
    end
    
    methods(Static)
        function plotRecognitionResults(oopRecognitionResult, proceduralRecognitionResult)
            figure('Color','white');
            subplot(5, 1, 1);
            plot(oopRecognitionResult.signal, '-.k');
            axis([0 length(oopRecognitionResult.signal) min(oopRecognitionResult.signal) max(oopRecognitionResult.signal)]);
            legend('�������� ������');
            grid on;
            
            subplot(5, 1, 2);
            plot(oopRecognitionResult.polynomial, '-k');
            hold on;
            plot(oopRecognitionResult.effectogram, '--k');
            axis([0 length(oopRecognitionResult.polynomial)  min(oopRecognitionResult.polynomial) max(oopRecognitionResult.polynomial)]);
            legend('������������ �� ������', '����������� �� ������');
            grid on;
            
            subplot(5, 1, 3);
            plot(proceduralRecognitionResult.polynomial, '-k');
            hold on;
            plot(proceduralRecognitionResult.effectogram, '--k');
            axis([0 length(proceduralRecognitionResult.polynomial)  min(proceduralRecognitionResult.polynomial) max(proceduralRecognitionResult.polynomial)]);
            legend('������������ ������������ ������', '����������� ������������ ������');
            grid on;
            
            subplot(5, 1, 4);
            plot(abs(oopRecognitionResult.polynomial - proceduralRecognitionResult.polynomial), '-k');
            axis([0 length(proceduralRecognitionResult.polynomial)  min(proceduralRecognitionResult.polynomial) max(proceduralRecognitionResult.polynomial)]);
            legend('��������� ������ ������������');
            grid on;
            
            subplot(5, 1, 5);
            plot(abs(oopRecognitionResult.effectogram - proceduralRecognitionResult.effectogram), '-k');
            axis([0 length(proceduralRecognitionResult.effectogram)  min(proceduralRecognitionResult.effectogram) max(proceduralRecognitionResult.effectogram)]);
            legend('��������� ������ ����������');
            grid on;
        end
    end
    
end

