function [ X_opt, iter ] = algorithm_2(A, B, M, known,tol,max_iter,beta)
X = M;
W = X;
Y = X;
b = 12;
missing = ones(size(known)) -known;

k = 0; 
first_time = 1;
for i = 0:max_iter 
    temp = W -1/b *Y; 
    [U,S,V] = svd(temp);
    %disp(S);
    X = U * max(S - 1/beta, 0) * V';
    %disp (X);
    %step one ^
    %fprintf("disp X_1)");
    %disp(X_1);
    %ttep two ˇ
    W = X + 1/b* (A'*B +Y);
    
    % održimo
    % znane vrednosti da se ne pomučkajo
    W = W.*missing + M.*known;
    
    %step 3
    Y = Y + b* (X - W);

    k_next = norm(svd(X),1); - trace(A*W*B') ...
        + b / 2 * norm(X-W, 'fro')^2 + trace(Y'*(X-W));
    
    if first_time == 1
        first_time = 0;
    else
        if abs(k_next -k) < tol
            break;
        end
    end
    k = k_next;


end
iter = 10;
X_opt = X;