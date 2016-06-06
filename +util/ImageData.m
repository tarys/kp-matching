classdef ImageData < handle
    %Contains info about loaded image as class instance
    
    properties (SetAccess = private)
        path
        intensity
        colorMap
    end
    
    methods
        % Constructs ImageData object for image with given path
        % • fullImagePath   -   local full-qualified path or URL of image
        %                       to be loaded
        function instance = ImageData(fullImagePath)            
            [instance.intensity, instance.colorMap] = imread(fullImagePath);
            instance.path = fullImagePath;
        end
        
    end
    
end

