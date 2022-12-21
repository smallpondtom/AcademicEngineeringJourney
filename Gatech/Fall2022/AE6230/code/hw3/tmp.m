%% Synchronous motions of 2DOF typical section

%% Cristina Riso, criso@gatech.edu

clearvars
close all
clc


%% Problem parameters

% mass (kg)
m = 10.0;

% moment of inertia about E (kg*m2)
J_E = 0.08;

% chord (m)
c = 0.2;

% offset of C from E (m, positive ahead)
e = -0.2*c;

% position of E from the LE (m, positive backward)
x_E = 0.4*c;

% plunge stiffness (N/m)
k_h = 1000.0;

% pitch stiffness (Nm/rad)
k_theta = 200.0;

% moment of inertia about C (kg*m2)
J_C = J_E-m*e^2;

% flag to make videos (switch off when not needed to save time)
make_video = false;


%% Eigenvalues and eigenvectors using eig

% build mass matrix
M = [m -m*e; -m*e J_E];

% build stiffness matrix
K = [k_h 0.0; 0.0 k_theta];

% compute eigenvalues and eigenvectors
[U, Omega2] = eig(K,M); omega2 = diag(Omega2); 

% compute natural frequencies (rad/s and Hz)
omega = sqrt(omega2); f = omega/(2.0*pi);

% loop the eigenvectors
for i = 1:2
    
    % normalize for unit maximum displacement
    if abs(min(U(:,i))) > max(U(:,i))
        U(:,i) = U(:,i)/min(U(:,i));
    else
        U(:,i) = U(:,i)/max(U(:,i));
    end
    
end


%% Eigenvalues and eigenvectors using direct solution

% coefficients of characteristic polynomial
a_2 = m*J_C; a_1 = -(m*k_theta+k_h*J_E); a_0 = k_theta*k_h;

% solve characteristic equation 
omega2_check = sort(roots([a_2 a_1 a_0])); 

% natural frequencies (rad/s and Hz)
omega_check = sqrt(omega2_check); f_check = omega_check/(2.0*pi);

% allocate matrix of eigenvectors
U_check = zeros(2,2);

% compute eigenvectors
for i = 1:2
    
    % build singular matrix
    A = K-omega2_check(i)*M;
    
    % compute eigenvector components
    U_check(1,i) = 1.0; U_check(2,i) = -A(1,1)/A(1,2);
    
    % normalize for unit maximum displacement
    if abs(min(U_check(:,i))) > max(U_check(:,i))
        U_check(:,i) = U_check(:,i)/min(U_check(:,i));
    else
        U_check(:,i) = U_check(:,i)/max(U_check(:,i));
    end    
    
end


%% New matrices

% modal mass matrix
M_bar = U'*M*U;

% modal stiffness matrix
K_bar = U'*K*U;


%% Plot eigenvectors (mode shapes)

% loop the eigenvectors
for i = 1:2
    
    % the mode shapes are plotted considering the chosen convention where
    % downward displacements and clockwise angles are positive (standard
    % convention used in typical section aeroelastic calculations)
    
    % compute positions of the LE and TE (m) 
    h_LE = U(1,i)-x_E*U(2,i); h_TE = U(1,i)+(c-x_E)*U(2,i);
    
    fig = figure(i); set(fig,'Position',[0 0 1200 900]); hold all; 
    % plot mode shape
    plot([0.0, c],[h_LE h_TE],'-','LineWidth',3);
    % plot line to indicate plunge component
    plot([0.0, c],[U(1,i) U(1,i)],'k--','LineWidth',1);
    % plot undeformed configuration
    plot([0.0, c],[0.0 0.0],'k-','LineWidth',2);
    ax = gca; ax.FontSize = 32; set(gca, 'YDir','reverse'); axis([-0.05 0.25 -0.2 1.2]);
    xlabel('$x$ (m)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex');
    fig = gcf; % exportgraphics(fig,strcat('mode',num2str(i),'.png'),'Resolution',300)
    
end


%% Animate natural motions

% scaling factor
scale = 0.1;

% make videos if applicable
if (make_video == true)
    
    % there may be a faster way to produce videos in MATLAB
    
    % make folder to store frames
    if isfolder('frames') == 0
        mkdir('frames')
    end
    
    % loop the eigenvectors
    for i = 1:2
        
        % time interval corresponding to two undamped periods of each frequency
        t_1 = 0.0; t_2 = 2.0/f(i); t = t_1:0.01/f(i):t_2; n_t = length(t);
        
        % open figure
        fig = figure(1000+i); set(fig,'Position',[0 0 1200 900]); 
        
        % loop the times
        for j = 1:n_t
            
            % compute positions of the LE and TE (m)
            h_LE = U(1,i)*cos(omega(i)*t(j))-x_E*U(2,i)*cos(omega(i)*t(j)); 
            h_TE = U(1,i)*cos(omega(i)*t(j))+(c-x_E)*U(2,i)*cos(omega(i)*t(j));
           
            % plot current shape and export
            plot([0.0, c],[h_LE h_TE]*scale,'-','LineWidth',3); hold all; axis equal;
            plot([0.0, c],[U(1,i) U(1,i)]*cos(omega(i)*t(j))*scale,'k--','LineWidth',1);
            plot([0.0, c],[0.0 0.0],'k-','LineWidth',2);
            ax = gca; ax.FontSize = 32; set(gca, 'YDir','reverse'); axis([-0.05 0.25 -1.2*scale 1.2*scale]);
            xlabel('$x$ (m)','Interpreter','latex'); ylabel('$z$ (m)','Interpreter','latex');
            fig = gcf;  exportgraphics(fig,strcat('frames/mode',num2str(i),'_frame',num2str(j),'.png'),'Resolution',300)
            
            % switch hold off
            hold off;
            
        end
        
        % video name
        writerObj = VideoWriter(strcat('motion',num2str(i),'.avi'));
        
        % frame rate (adjusted to represent actual frequency)
        writerObj.FrameRate = 10*f(i)/f(1);
        
        % quality
        writerObj.Quality = 100;
        
        % open the video object
        open(writerObj)
        
        % loop images
        for j = 1:n_t
            
            % load image
            image = imread(strcat('frames/mode',num2str(i),'_frame',num2str(j),'.png'));
            
            % covert to frame
            frame = im2frame(image);
            
            % add the frame to video
            writeVideo(writerObj,frame);
            
        end
        
        % close
        close(writerObj)
        
    end
    
end