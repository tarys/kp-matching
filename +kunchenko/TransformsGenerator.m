classdef TransformsGenerator
    %TRANSFORMSGENERATOR constructs generated functions cell-array
    
    
    methods(Static)
        
        function generativeTransforms = generate(varargin)
            % INPUT:
            %  • type                               -   string represents type of function's system.
            %                                           can be one of following values:
            %                                           'int', 'invertInt', 'exp', 'sin'
            %  • count                              -   number of functions in system
            %  • includeCardinalFunction(optional)  -   whether include cardinal
            %                                           function to generative transforms. FALSE by default.
            %  • cardinalFunctionIndex(optional)    -   if includeCardinalFunction =
            %                                           true, this parameter specifies
            %                                           index of function to be cardinal
            %
            % OUTPUT:
            %  • generativeTransforms   -   cell-array of generative functions' handles
            %                               formed according to specified type consists of
            %                               "count" number of functions.
            type = varargin{1};
            count = varargin{2};
            generativeTransforms = cell(1, count);
            for i = 1:count
                switch type
                    case 'int'
                        generativeTransforms{i}= @(x)x.^(i-1);
                    case 'invertInt'
                        if i == 1
                            generativeTransforms{i} = @(x)x.^0;
                        else
                            generativeTransforms{i} = @(x)x.^(1/(i-1));
                        end
                    case 'exp'
                        generativeTransforms{i} = @(x)exp((i-1)*x);
                    case 'sin'
                        generativeTransforms{i} = @(x)sin(0.5*pi*x).^(i-1);
                    otherwise
                        err = MException('SwitchChk:NoSuchCase', ...
                            'No such case for switch parameter');
                        throw(err);
                end;
            end
        end
        
    end
end
