function [X] = algorithm_1(M, known, tol, r, max_iter,beta)
    % Original incomplete data matrix M, positions K, and tolerance tol
    M = double(M);
    % Initialize X1 = P_omega(M)
    sz = size(M); 
    n = sz(1);
    k = sz(2);

    %Initialize
    X = zeros(n, k);

    for i = 1:n
        for j = 1:k
            if known(i, j) == 1
                X(i, j) = M(i, j);
            end
        end 
    end
  
    
    % Main iteration loop
    for i = 0: 10
        % Step 1: Singular Value Decomposition (SVD)
        disp(i);
        [U, S, V] = svd(X); % samo do r singularnih svds
        %disp(U*S*V');
        A = U(:,1:r)'; %morda ni treba rezat
        B = V(:,1:r)';
        


        X_temp = algorithm_2(A, B, M, known,tol,max_iter,beta);
        % Stopping criteria
        TOLL = norm(X-X_temp,'fro')/norm(X,'fro');
        if TOLL<=tol
            break;
        end 
        % Update X_1 for the next iteration
       
    end

    % Return the recovered matrix
    X = X_temp;
    disp(X);
end
