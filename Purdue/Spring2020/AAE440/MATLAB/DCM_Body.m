function C_body = DCM_Body(Rot1, Rot2, Rot3, theta1, theta2, theta3)
    
    Rot = [Rot1, Rot2, Rot3];
    theta = [theta1, theta2, theta3]; % radians
    C_body = zeros([3,3]);
    C = zeros([3,3,3]);
    
    for i=1:3
        
        if Rot(i) == 1
            % DCM for rotation about axis 1
            C(:,:,i) = [ 1              0               0;
                         0  cos(theta(i))  -sin(theta(i));
                         0  sin(theta(i))   cos(theta(i))];
        elseif Rot(i) == 2
            % DCM for rotation about axis 2
            C(:,:,i) = [ cos(theta(i))  0   sin(theta(i));
                                     0  1               0;
                        -sin(theta(i))  0   cos(theta(i))];
        else
            % DCM for rotation about axis 3
            C(:,:,i) = [ cos(theta(i))  -sin(theta(i))  0;
                         sin(theta(i))   cos(theta(i))  0;
                                     0               0  1];
        end
    end
    C_body  =  C(:,:,1)*C(:,:,2)*C(:,:,3);
    
end
