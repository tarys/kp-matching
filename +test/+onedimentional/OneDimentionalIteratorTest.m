classdef OneDimentionalIteratorTest < TestCase
    %ONEDIMENTIONALITERATORTEST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        template
        iterator
    end
    
    methods
        % The first method in the methods block is the constructor.
        % It takes the desired test method name as its input argument,
        % and it passes that input along to the base class constructor
        function self = OneDimentionalIteratorTest(name)
            self = self@TestCase(name);
        end
        % classic xUnit set up
        function setUp(self)
            import kunchenko.*;
            
            step = .01;
            [~, self.template] = template1(step);
            zeroPattern = zeros(1, length(self.template));
            signal = [zeroPattern self.template zeroPattern -self.template zeroPattern self.template zeroPattern];
            
            self.iterator = createIterator(signal, size(self.template));
        end
        
        function testGetWindowArraysCount(self)
            windowsCount =self.iterator.windowsCount;
            for windowIndex = 1:windowsCount
                windowArray = self.iterator.getWindow(windowIndex);
                assertEqual(length(self.template), length(windowArray));
            end
        end
        
        function testSetWindowArray(self)
           windowIndex = 3;
           self.iterator.setWindow(windowIndex, self.template);
           assertEqual(self.template, self.iterator.getWindow(windowIndex));
        end
    end
    
end

