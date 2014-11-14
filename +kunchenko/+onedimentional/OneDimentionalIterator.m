classdef OneDimentionalIterator < handle
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
        %   • array         - to iterate over
        %   • windowSize    - size of window 
        function obj = OneDimentionalIterator(array, windowSize)
            obj.windowIndex = 0;
            obj.array = array;            
            obj.windowSize = windowSize;
            obj.windowsCount = length(array) - windowSize + 1;
        end
        
        function windowArray = getWindow(self, index)
           windowArray = self.array(index :(index + self.windowSize - 1));
        end
        
        function setWindow(self, index, array)
            self.array(index : index  + self.windowSize - 1) = array;
        end
        
        function setCurrentWindow(self, array)
            self.setWindow(self.windowIndex, array);
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
 
    end
    
end

