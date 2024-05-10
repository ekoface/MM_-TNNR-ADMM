
M =...
    [0 1 0.5 3;
    0.5 2 3 0.5;
    1 0.5 1 1;
    2 1 5 0.5];
known = ...
    [1 1 0 1;
    0 1 1 0;
    1 0 1 1 ;
    1 1 1 0];
max_iter  =1000;
tol = 10e-6;

r = 3;

beta = 1/(5*10e-3);
X = algorithm_1(M, known, tol, r, max_iter,beta);
disp(X);


disp(rank(M));
disp(rank(X));