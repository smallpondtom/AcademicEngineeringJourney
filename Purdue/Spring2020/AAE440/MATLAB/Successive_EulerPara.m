function e_new = Successive_EulerPara(e1, e2)
    
    e_v_1 = e1(1:3);
    e4_1 = e1(4);
    e_v_2 = e2(1:3);
    e4_2 = e2(4);
    
    % Calculate the successive epsilon 
    e_v_new = e_v_1*e4_2 + e_v_2*e4_1 + cross(e_v_2, e_v_1);
    e4_new = e4_1 * e4_2 - dot(e_v_1,e_v_2);
    e_new = [e_v_new e4_new];
    
end