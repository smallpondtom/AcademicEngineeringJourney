%% Table of moons and dwarfs constants

function satellites = setup_moon_constants()

    %{
      arp  : Axial Rotational Period (Rev / Day)
      mer  : Mean Equatorial Radius (km) 
      gp   : Gravitational Parameter, mu (km^3 / s^2)
      smao : Semi-Major Axis of Orbit (km)
      op   : Orbital Period (s)
      eo   : Eccentricity of Orbit 
      ioe  : Inclination of Orbit to Ecliptic (deg)
    %}

    %% About Pluto 
    % Charon 
    charon.arp  = 'synchronous';
    charon.mer  = 603.60;
    charon.gp   = 102.30;
    charon.smao = 17536;
    charon.op   = 551856.7066;
    charon.eo   = 0.0022;
    charon.ioe  = 0.001;
    % Nix
    nix.arp  = NaN;
    nix.mer  = 13.0;
    nix.gp   = 0.0013;
    nix.smao = 48708;
    nix.op   = 2147558.4;
    nix.eo   = 0.0030;
    nix.ioe  = 0.195;
    % Hydra
    hydra.arp  = NaN;
    hydra.mer  = 30.5;
    hydra.gp   = 0.0065;
    hydra.smao = 64749;
    hydra.op   = 3300998.4;
    hydra.eo   = 0.0051;
    hydra.ioe  = 0.212;
    
    %% About Jupiter
    % Io
    io.arp  = 'synchronous';
    io.mer  = 1821.60;
    io.gp   = 5959.916;
    io.smao = 421800;
    io.op   = 152853.5047;
    io.eo   = 0.0041;
    io.ioe  = 0.036;
    % Europa
    europa.arp  = 'synchronous';
    europa.mer  = 1560.80;
    europa.gp   = 3202.739;
    europa.smao = 671100;
    europa.op   = 306822.0384;
    europa.eo   = 0.0094;
    europa.ioe  = 0.466;
    % Ganymede
    ganymede.arp  = 'synchronous';
    ganymede.mer  = 2631.20;
    ganymede.gp   = 9887.834;
    ganymede.smao = 1070400;
    ganymede.op   = 618153.3757;
    ganymede.eo   = 0.0013;
    ganymede.ioe  = 0.177;
    % Callisto
    callisto.arp  = 'synchronous';
    callisto.mer  = 2410.30;
    callisto.gp   = 7179.289;
    callisto.smao = 1882700;
    callisto.op   = 1441931.19;
    callisto.eo   = 0.0074;
    callisto.ioe  = 0.192;
    
    %% About Saturn
    % Titan
    titan.arp  = 'synchronous';
    titan.mer  = 2574.730;
    titan.gp   = 8978.1382;
    titan.smao = 1221865;
    titan.op   = 1377648;
    titan.eo   = 0.0288;
    titan.ioe  = 0.312;
    
    %% About Uranus
    % Titania
    titania.arp  = 'assumed synchronous';
    titania.mer  = 788.90;
    titania.gp   = 228.2;
    titania.smao = 436300;
    titania.op   = 752218.6176;
    titania.eo   = 0.0011;
    titania.ioe  = 0.079;
    
    %% Main belt asteroid
    % Ceres
    ceres.arp  = 2.6448030;
    ceres.mer  = 476.20;
    ceres.gp   = 63.2;
    ceres.smao = 413690604;
    ceres.op   = 145238090.6;
    ceres.eo   = 0.0757972598;
    ceres.ioe  = 10.593981;
    
    %% About Mars
    % Phobos
    phobos.arp  = 'synchronous';
    phobos.mer  = 11.10;
    phobos.gp   = 0.0007112;
    phobos.smao = 9376;
    phobos.op   = 27552.96;
    phobos.eo   = 0.01510000;
    phobos.ioe  = 1.075000;
    % Deimos 
    deimos.arp  = 'synchronous';
    deimos.mer  = 6.20;
    deimos.gp   = 0.0000985;
    deimos.smao = 23458;
    deimos.op   = 109071.36;
    deimos.eo   = 0.0002;
    deimos.ioe  = 1.78800;
    % Triton
    triton.arp  = 'synchronous';
    triton.mer  = 1350.00;
    triton.gp   = 1427.598;
    triton.smao = 354759;
    triton.op   = 0.5877 * 60 * 60 * 24;
    triton.eo   = 0.000016;
    triton.ioe  = 156.86500;
    
    % Output of Function
    satellites.charon = charon;
    satellites.nix = nix;
    satellites.hydra = hydra;
    satellites.io = io;
    satellites.europa = europa;
    satellites.ganymede = ganymede;
    satellites.callisto = callisto;
    satellites.titan = titan;
    satellites.titania = titania;
    satellites.ceres = ceres;
    satellites.phobos = phobos;
    satellites.deimos = deimos;
    satellites.triton = triton;
    
end