function [X] = algorithm_pic(M, known, tol, r, max_iter, beta, n)
%
% This algorithm is for restoring pictures, dividing the picture into 16 x 16 squares
% on which algorithm_2 is run.
%

    M = double(M);
    sz = size(M); 
    n = sz(1);
    k = sz(2);
    X = zeros(n, k);
    X_it = zeros(n,k);
    [U_or, S_or, V_or] = svd(M);
    sum_or = trace(S_or);
    
    % Initialize a matrix to store the sum of unknown values for each pixel
    sum_unknown = zeros(size(known));
    
    % Iterate through the image in 16x16 blocks
    block_size = 16;
    step = 8; % Move 8 pixels at a time
    for y = 1:step:n-block_size+1
        disp(y);
        for x = 1:step:k-block_size+1
            % If you want to skip blocks based on the known mask, you can add that check here
            
            % Extract the current 16x16 block
            block_M = M(y:y+block_size-1, x:x+block_size-1);
            block_known = known(y:y+block_size-1, x:x+block_size-1);
            
            % Initialize Y and W for the block
            block_Y = block_M;
            block_W = block_M;
            
            % Initialize block_X before entering the loop
            block_X = zeros(block_size, block_size);
            
            % Initialize a matrix to count the number of iterations for each pixel
            count_unknown = zeros(size(block_known));
            
            for i = 0:10
                
                % Step 1: Singular Value Decomposition (SVD)
                [U, S, V] = svd(block_W - block_Y / beta);
                A = U(:,1:r)';
                B = V(:,1:r)';
                
                % Run algorithm_2 on the current block
                block_X_temp = algorithm_2(A, B, block_M, block_known, tol, max_iter, beta);
                
                % Stopping criteria
                TOLL = norm(block_X - block_X_temp,'fro') / norm(block_X,'fro');
                if TOLL <= tol
                    break;
                end
                
                % Update block_X for the next iteration
                block_X = block_X_temp;
                
                % Update sum_unknown and count_unknown for unknown entries
                unknown_mask = ~block_known;
                
                count_unknown = count_unknown + unknown_mask;
            end
            
            % Compute the average of unknown values for each pixel
            % Check for zero values in count_unknown to avoid division by zero
            average_unknown = sum_unknown;
            count_mask = (count_unknown > 0);
            average_unknown(count_mask) = sum_unknown(count_mask) ./ count_unknown(count_mask);
            
            % Place the result back into the X matrix
            X(y:y+block_size-1, x:x+block_size-1) = average_unknown(y:y+block_size-1, x:x+block_size-1);
            X_it(y:y+block_size-1, x:x+block_size-1) = block_X_temp;
        end
    end
end
