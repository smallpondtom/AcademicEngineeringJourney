%% AAE 333 example code

%define x and y
x = -2:.1:2;
y = -2:.1:2;

%create a mesh of x and y
[x,y] = meshgrid(x,y);

%define u and v
u = 50 + (40/2*pi)*(x+1.5)./((x+1.5).^2 + y.^2) - (30/2*pi)*(x-.5)./((x-.5).^2 + y.^2);
v = (40/2*pi)*y./((x+1.5).^2 + y.^2) - (30/2*pi)*y./((x-.5).^2 + y.^2);

% figures
h2 =figure(2);
quiver(x,y,u,v)
xlabel('x')
ylabel('y')
axis([x(1) x(end) y(1) y(end)])
