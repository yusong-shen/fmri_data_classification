function half_matrix_vector = deleteSymmetry(matrix)
%
% Example.
% B =
% 
%     1.0000   -0.7559    0.1429
%    -0.7559    1.0000   -0.7559
%     0.1429   -0.7559    1.0000
% deleteSymmetry(B)
% 
% ans =
% 
%    -0.7559
%     0.1429
%    -0.7559    

n = size(matrix,1);
half_matrix_vector = zeros((n-1)*n/2,1);
k = 1;
for i=2:n
    for j=1:i-1
        half_matrix_vector(k) = matrix(i,j);
        k = k+1;
    end
    

end
    

end
