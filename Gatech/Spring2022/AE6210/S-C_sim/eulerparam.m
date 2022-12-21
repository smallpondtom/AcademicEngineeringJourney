syms omega_1 omega_2 omega_3 q Omega real 
syms epsilon_1 epsilon_2 epsilon_3 epsilon_4 real

omega_AC = [
    omega_1 - 2*Omega*(epsilon_1*epsilon_2+epsilon_3*epsilon_4);
    omega_2 - q - Omega*(1-2*epsilon_3^2-2*epsilon_1^2);
    omega_3 - 2*Omega*(epsilon_2*epsilon_3-epsilon_1*epsilon_4);
    0
];

E = [ epsilon_4, -epsilon_3,  epsilon_2,  epsilon_1;
      epsilon_3,  epsilon_4, -epsilon_1,  epsilon_2;
     -epsilon_2,  epsilon_1,  epsilon_4,  epsilon_3;
     -epsilon_1, -epsilon_2, -epsilon_3,  epsilon_4];

d = omega_AC'*E'/2;
d_simp = simplify(expand(d));
d_simp(1)
d_simp(2)
d_simp(3)
d_simp(4)