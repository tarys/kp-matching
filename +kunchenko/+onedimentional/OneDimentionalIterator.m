classdef OneDimentionalIterator < kunchenko.AbstractIterator
    %ONEDIMENTIONALITERATOR provides iteration over 1D array
    
    methods
        % Create Iterator instance
        % INPUT:
        %   • array         - to iterate over
        %   • windowSize    - size of window 
        function obj = OneDimentionalIterator(array, windowSize)
            obj = obj@kunchenko.AbstractIterator(array, windowSize);
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
        
    end
    
end

