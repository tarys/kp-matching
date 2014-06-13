classdef AbstractIterator < handle
    %ITERATOR provides iteration over 1D array
    properties
        array
        windowsCount
    end
    
    properties(SetAccess = protected, GetAccess = public)        
        windowIndex
        windowSize
    end
    
    methods
        % Create Iterator instance
        % INPUT:
        %   • array        - to iterate over
        %   • windowSize    - size of window
        function obj = AbstractIterator(array, windowSize)
            obj.windowIndex = 0;
            obj.array = array;            
            obj.windowSize = windowSize;
        end
        
        % Returns "true" if more windows left
        function result = hasNext(self)
            result = self.windowIndex < self.windowsCount;
        end
        
        % Returns next window signal. If end of sigal is reached just returns last one on each further call
        function windowArray = next(self)
            if self.hasNext()
                self.windowIndex = self.windowIndex + 1;
            end
            windowArray = self.getWindow(self.windowIndex);
        end
        
        function setCurrentWindow(self, array)
            self.setWindow(self.windowIndex, array);
        end
    end
    
    methods(Abstract)
        windowArray = getWindow(self, index)        
        setWindow(self, index, array)        
    end
    
end
