function epsilons = EulerPara_from_DCM(C_mat)

    epsilon4 = 0.5*sqrt(1+C_mat(1,1)+C_mat(2,2)+C_mat(3,3));
    epsilon1 = (C_mat(3,2)-C_mat(2,3))/4/epsilon4;
    epsilon2 = (C_mat(1,3)-C_mat(3,1))/4/epsilon4;
    epsilon3 = (C_mat(2,1)-C_mat(1,2))/4/epsilon4;
    epsilons = [epsilon1 epsilon2 epsilon3 epsilon4];
    
end