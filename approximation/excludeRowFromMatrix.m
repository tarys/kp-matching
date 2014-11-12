function submatrix = excludeRowFromMatrix(matrix, rowNumber)
%EXCLUDEROWFROMMATRIX Summary of this function goes here
%   Detailed explanation goes here
    submatrix = [matrix(1:(rowNumber - 1), :); matrix((rowNumber + 1):end, :)];
end

