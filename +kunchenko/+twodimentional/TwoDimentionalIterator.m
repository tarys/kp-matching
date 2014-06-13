classdef TwoDimentionalIterator < kunchenko.AbstractIterator
    %TWODIMENTIONALITERATOR provides iteration over 2D input array
    properties
        windowHeight
        windowWidth
        windowIndecies
    end
    
    methods
        % Create TwoDimentionalIterator instance
        % INPUT:
        %   • array        - to iterate over
        function obj = TwoDimentionalIterator(array, windowSize)
            obj = obj@kunchenko.AbstractIterator(array, windowSize);
            obj.windowHeight = obj.windowSize(1);
            obj.windowWidth = obj.windowSize(2);
            obj.windowsCount = obj.calculateWindowsCount();
            obj.mapWindowIndecies();
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
