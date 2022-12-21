%% Table of Constants

function planets = setup_planetary_constants()

    %{
      arp  : Axial Rotational Period (Rev / Day)
      mer  : Mean Equatorial Radius (km) 
      gp   : Gravitational Parameter, mu (km^3 / s^2)
      smao : Semi-Major Axis of Orbit (km)
      op   : Orbital Period (s)
      eo   : Eccentricity of Orbit 
      ioe  : Inclination of Orbit to Ecliptic (deg)
    %}

    % Sun
    sun.arp = 0.0394011;
    sun.mer = 695990;
    sun.gp  = 132712440017.99;
    sun.smao = NaN;
    sun.op   = NaN;
    sun.eo   = NaN;
    sun.ioe  = NaN;

    % Moon
    moon.arp  = 0.0366004;
    moon.mer  = 1738.2;
    moon.gp   = 4902.8005821478;
    moon.smao = 384400;
    moon.op   = 2360592;
    moon.eo   = 0.0554;
    moon.ioe  = 5.16;

    % Mercury 
    mercury.arp  = 0.0170514;
    mercury.mer  = 2439.7;
    mercury.gp   = 22032.080486418;
    mercury.smao = 57909101;
    mercury.op   = 7600537;
    mercury.eo   = 0.20563661;
    mercury.ioe  = 7.00497902;

    % Venus 
    venus.arp  = 0.0041149;  % retrograde
    venus.mer  = 6051.9;
    venus.gp   = 324858.59882646;
    venus.smao = 108207284;
    venus.op   = 19413722;
    venus.eo   = 0.00676399;
    venus.ioe  = 3.39465605;

    % Earth 
    earth.arp  = 1.0027378;
    earth.mer  = 6378.1363;
    earth.gp   = 398600.4415;
    earth.smao = 149597898;
    earth.op   = 31558205;
    earth.eo   = 0.01673163;
    earth.ioe  = 0.00001531;

    % Mars
    mars.arp  = 0.9747000;
    mars.mer  = 3397;
    mars.gp   = 42828.314258067;
    mars.smao = 227944135;
    mars.op   = 59356281;
    mars.eo   = 0.09336511;
    mars.ioe  = 1.84969142;

    % Jupiter 
    jupiter.arp  = 2.4181573;
    jupiter.mer  = 71492;
    jupiter.gp   = 126712767.8578;
    jupiter.smao = 778279959;
    jupiter.op   = 374479305;
    jupiter.eo   = 0.04853590;
    jupiter.ioe  = 1.30439695;

    % Saturn 
    saturn.arp  = 2.2522053;
    saturn.mer  = 60268;
    saturn.gp   = 37940626.061137;
    saturn.smao = 1427387908;
    saturn.op   = 930115906;
    saturn.eo   = 0.05550825;
    saturn.ioe  = 2.48599187;

    % Uranus 
    uranus.arp  = 1.3921114;  % retrograde
    uranus.mer  = 25559;
    uranus.gp   = 5794549.0070719;
    uranus.smao = 2870480873;
    uranus.op   = 2652503938;
    uranus.eo   = 0.04685740;
    uranus.ioe  = 0.77263783;

    % Neptune 
    neptune.arp  = 1.4897579;
    neptune.mer  = 25269;
    neptune.gp   = 6836534.0638793;
    neptune.smao = 4498337290;
    neptune.op   = 5203578080;
    neptune.eo   = 0.00895439;
    neptune.ioe  = 1.77004347;

    % Pluto 
    pluto.arp  = -0.1565620;  % retrograde
    pluto.mer  = 1162;
    pluto.gp   = 981.600887707;
    pluto.smao = 5907150229;
    pluto.op   = 7830528509;
    pluto.eo   = 0.24885238;
    pluto.ioe  = 17.14001206;
    
    % Return
    planets.sun = sun;
    planets.moon = moon;
    planets.mercury = mercury;
    planets.venus = venus;
    planets.earth = earth;
    planets.mars = mars;
    planets.jupiter = jupiter;
    planets.saturn = saturn;
    planets.uranus = uranus;
    planets.neptune = neptune;
    planets.pluto = pluto;
end 