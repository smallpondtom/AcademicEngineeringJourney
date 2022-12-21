%
% Program to solve Zermelo’s problem with state constraint
% using bvp4c (icase=1 - no constraint) or
% fsolve/ode45 (icase=2 - no constraint) or
% fsolve/ode45 (icase=3 - with state constraint)
% Assume V = 1, u = -y, v = 0
% Author: P. Tsiotras 11/18/2001
%
function zermeloBVP
    format compact; clear all; close all; clc;
    global x0 xf tf icase
    
    % problem data
    x0 = [0.5 -1]; xf = [0 0];
    options = bvpset('RelTol',1e-5,'AbsTol',1e-6,'Stats','on','Nmax',500);
    exec = 1; % do/do not execute optimization step (1/0)
    icase = 1; % choose method to solve the problem
    switch icase
        case 1 % start case 1: Zermelo problem without constraint - use of bvp4c
        
            iarc = 0; % used to specify control law
            % initial guesses
            tf = 1.5;
            if  ~exist('sol')
                yinit = [x0(1) x0(2) -1 +2 tf];
                solinit=bvpinit([0 0.5 1],yinit);
            else
                solinit=bvpinit(sol,[0 1]);
            end
    
            if exec==1
                disp('...calculating trajectory...')
                sol = bvp4c(@fcneom,@bcfun,solinit,options,iarc);
                T = linspace(0,1,200);
                xopt=deval(sol,T); xopt=xopt';
            else
                % calculate whole trajectory
                xic = solinit.y(1:5,1);
                disp('...calculating trajectory with initial conditions...')
                [T,xopt]=ode45(@fcneom,[0,1],xic,[],iarc);
            end
            % store trajectory
            T = T*xopt(1,5);
            theta=atan2(xopt(:,4),xopt(:,3));
            ham=xopt(:,3).*(cos(theta)-xopt(:,2))+xopt(:,4).*(sin(theta))-1;
        % end of case 
    
        case 2 % start case 2: Zermelo problem without constraint - use of fsolve/ode45
            % initial guesses
            tf = 1.5;lamx = -1; lamy = +2;
            if exec==1
                disp('..calculating trajectory...')
                guess = [tf;lamx;lamy];
                optslv = optimset('TolX',0.001,'TolFun',0.001,'Display','off','MaxIter',500);
                xout = fsolve(@fcnzermc,guess,optslv);
                tf = xout(1); lamx = xout(2); lamy = xout(3);
            end
        
            % first arc (iarc=0)
            [T,xopt]=ode45(@fcneom,[0,1],[x0;lamx;lamy;tf],[],0);
            T=T*xopt(1,5);
            theta=atan2(xopt(:,4),xopt(:,3));
            ham=xopt(:,3).*(cos(theta)-xopt(:,2))+xopt(:,4).*(sin(theta))-1;
        % end of case 2
    
        case 3 % start case 3: Zermelo problem with state constraint
            % initial guesses
            tf = 1.6;
            t1 = 0.2;t2 = 0.35;lamx =-2;lamy = 2.25;pic = -1;
            if exec==1
                disp(' calculating trajectory...')
                guess = [tf;t1;t2;lamx;lamy;pic];
                optslv = optimset('TolX',0.001,'TolFun',0.001,'Display','off','MaxIter',500);
                xout = fsolve(@fcnzermc,guess,optslv)
                tf = xout(1); t1 = xout(2); t2 = xout(3);
                lamx = xout(4); lamy = xout(5); pic = xout(6);
            end
            % calculate whole trajectory
            % first arc (iarc=0)
            [T1,xopt1]=ode45(@fcneom,[0,t1],[x0;lamx;lamy;tf],[],0);
            theta1=atan2(xopt1(:,4),xopt1(:,3));
            ham1=xopt1(:,3).*(cos(theta1)-xopt1(:,2))+xopt1(:,4).*(sin(theta1))-1;
            x1 = xopt1(length(T1),1); y1 = xopt1(length(T1),2);
            lamx1 = xopt1(length(T1),3); lamy1 = xopt1(length(T1),4);
            % second arc (iarc=1)
            x0 = [x1;y1]; lic = [lamx1-pic;lamy1];
            [T2,xopt2]=ode45(@fcneom,[t1,t2],[x0;lic;tf],[],1);
            theta2=acos(xopt2(:,2));
            rmu = - xopt2(:,3) + xopt2(:,4)./tan(theta2);
            ham2=xopt2(:,3).*(cos(theta2)-xopt2(:,2))+xopt2(:,4).*(sin(theta2))-1;
            x2 = xopt2(length(T2),1); y2 = xopt2(length(T2),2);
            lamx2 = xopt2(length(T2),3); lamy2 = xopt2(length(T2),4);
            % third arc (iarc=0)
            x0 = [x2;y2]; lic = [lamx2;lamy2];
            [T3,xopt3]=ode45(@fcneom,[t2,1],[x0;lic;tf],[],0);
            theta3=atan2(xopt3(:,4),xopt3(:,3));
            
            ham3=xopt3(:,3).*(cos(theta3)-xopt3(:,2))+xopt3(:,4).*(sin(theta3))-1;
            % assemble optimal path
            T = [T1;T2;T3]*xopt3(1,5);
            xopt = [xopt1;xopt2;xopt3];
            theta = [theta1 ; theta2 ;theta3]';
            ham = [ham1; ham2; ham3]';
            mu = [zeros(size(T1)); rmu; zeros(size(T3))];
            figure(3)
            plot(T,mu); grid
            xlabel('Time'); ylabel('\mu')
        % end of case
        otherwise
            disp('case number should be between 1 and 3')
            disp('case = 1 : no constraint - use of bvp4c')
            disp('case = 2 : no constraint - of fsolve/ode45')
            disp('case = 3 : constraint - use of fsolve/ode45')
    end
    
    
    % plot optimal path
    figure(1)
    plot(xopt(:,1),xopt(:,2)); grid
    xlabel('X'); ylabel('Y')
    title('Zermelo min-time problem -- x(0) = 0.5, y(0) = -1')
    axis([-0.5 1 -1.5 0.5])
    figure(2);
    subplot(221)
    plot(T,theta); grid
    xlabel('Time'); ylabel('\theta (rad)')
    subplot(222)
    plot(T,ham); grid
    xlabel('Time'); ylabel('HAM')
    axis([0 2 -0.1 0.1])
    subplot(223)
    plot(T,xopt(:,3)); grid
    xlabel('Time'); ylabel('\lambda_x')
    subplot(224);
    plot(T,xopt(:,4)); grid
    xlabel('Time'); ylabel('\lambda_y')
    
    %---------------------------------------------------------------------
    function Xdot = fcneom(t,X,iarc)
        x = X(1); y = X(2);
        
        lamx = X(3); lamy = X(4);
        TF = X(5);
        if iarc==0
            theta=atan2(lamy,lamx);
            mu = 0;
        else
            theta = acos(y);
            mu = -lamx + lamy/tan(theta);
        end
        xdot = cos(theta)-y;
        ydot = sin(theta);
        lamxdot = 0;
        lamydot = lamx + mu;
        Tdot = 0;
        Xdot = TF*[xdot ydot lamxdot lamydot Tdot]';
    end
    
    %------------------------------------------------------------------
    function res = bcfun(ya,yb,iarc);
        global x0 xf tf
        % function to calculate the boundary conditions
        % vector res should have same dimension as state
        uf = - yb(2); vf = 0;
        lamxf = yb(3); lamyf = yb(4);
        thetaf=atan2(lamyf,lamxf);
        Hamf = (lamxf*(cos(thetaf)+uf)+lamyf*(sin(thetaf)+vf)-1)*yb(5);
        res = [ya(1)-x0(1) ya(2)-x0(2) yb(1)-xf(1) yb(2)-xf(2) Hamf]';
    end
    
    %---------------------------------------------------------------------
    function par = fcnzermc(guess)
        global x0 xf icase
        options = odeset('RelTol',1e-4,'AbsTol',1e-8);
        switch icase
            case 1
                disp('wrong case - use bpv4c instead!')
            case 2
                tf = guess(1); lic = guess(2:3);
                [T,X]=ode45(@fcneom,[0 tf],[x0;lic;tf],options,0);
                Xf = X(length(T),1); Yf = X(length(T),2);
                uf = - Yf; vf = 0;
                lamxf = X(length(T),3); lamyf = X(length(T),4);
                thetaf=atan2(lamyf,lamxf);
                Hamf = lamxf*(cos(thetaf)+uf)+lamyf*(sin(thetaf)+vf)-1;
                par(1) = Hamf;
                par(2) = xf(1)-Xf;
                par(3) = xf(2)-Yf;
            case 3
                % store initial guesses
                tf = guess(1); t1 = guess(2); t2 = guess(3);
                lic = guess(4:5); pic = guess(6);
                % integrate first part
                [T1,X1]=ode45(@fcneom,[0 t1],[x0;lic;tf],options,0);
                x1 = X1(length(T1),1); y1 = X1(length(T1),2);
                lamx1 = X1(length(T1),3); lamy1 = X1(length(T1),4);
                % conditions at entry of constraint
                par(1) = x1-0.55;
                par(2) = atan2(lamy1,lamx1)-acos(y1);
                % initial conditions for second part
                x10 = [x1;y1]; lic = [lamx1-pic;lamy1];
                % integrate second part
                [T2,X2]=ode45(@fcneom,[t1 t2],[x10;lic;tf],options,1);
                % conditions at exit of constraint
                x2 = X2(length(T2),1); y2 = X2(length(T2),2);
                lamx2 = X2(length(T2),3); lamy2 = X2(length(T2),4);
                mu = -lamx2+lamy2/tan(acos(y2));
                par(3) = mu;
                % initial conditions for final part
                x20 = [x2;y2]; lic = [lamx2;lamy2];
                % integrate final part
                [T3,X3]=ode45(@fcneom,[t2 1],[x20;lic;tf],options,0);
                Xf = X3(length(T3),1); Yf = X3(length(T3),2);
                lamxf =X3(length(T3),3); lamyf =X3(length(T3),4);
                
                % conditions at final time
                uf = -Yf; vf = 0;
                thetaf=atan2(lamyf,lamxf);
                Hamf = lamxf*(cos(thetaf)+uf)+lamyf*(sin(thetaf)+vf)-1;
                par(4) = Hamf;
                par(5) = Xf;
                par(6) = Yf;
            otherwise
                disp('Wrong value for icase!')
        end
    end
end