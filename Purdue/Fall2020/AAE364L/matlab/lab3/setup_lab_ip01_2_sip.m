% SETUP_LAB_IP01_2_SIP
%
% IP01 or IP02 Single Inverted Pendulum (SIP) Control Lab: 
% Design of a LQR position controller
% 
% SETUP_LAB_IP01_2_SIP sets the SIP-plus-IP01-or-IP02 system's 
% model parameters accordingly to the user-defined configuration.
% SETUP_LAB_IP01_2_SIP can also set the controllers' parameters, 
% accordingly to the user-defined desired specifications.
%
% Copyright (C) 2003 Quanser Consulting Inc.
% Quanser Consulting Inc.

clear

% ############### USER-DEFINED IP01 or IP02 with SIP CONFIGURATION ###############
% Type of motorized cart: set to 'IP01', 'IP02'
% CART_TYPE = 'IP01';
  CART_TYPE = 'IP02';
% if IP02: Type of Cart Load: set to 'NO_LOAD', 'WEIGHT'
%IP02_LOAD_TYPE = 'NO_LOAD';
IP02_LOAD_TYPE = 'WEIGHT';
% Type of single pendulum: set to 'LONG_24IN', 'MEDIUM_12IN'
%
PEND_TYPE = 'LONG_24IN'; 
%PEND_TYPE = 'MEDIUM_12IN'; 
% Turn on or off the safety watchdog on the cart position: set it to 1 , or 0 
X_LIM_ENABLE = 1;       % safety watchdog turned ON
%X_LIM_ENABLE = 0;      % safety watchdog turned OFF
% Safety Limits on the cart displacement (m)
X_MAX = 0.35;            % cart displacement maximum safety position (m)
X_MIN = - X_MAX;        % cart displacement minimum safety position (m)
% Turn on or off the safety watchdog on the pendulum angle: set it to 1 , or 0 
ALPHA_LIM_ENABLE = 1;       % safety watchdog turned ON
%ALPHA_LIM_ENABLE = 0;      % safety watchdog turned OFF
% Safety Limits on the pendulum angle (deg)
global ALPHA_MAX ALPHA_MIN
ALPHA_MAX = 20;            % pendulum angle maximum safety position (deg)
ALPHA_MIN = - ALPHA_MAX;   % pendulum angle minimum safety position (deg)
% Cable Gain used: set to 1
K_CABLE = 1;
% Universal Power Module (UPM) Type: set to 'UPM_1503', 'UPM_2405', or 'UPM_1503x2'
UPM_TYPE = 'UPM_1503';
%UPM_TYPE = 'UPM_2405';
%UPM_TYPE = 'UPM_1503x2';
% Digital-to-Analog Maximum Voltage (V); for MultiQ cards set to 10
VMAX_DAC = 10;
% ############### END OF USER-DEFINED IP01 or IP02 with SIP CONFIGURATION ###############


% ############### USER-DEFINED CONTROLLER DESIGN ###############
% Type of Controller: set it to 'LQR_AUTO', 'LQR_GUI_TUNING', 'MANUAL'  
CONTROLLER_TYPE = 'LQR_AUTO';    % LQR controller design: automatic mode
%CONTROLLER_TYPE = 'LQR_GUI_TUNING'; % calls Matlab-based GUI for interactive LQR tuning
%CONTROLLER_TYPE = 'MANUAL';    % controller design: manual mode
% Initial Condition on alpha, i.e. pendulum angle at t = 0 (deg)
global IC_ALPHA0
%IC_ALPHA0 = 0.1;
IC_ALPHA0 = 0.2;
% conversion to radians
IC_ALPHA0 = IC_ALPHA0 / 180 * pi;
% Initialization of Simulink diagram parameters
if strcmp( CART_TYPE, 'IP01' )
    % Cart Potentiometer Sensitivity
    global K_PC K_PP
    % Specifications of a second-order low-pass filter
    wcf = 2 * pi * 5;  % filter cutting frequency
    zetaf = 0.9;        % filter damping ratio
elseif strcmp( CART_TYPE, 'IP02' )
    % Cart Encoder Resolution
    global K_EC K_EP
    % Specifications of a second-order low-pass filter
    wcf = 2 * pi * 10; % filter cutting frequency
    zetaf = 0.9;        % filter damping ratio
else
    error( 'Error: Set the type of motorized cart.' )
end
% ############### END OF USER-DEFINED CONTROLLER DESIGN ###############


% variables required in the Simulink diagrams
global VMAX_UPM IMAX_UPM

% Set the model parameters accordingly to the user-defined IP01 or IP02 system configuration.
% These parameters are used for model representation and controller design.
[ Rm, Jm, Kt, Eff_m, Km, Kg, Eff_g, Mc, r_mp, Beq ] = setup_ip01_2_configuration( CART_TYPE, IP02_LOAD_TYPE, UPM_TYPE );

% Lumped Mass of the Cart System (accounting for the rotor inertia)
Mc = Mc + Eff_g * Kg^2 * Jm / r_mp^2;

% Set the model parameters for the single pendulum accordingly to the user-defined system configuration.
[ g, Mp, Lp, lp, Ip, Bp ] = setup_sp_configuration( PEND_TYPE );

% For the following state vector: X = [ xc; alpha; xc_dot; alpha_dot ]
% Initialization of the State-Space Representation of the Open-Loop System
% Call the following Maple-generated file to initialize the State-Space Matrices: A, B, C, and D
SIP_ABCD_eqns

if strcmp ( CONTROLLER_TYPE, 'LQR_AUTO' )
    % LQR Controller Design Specifications
    if strcmp ( CART_TYPE, 'IP01')
        if strcmp( PEND_TYPE, 'LONG_24IN' )
            Q = diag( [ 0.5 4 0 0 ] );
            R(1,1) = [ 0.00005 ];
        elseif strcmp( PEND_TYPE, 'MEDIUM_12IN' )
            Q = diag( [ 1 6 0 0 ] );
            R(1,1) = [ 0.00005 ];
        else
            error( 'Error: Set the type of pendulum.' )
        end
    elseif strcmp ( CART_TYPE, 'IP02')
        if strcmp( IP02_LOAD_TYPE, 'NO_LOAD' )
            if strcmp( PEND_TYPE, 'LONG_24IN' )
                Q = diag( [ 0.4 4.5 0 0 ] );
                R(1,1) = [ 0.0002 ];
            elseif strcmp( PEND_TYPE, 'MEDIUM_12IN' )
                Q = diag( [ 0.5 4 0 0 ] );
                R(1,1) = [ 0.0003 ];
            else
                error( 'Error: Set the type of pendulum.' )
            end
        elseif strcmp( IP02_LOAD_TYPE, 'WEIGHT' )
            if strcmp( PEND_TYPE, 'LONG_24IN' )
                Q = diag( [ 0.75 4 0 0 ] );
                R(1,1) = [ 0.0003 ];
            elseif strcmp( PEND_TYPE, 'MEDIUM_12IN' )
                Q = diag( [ 1 6 0 0 ] );
                R(1,1) = [ 0.0004 ];
            else
                error( 'Error: Set the type of pendulum.' )
            end
        else
            error( 'Error: Set the IP02 load configuration.' )
        end
    else
        error( 'Error: Set the type of motorized cart.' )
    end
    % Automatically calculate the LQR controller gain
    [ K ] = d_ip01_2_sip_lqr( A, B, C, D, Q, R );
    % Display the calculated gains
    %disp( ' ' )
    %disp( 'Calculated LQR controller gain elements: ' )
    %disp( [ 'K(1) = ' num2str( K(1) ) ' V/m' ] )
    %disp( [ 'K(2) = ' num2str( K(2) ) ' V/rad' ] )
    %disp( [ 'K(3) = ' num2str( K(3) ) ' V.s/m' ] )
    %disp( [ 'K(4) = ' num2str( K(4) ) ' V.s/rad' ] )
elseif strcmp ( CONTROLLER_TYPE, 'LQR_GUI_TUNING' )
    global Gui_QR Gui_Trial_ID Gui_Cnt_Offset
    Gui_Trial_ID = 0;
    % cell array format: 
    % QR_prev = { 'Q(1,1)', 'Q(2,2)', 'Q(3,3)', 'Q(4,4)', 'R(1,1)', 'save_to_file', 'continue_gui_tuning' }
    % un-tuned starting values for the Q and R matrices (to be manually tuned during the in-lab session):
    Gui_QR = { '0.01', '0', '0', '0', '0.01', 'no', 'yes' };
    % initial call the user dialog box
    [ Q, R ] = d_gui_lqr_tuning;
    % while loop w.r.t. 'Continue_Tuning'
    while strcmp( Gui_QR{ Gui_Cnt_Offset }, 'yes' )
        fprintf( '\nTrial # %d :\n', Gui_Trial_ID );
        % Calculate the optimal gain vector corresponding to the latest Q and R matrices
        [ K ] = d_ip01_2_sip_lqr( A, B, C, D, Q, R );
        % Display the calculated gains
        disp( ' ' )
        %disp( 'Calculated LQR controller gain elements: ' )
        %disp( [ 'K(1) = ' num2str( K(1) ) ' V/m' ] )
        %disp( [ 'K(2) = ' num2str( K(2) ) ' V/rad' ] )
        %disp( [ 'K(3) = ' num2str( K(3) ) ' V.s/m' ] )
        %disp( [ 'K(4) = ' num2str( K(4) ) ' V.s/rad' ] )
        % ask Simulink to update its state (i.e. CTRL+D hotkey )
        wc_update
        % re-call the user dialog box
        [ Q, R ] = d_gui_lqr_tuning;
    end
    disp( 'On-line LQR tuning terminated.' )
elseif strcmp ( CONTROLLER_TYPE, 'MANUAL' )
    K = [ 0 0 0 0 ];
    disp( ' ' )
    disp( 'STATUS: manual mode' ) 
    disp( 'The model parameters of your Single Pendulum and IP01 or IP02 system have been set.' )
    disp( 'You can now design your state-feedback position controller.' )
    disp( ' ' )
else
    error( 'Error: Please set the type of controller that you wish to implement.' )
end
a=[A,zeros(4,1);-1,0,0,0,0];b=[B;0];K=[0,0,0,0,0];