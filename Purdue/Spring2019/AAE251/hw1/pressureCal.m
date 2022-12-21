function [p] = pressureCal(g, R, T, T1, h, h1, Th, unit)

%{ 
 *FUNCTION DESCRIPTION:*
 This function is designed to calculate the pressure at a where the
 temperature is constant in a specific altitude, such as: tropopause,
 stratopause, mesopause, etc.
 
 *OUTPUT VARIABLES:*

 p:  The pressure at an altitude h (Pa)
 
 *INPUT VARIABLES:*

 g:  Gravitational acceleration [SI or English untis]

 R:  Gas Constant specific to planet [SI or English units]

 T:  Vector of temperatures at a certain altitude [K]

 T1: Vector of average temperature at the average surface level
     or initial temperature [K]

 h:  Vector of the specific altitude [m] or [ft]

 h1: Vector of the average surface level or initial surface
     level [m] or [ft]

 Th: Vector of temperatures lapse rate

 unit: String indicating English or SI units
%}

%% 
% *MAIN (CODE)*
sz = size(h);
p = zeros(sz);

if unit == "SI"
    p1 = 1013.2*100; % Initial pressure at surface (Pa)
else
    p1 = 2116.12;    % initial presure at surface (lb/ft^2)
end

ct = 0;          % counter

for i = 1:1:length(h)
    if h(i) <= h1(2)
        if ct == 0
            ct = ct + 1;
        end
        
        p(i) = p1 * (T(i) / T1(1))^(-g / R / Th(1));        
    elseif (h1(2) < h(i)) && (h(i) <= h1(3))
        if ct == 1
            p1 = p(i-1);
            ct = ct + 1;
        end
        
        p(i) = p1 * exp(-g * (h(i) - h1(2)) / R / T(i));
    elseif (h1(3) < h(i)) && (h(i) <= h1(4))
       if ct == 2
            p1 = p(i-1);
            ct = ct + 1;
        end
        
        p(i) = p1 * (T(i) / T1(2))^(-g / R / Th(2));   
    elseif (h1(4) < h(i)) && (h(i) <= h1(5))
        if ct == 3
            p1 = p(i-1);
            ct = ct + 1;
        end
        
        p(i) = p1 * exp(-g * (h(i) - h1(4)) / R / T(i));
    elseif (h1(5) < h(i)) && (h(i) <= h1(6))
       if ct == 4
            p1 = p(i-1);
            ct = ct + 1;
        end
        
        p(i) = p1 * (T(i) / T1(3))^(-g / R / Th(3));  
    elseif (h1(6) < h(i)) && (h(i) <= h1(7))
       if ct == 5
            p1 = p(i-1);
            ct = ct + 1;
        end
        
        p(i) = p1 * exp((-1)* g * (h(i) - h1(6)) / R / T(i));
    elseif (h1(7) < h(i)) && (h(i) <= h1(8))
       if ct == 6
            p1 = p(i-1);
            ct = ct + 1;
        end
        
        p(i) = p1 * (T(i) / T1(4))^(-g / R / Th(4));  
    end   
end


