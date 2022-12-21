t = 0:0.1:68.087;
M = 500 - 6.6091 .* t;
V = 340 .* log(500 ./ (500 - 6.6091 .* t)) - 9.8067 .* t;

figure
plot(t, M, '-b')
title('Mass of Rocket of a Function of Time')
xlabel('Time (t)')
ylim([0 510])
ylabel('Mass (kg)')

figure
plot(t, V, '-r')
title('Velocity of Rocket of a Function of Time')
xlabel('Time (t)')
ylabel('Velocity (m/s)')

