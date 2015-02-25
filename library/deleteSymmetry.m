function half_matrix_vector = deleteSymmetry(matrix)
%
%
n = size(matrix,1);
half_matrix_vector = zeros((n+1)*n/2,1);
k = 1;
for i=1:n
    for j=1:i
        half_matrix_vector(k) = matrix(i,j);
        k = k+1;
    end
    

end
    

end
