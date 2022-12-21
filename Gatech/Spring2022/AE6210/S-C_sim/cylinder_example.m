clear; close all;

% Reference position
r = [0; 0; 0];

% Reference orientation
R = eul2rotm([0, 0, pi/2],"ZYX");

% Cylinder spec
Radius = 0.1;
Height = 0.5;
SideCount = 100;

% Vertices
vertices_0 = zeros(2*SideCount, 3);
for i = 1:SideCount
    theta = 2*pi/SideCount*(i-1);
    vertices_0(i,:) = [Radius*cos(theta), Radius*sin(theta), r(3)+Height/2];
    vertices_0(SideCount+i,:) = [Radius*cos(theta), Radius*sin(theta), r(3)-Height/2];
end

vertices = r' + vertices_0*R';

% Side faces
sideFaces = zeros(SideCount, 4);
for i = 1:(SideCount-1)
    sideFaces(i,:) = [i, i+1, SideCount+i+1, SideCount+i];
end
sideFaces(SideCount,:) = [SideCount, 1, SideCount+1, 2*SideCount];

% Bottom faces
bottomFaces = [
    1:SideCount;
    (SideCount+1):2*SideCount];

% Draw patches
figure(1);
h_side = patch('Faces', sideFaces, 'Vertices', vertices, 'FaceColor', 'b');
h_bottom = patch('Faces', bottomFaces, 'Vertices', vertices, 'FaceColor', 'y');

% Axes settings
xlabel('x'); ylabel('y'); zlabel('z');
axis vis3d equal;
view([-37.5, 30]);
camlight;
grid on;
xlim([-0.4, 0.4]);
ylim([-0.4, 0.4]);
zlim([-0.4, 0.4]);