% Create Iterator instance
% INPUT:
%   • array         - to iterate over
%   • windowSize    - size of window. For 1D it is just number that
%                     indicates length of window array. For 2D case it is matrix like
%                     this [rowNumber colNumber]
% OUTPUT:
%   • iterator      - instance of proper iterator class
function iterator = createIterator(array, windowSize)
    [signalRows ~] = size(array);
    windowRows = windowSize(1);
    windowCols = windowSize(2);
    if windowRows == 1 && signalRows == 1
        iterator = kunchenko.onedimentional.OneDimentionalIterator(array, windowCols);
    else
        iterator = kunchenko.twodimentional.TwoDimentionalIterator(array, windowSize);
    end
end
