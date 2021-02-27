clear; close all;

% Defining a rocket object
myRocket = Rocket;

velocity = 0:100:8e3; % m/s
height = 0:50:250e3; % meters

[Velocity, Height] = meshgrid(velocity,height);

for i = 1:length(velocity)
    
    myRocket.Velocity(2) = velocity(i);
    
    for j = 1:length(height)
        
        myRocket.Location(2) = height(j);
        
        drag(j,i) = getDrag(myRocket);
        
    end
    
end

figure()
surf(Height, Velocity, drag)
title('Rocket Drag')
xlabel('Height (meters)')
ylabel('Velocity (m/s)')
zlabel('Drag (N)')

