classdef Rocket < handle % inheriting the 'handle' class enables self-editing
    
    %-----PROPERTIES-----%
    % The properties are basically variables that are associated with the
    % rocket.
    
    properties
        Location = [0,0] % meters relative to the launch site
        Fuel = 100; % kilograms of fuel remaining
        Thrust = 1e6; % Newtons of force
        Velocity = [0,0]; % measured in meters per second relative to the 
                            % launch site
        Orientation = [0,1]; % The direction that the rocket nose is
                             % pointed, measured in (x,y) coordinates
                             % with y being oriented upward relative to
                             % the ground
        Mass = 1000; % Total rocket mass (including fuel)
        NetForce = [0,0] % The sum of the gravitational, thrust, and drag
                         % forces on the rocket
    end
    
    properties (Hidden)
        % None yet
    end
    
    properties (Constant)
        gravitationalAcceleration = 9.8; % acceleration due to gravity measured
                                         % in meters per second
        stepSize = 1; % step size between steps in the trajectory, measured
                      % in seconds
    end
    
    %-----METHODS-----%
    % The methods are basically functions that we can make the rocket do
    
    methods
        
        % Updates the position of the rocket to the next step's location
        function updateLocation(obj)
            obj.Location = obj.Location + obj.Velocity .* obj.stepSize;
        end
        
        % Updatest the fuel of the rocket to the next step's fuel amount
        function updateFuel(obj)
            % This contrived example throws 10 kilograms of fuel out after
            % each second
            obj.Fuel = obj.Fuel - 10 * obj.stepSize;
        end
        
    end
    
end