function res = checkObservability(A, C)
    dim = size(A); n = dim(1);
    Qo = obsv(A, C);
    res.check = rank(Qo) == n;
    res.Qo = Qo;
end