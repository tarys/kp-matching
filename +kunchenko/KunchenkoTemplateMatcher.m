classdef KunchenkoTemplateMatcher < handle
    %KUNCHENKORECOGNIZER 1D template recognizer using Kunchenko's polynomials approach
    
     properties(Access = private)        
        generatedFunctionsSystem
        signalIterator
        polynomialIterator
        temporaryEfficiencyIterator
        effectogramIterator
    end
    
    methods
        function obj = KunchenkoTemplateMatcher(signal, generatedFunctionsSystem)
            import kunchenko.IteratorFactory;
            signalSize = size(signal);
            templateSize = size(generatedFunctionsSystem.domain);
            
            obj.generatedFunctionsSystem = generatedFunctionsSystem;            
            obj.signalIterator = kunchenko.IteratorFactory.getIterator(signal, templateSize);            
            obj.effectogramIterator = kunchenko.IteratorFactory.getIterator(zeros(signalSize - templateSize + 1), size(1));            
            obj.polynomialIterator = kunchenko.IteratorFactory.getIterator(zeros(signalSize), templateSize);
            obj.temporaryEfficiencyIterator = kunchenko.IteratorFactory.getIterator(zeros(signalSize), templateSize);           
        end
    end
    
    methods
        % Perform template matching for given in constructor params
        % OUTPUT:
        %   • matchingResult - structure with following fields:
        %                           • signal      - input signal to be approximated
        %                           • polynomial  - resulting polynomial approximation
        %                           • effectogram - resulting effectogram of approximation
        function matchingResult = match(self)
            while self.signalIterator.hasNext() && self.polynomialIterator.hasNext() && self.effectogramIterator.hasNext()                    
                windowSignal = self.signalIterator.next();
                windowEfficiency = self.temporaryEfficiencyIterator.next();
                windowPolynomial = self.polynomialIterator.next();
                
                approximationResult = self.approximateWindowSignal(windowSignal);
                
                self.effectogramIterator.next();
                self.effectogramIterator.setCurrentWindow(approximationResult.efficiency);
                
                replacementIndecies = abs(approximationResult.efficiency) >= abs(windowEfficiency);                
                
                windowPolynomial(replacementIndecies) = approximationResult.polynomial(replacementIndecies);
                self.polynomialIterator.setCurrentWindow(windowPolynomial);                
                
                windowEfficiency(replacementIndecies) = approximationResult.efficiency;
                self.temporaryEfficiencyIterator.setCurrentWindow(windowEfficiency);
            end
            
            matchingResult.signal = self.signalIterator.array;
            matchingResult.polynomial = self.polynomialIterator.array;
            matchingResult.effectogram = self.effectogramIterator.array;
        end
    end
    
    methods(Access = private)
        % Approximate given window signal with Kunchenko's algorithm
        % INPUT:
        %   • windowSignal  - window signal to be approximated        
        % OUTPUT:
        %   • result        - structure with following fields:
        %                                • polynomial  - resulting polynomial approximation
        %                                • effectogram - resulting effectogram of approximation    
        function result = approximateWindowSignal(self, windowSignal)
            functions = self.generatedFunctionsSystem;
            functions.insert(windowSignal, self.generatedFunctionsSystem.cardinalFunctionIndex);
            result = approximate(functions);
            functions.remove(self.generatedFunctionsSystem.cardinalFunctionIndex);
        end

    end
    
end

