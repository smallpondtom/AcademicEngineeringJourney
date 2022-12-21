function LP = lagrangePoints(mu)
%% Compute Lagrange point locations
% Yuri Shimane, 2022/02/15
% 

    l=1-mu;

    LP = zeros(5,3);
    


    %L1
    p_L1=[1, 2*(mu-l), l^2-4*l*mu+mu^2, 2*mu*l*(l-mu)+mu-l, mu^2*l^2+2*(l^2+mu^2), mu^3-l^3];
    L1roots=roots(p_L1);
    %initialize L1 for loop
    L1=0;
    for i=1:5
        if (L1roots(i) > -mu) && (L1roots(i) < l)
         L1=L1roots(i);
        end
    end
    LP(1,1) = L1;


    %L2
    p_L2=[1, 2*(mu-l), l^2-4*l*mu+mu^2, 2*mu*l*(l-mu)-(mu+l), mu^2*l^2+2*(l^2-mu^2), -(mu^3+l^3)];
    L2roots=roots(p_L2);
    %initialize L2 for loop
    L2=0;
    for i=1:5
        if (L2roots(i) > -mu) && (L2roots(i) > l)
            L2=L2roots(i);
        end
    end
    LP(2,1) = L2;

    
    %L3
    p_L3=[1, 2*(mu-l), l^2-4*mu*l+mu^2, 2*mu*l*(l-mu)+(l+mu), mu^2*l^2+2*(mu^2-l^2), l^3+mu^3];
    L3roots=roots(p_L3);
    %initialize L3 for loop
    L3=0;
    for i=1:5
        if L3roots(i) < -mu
            L3=L3roots(i);
        end
    end
    LP(3,1) = L3;

    
    %L4
    LP(4,1) = 0.5 - mu;
    LP(4,2) = sqrt(3)/2;


    %L5
    LP(5,1) = 0.5 - mu;
    LP(5,2) = -sqrt(3)/2;
