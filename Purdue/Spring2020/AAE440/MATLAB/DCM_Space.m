function C_spa = DCM_Space(Rot1, Rot2, Rot3, theta1, theta2, theta3)
    
    C_spa = zeros([3,3]);
    C = zeros([3,3,3]);
    
    % Determining DCM for the 1st Rotation
    if Rot1 == 1
        % DCM for rotation about axis 1
        C(:,:,1) = [ 1            0             0;
                     0  cos(theta1)  -sin(theta1);
                     0  sin(theta1)   cos(theta1)];
    elseif Rot1 == 2
        % DCM for rotation about axis 2
        C(:,:,1) = [ cos(theta1)  0   sin(theta1);
                               0  1             0;
                    -sin(theta1)  0   cos(theta1)];
    else % Rot1 == 3
        % DCM for rotation about axis 3
        C(:,:,1) = [ cos(theta1)  -sin(theta1)  0;
                     sin(theta1)   cos(theta1)  0;
                               0             0  1];
    end
        
    % Determining DCM for the 2nd Rotation
    if Rot2 == 1
        lambda2 = [1 0 0]*C(:,:,1);
    elseif Rot2 == 2
        lambda2 = [0 1 0]*C(:,:,1);
    else % Rot2 == 3
        lambda2 = [0 0 1]*C(:,:,1);
    end
    
    % Generating DCM from Euler Axis and Euler Angles
    C(:,:,2) = DCM_from_EulerAxisAng(lambda2, theta2); 
    
    % Determining DCM for the 3rd Rotation
    if Rot3 == 1
        lambda3 = [1 0 0]*C(:,:,1)*C(:,:,2);
    elseif Rot3 == 2
        lambda3 = [0 1 0]*C(:,:,1)*C(:,:,2);
    else % Rot3
        lambda3 = [0 0 1]*C(:,:,1)*C(:,:,2);
    end
    
    % Generating DCM from Euler Axis and Euler Angles
    C(:,:,3) = DCM_from_EulerAxisAng(lambda3, theta3);
    
    C_spa  =  C(:,:,1)*C(:,:,2)*C(:,:,3);
    
end