classdef TwoDimentionalIterator < handle
    %TWODIMENTIONALITERATOR provides iteration over 2D input array
    properties
        array
        windowsCount
        windowHeight
        windowWidth
        windowIndecies
    end
    
    properties(SetAccess = protected, GetAccess = public)        
        windowIndex
        windowSize
    end
    
    methods
        % Create TwoDimentionalIterator instance
        % INPUT:
        %   • array        - to iterate over
        function obj = TwoDimentionalIterator(array, windowSize)
            obj.windowIndex = 0;
            obj.array = array;            
            obj.windowSize = windowSize;
            
            obj.windowHeight = obj.windowSize(1);
            obj.windowWidth = obj.windowSize(2);
            obj.windowsCount = obj.calculateWindowsCount();
            obj.mapWindowIndecies();
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

        
        function windowArray = getWindow(self, index)
            rowIndex = self.windowIndecies(index, 1);
            colIndex = self.windowIndecies(index, 2);
            windowArray = self.array(rowIndex : (rowIndex + self.windowHeight - 1), colIndex : (colIndex + self.windowWidth - 1));
        end
        
        function setWindow(self, index, array)
            rowIndex = self.windowIndecies(index, 1);
            colIndex = self.windowIndecies(index, 2);
            self.array(rowIndex : (rowIndex + self.windowHeight - 1), colIndex : (colIndex + self.windowWidth - 1)) = array;
        end
    end
    
    methods(Access = private)
        function windowsCount = calculateWindowsCount(self)
            [rowNumber, colNumber] = size(self.array);
            windowsCount = (rowNumber - self.windowWidth + 1) * (colNumber - self.windowHeight + 1);
        end
        
        function mapWindowIndecies(self)
            [~, colNumber] = size(self.array);
            self.windowIndecies = zeros(self.windowsCount, 2);
            rowIndex = 1;
            colIndex = 0;

            for i = 1:self.windowsCount
                if (colIndex == (colNumber - self.windowWidth + 1))
                    % moving to next row
                    colIndex = 1;
                    rowIndex = rowIndex + 1;
                else
                    colIndex = colIndex + 1;
                end
                self.windowIndecies(i, :) = [rowIndex colIndex];
            end

        end
    end
end
