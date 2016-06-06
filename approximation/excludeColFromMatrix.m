function submatrix = excludeColFromMatrix(matrix, colNumber)
%EXCLUDECOLFROMMATRIX Summary of this function goes here
%   Detailed explanation goes here
    submatrix = excludeRowFromMatrix(matrix', colNumber)';
end

