function [T] = tempCal(T1, h, h1, Th)
    %{ 
     *FUNCTION DESCRIPTION:*
     This function is designed to calculate the temperature
     in a specific altitude, such as: tropopause,
     stratopause, mesopause, etc.

     *OUTPUT VARIABLES:*

     T:  Vectors of the temperatures at an altitude h (K)

     *INPUT VARIABLES:*

     T1: Average temperature at initial level [K]

     h:  Vectors of the specific altitude [m or ft]

     h1: Vectors of the average surface level or initial surface 
            level [m or ft]

     Th: Vectors of temperature lapse rates [K/m or K/ft]
    %}

    %% 
    % *MAIN (CODE)*
    T = zeros(size(h)); % Preallocation of temperature vector

    for i = 1:1:length(h)
        if h(i) <= h1(2)
            T(i) = T1(1) + Th(1)*(h(i) - h1(1));
        elseif (h1(2) < h(i)) && (h(i) <= h1(3))
            T(i) = T1(2);
        elseif (h1(3) < h(i)) && (h(i) <= h1(4))
            T(i) = T1(2) + Th(2)*(h(i) - h1(3));
        elseif (h1(4) < h(i)) && (h(i) <= h1(5))
            T(i) = T1(3);
        elseif (h1(5) < h(i)) && (h(i) <= h1(6))
            T(i) = T1(3) + Th(3)*(h(i) - h1(5));
        elseif (h1(6) < h(i)) && (h(i) <= h1(7))
            T(i) = T1(4);
        elseif (h1(7) < h(i)) && (h(i) <= h1(8))
            T(i) = T1(4) + Th(4)*(h(i) - h1(7));
        end   
end