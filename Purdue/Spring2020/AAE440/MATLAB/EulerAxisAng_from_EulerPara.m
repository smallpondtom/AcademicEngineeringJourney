function [lambda, theta] = EulerAxisAng_from_EulerPara(epsilons)
 
    e_vec = epsilons(1:3); 
    e4 = epsilons(4);
    
    % Compute Euler Axis and Euler Angle
    lambda = e_vec / sqrt(sum(e_vec.^2));
    theta = 2*acos(e4);
    
end