%%   MA 266 Project 3
% Name: Tomoki Koike
%
% Professor: Dr. Mariano

%%
% *SET-UP*
% We will be using the pplane8 tool to figure out the prey-predator 
% model of a aphids (x) and ladybugs (y)
% The model equation is 
%
% $$dx/dt = x(1-y)$$
%
% $$dy/dt = y(x-1)$$ 
%
% $$x(0)=800000, y(0)=400000$$


%%
% *QUESTION 1:*
% Use pplane8 to plot the trajectory through $(0.8, 0.4)$. As t 
% increases, describe what happens to each population. Is the aphid 
% population ever smaller than 300,000? Are the aphids ever 
% eradicated? Does the ladybug population ever exceed 2 million?

openfig('pplane8_figure1.fig');
openfig('pplane8_x_vs_t.fig');
openfig('pplane8_y_vs_t.fig');



%%
% *ANSWER:*
% The plot of the trajectory at point $(0.8, 0.4)$ is a closed oval
% As t increases each population increases as well; however the more 
% larger the population of aphids are the smaller the ladybugs and vice 
% versa.
%
% The population of aphids never go below 300000 and they are
% never eradicated. There is a time when ladybugs exceed 2|M|.


%%
% *QUESTION 2:*
% A fellow farmer suggests that she use pesticide to kill the aphids. 
% She is reluctant because it also kills the helpful ladybugs and she 
% prefers to have some ladybugs remaining to eat other destructive 
% insects. If she were to use a pesticide, the growth rates would
% then become
%
% $$dx/dt = x(1-y)-sx          (*)$$
%
% $$dy/dt = y(x-1)-sy          (*)$$
%
% where $s >= 0$ is a measure of the “strength” of the pesticide – the 
% larger the s, the stronger the pesticide. Currently there are only
% two commercially available strengths: $s = 0.5$ and $s = 0.75$
% Plot the trajectories for the new system of equations (*) with these
% values of s. Will the aphids ever be totally eliminated?



%%
% *ANSWER:*
%
% * When $s = 0.5$:
% Aphids cannot be eradicated.
%
% * When $s = 0.75$:
% Aphids cannot be eradicated.

openfig('pplane8_figure2.fig');
openfig('s_0.5.fig');

openfig('pplane8_figure4.fig');
openfig('s_0.75.fig');

%%
% *QUESTION 3:*
% If she knows her crops will survive if the aphid population never 
% exceeds 2.6 million, which strength (if any) would you recommend 
% she use: s = 0.0 (no pesticide), $s = 0.5, s = 0.75$?



%%
% *ANSWER:*
% Examining the figures of the population of aphids by time
% when using the pesticide of $s = 0.5, 0.75$, I would
% recommend $s = 0.5$ since the population of aphids do not
% surpass 2.75 by using that one.



%%
% *QUESTION 4:*
% By special permission, she could get a pesticide with the maximum 
% strength of $s = 1.5$. Plot this trajectory. What happens to the
% ladybugs and aphids if she uses this pesticide?

openfig('pplane8_figure3.fig');
openfig('s_1.5.fig');




%%
% *ANSWER:*
% The population of aphids asymptote to 0 making it nearly possible
% to eradicate the ahpids.





