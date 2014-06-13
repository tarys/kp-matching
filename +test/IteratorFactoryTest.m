classdef IteratorFactoryTest < TestCase
    %ITERATORFACTORYTEST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        % The first method in the methods block is the constructor.
        % It takes the desired test method name as its input argument,
        % and it passes that input along to the base class constructor
        function self = IteratorFactoryTest(name)
            self = self@TestCase(name);
        end
        
        % classic xUnit set up
        function setUp(self)
            
        end
        
        function testGetOneDimentionalIterator(self)
            signal = 1:10;
            template = [4 5 6];
            iterator = kunchenko.IteratorFactory.getIterator(signal, size(template));
            
            assertTrue(isa(iterator, 'kunchenko.onedimentional.OneDimentionalIterator'));
            assertFalse(isa(iterator, 'kunchenko.twodimentional.TwoDimentionalIterator'));
        end
        
        function testGetTwoDimentionalIterator(self)
            signal = [1:10; 11:20];
            template = [4 5 6; 7 8 9];
            iterator = kunchenko.IteratorFactory.getIterator(signal, size(template));
            
            assertFalse(isa(iterator, 'kunchenko.onedimentional.OneDimentionalIterator'));
            assertTrue(isa(iterator, 'kunchenko.twodimentional.TwoDimentionalIterator'));
        end
        end
    end
end

