function C_mat = DCM_from_EulerAxisAng(lambdas, theta)

    % Euler Axis
    lambda1 = lambdas(1);
    lambda2 = lambdas(2);
    lambda3 = lambdas(3);
    
    % Calculating DCM from Euler Axis and Euler Angle 
    C11 = cos(theta) + lambda1^2*(1-cos(theta));
    C12 = -lambda3*sin(theta) + lambda1*lambda2*(1-cos(theta));
    C13 = lambda2*sin(theta) + lambda3*lambda1*(1-cos(theta));
    C21 = lambda3*sin(theta) + lambda1*lambda2*(1-cos(theta));
    C22 = cos(theta) + lambda2^2*(1-cos(theta));
    C23 = -lambda1*sin(theta) + lambda2*lambda3*(1-cos(theta));
    C31 = -lambda2*sin(theta) + lambda3*lambda1*(1-cos(theta));
    C32 = lambda1*sin(theta) + lambda2*lambda3*(1-cos(theta));
    C33 = cos(theta) + lambda3^2*(1-cos(theta));
    
    C_mat = [C11 C12 C13; C21 C22 C23; C31 C32 C33];
    
end
