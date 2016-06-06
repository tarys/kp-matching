classdef ImageDataTest < TestCase
    properties
        image
    end
    
    methods
        % The first method in the methods block is the constructor.
        % It takes the desired test method name as its input argument,
        % and it passes that input along to the base class constructor
        function self = ImageDataTest(name)
            self = self@TestCase(name);
        end
        
        % classic xUnit set up
        function setUp(self)
            self.image = util.ImageData('D:\documents\MATLAB\kunchenko-polynomials\ObjectOrientedVersion\circle.bmp');
        end
        
        function testImageData(self)
            assertTrue(isa(self.image, 'util.ImageData'));
        end
        
        % classic xUnit tear down
        function tearDown(self)
            delete(self.image);
        end
    end
end
