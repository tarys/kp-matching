classdef TwoDimentionalIteratorTest < TestCase
    %TWODIMENTIONALITERATORTEST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        signal
        iterator
        windowWidth
        windowHeight
    end
    
    methods
        % The first method in the methods block is the constructor.
        % It takes the desired test method name as its input argument,
        % and it passes that input along to the base class constructor
        function self = TwoDimentionalIteratorTest(name)
            self = self@TestCase(name);
        end
        
        % classic xUnit set up
        function setUp(self)
            self.signal = [1 2 3; 4 5 6; 7 8 9];
            self.windowWidth = 2;
            self.windowHeight = 2;
            self.iterator = kunchenko.twodimentional.TwoDimentionalIterator(self.signal, [self.windowWidth self.windowHeight]);                                    
        end
        
        function testHasNextFalse(self)
            customIterator = kunchenko.twodimentional.TwoDimentionalIterator(self.signal, size(self.signal));
            
            assertTrue(customIterator.hasNext());
            window = customIterator.next();
            assertEqual(self.signal, window);
            assertFalse(customIterator.hasNext());
        end
        
        function testHasNextTrue(self)
            % 1st iteration window must be [1 2; 4 5]
            assertTrue(self.iterator.hasNext());
            window = self.iterator.next();
            assertEqual(self.signal(1:2, 1:2), window);
            
            % 2nd iteration window must be [2 3; 5 6]
            assertTrue(self.iterator.hasNext());
            window = self.iterator.next();
            assertEqual(self.signal(1:2, 2:3), window);
            
            % 3d iteration window must be [4 5; 7 8]
            assertTrue(self.iterator.hasNext());
            window = self.iterator.next();
            assertEqual(self.signal(2:3, 1:2), window);
            
            % 4th iteration window must be [5 6; 8 9]
            assertTrue(self.iterator.hasNext());
            window = self.iterator.next();
            assertEqual(self.signal(2:3, 2:3), window);
            
            % now nothing left to iterate over, returns last window
            assertFalse(self.iterator.hasNext());
            window = self.iterator.next();
            assertEqual(self.signal(2:3, 2:3), window);
        end
        
        function testMapWindowIndecies(self)
            assertEqual(self.signal(1:2, 1:2), self.iterator.getWindow(1));
            assertEqual(self.signal(1:2, 2:3), self.iterator.getWindow(2));
            assertEqual(self.signal(2:3, 1:2), self.iterator.getWindow(3));
            assertEqual(self.signal(2:3, 2:3), self.iterator.getWindow(4));
            
        end
        
        function testCalculateWindowsCount(self)
            assertEqual(4, self.iterator.windowsCount);
        end
        
        function testSetWindow(self)
            assertEqual(self.signal(2:3, 1:2), self.iterator.getWindow(3));
            newWindow = [100 200; 300 400];
            self.iterator.setWindow(3, newWindow);
            assertEqual(self.iterator.getWindow(3), newWindow);
        end
        
        % classic xUnit tear down
        function tearDown(self)
        end
    end
end

