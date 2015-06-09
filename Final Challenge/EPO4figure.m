classdef EPO4figure
    %EPO4figure This class is used to make a plot of the current and past
    %locations of KITT. Furthermore the microphones, waypoint, destination
    %and any obstacles can be marked. For this you have the following
    %functions:
    %
    % EPO4figure.setMicLoc(locs)
    % EPO4figure.setWayPoint(loc)
    % EPO4figure.setDestination(loc)
    % EPO4figure.setKITT(loc)
    % EPO4figure.setObstacle(loc)
    %
    % Where loc is a vector of length 2 or 3 with the x,y,z coordinates given in meters.
    % Locs is a matrix of [n, 2] or [n, 3] with the x,y,z coordinates given
    % in meters of n nodes
    
    methods(Static = true)
        function obj = EPO4figure()
            %EPO4figure creates the figure and sets the axis.
            if(ishandle(99))
                close 99;
            end
            fig = figure(99);
            set(fig,'units','normalized','outerposition',[0 0 1 1]);
            set(fig,'DefaultAxesColor',[0.6,0.6,0.6])
            title('EPO4 Final Challenge');
            xlabel('X coordinate (m)');
            ylabel('Y coordinate (m)');
            zlabel('Z coordinate (m)');
            axis([-2 8 -2 8]);
            hold on;
            grid on
            set(gca, 'GridLineStyle', '-');
            grid(gca,'minor')
            EPO4figure.isLoaded(true);
        end
        
        %isLoaded is a function used by the class only
        function isLoaded(set)
            persistent loaded
            if nargin == 0
                if(isempty(loaded) || loaded == false || ~ishandle(99))
                    EPO4figure();
                end
                set = true;
            end
            if(set)
                loaded = true;
            end
        end
        
        function setMicLoc(locs)
            %setMicLoc adds a miclocation to the figure
            %x,y and z are the x,y,z coordinates given in meters
            [n,m] = size(locs);
            EPO4figure.isLoaded();
            figure(99);
            if m == 2
                plot3(locs(:,1),locs(:,2),zeros(n,1),'c^','LineWidth',4);
            else
                plot3(locs(:,1),locs(:,2),locs(:,3),'c^','LineWidth',4);
            end
        end
        
        function setWayPoint(loc)
            %setWayPoint adds a waypoint to the figure
            %x,y and z are the x,y,z coordinates given in meters
            EPO4figure.isLoaded();
            figure(99);
            if length(loc) == 2
                plot3(loc(1),loc(2),0,'md','LineWidth',4);
            else
                plot3(loc(1),loc(2),loc(3),'md','LineWidth',4);
            end
        end

        function setDestination(loc)
            %setDestination adds a destination to the figure
            %x,y and z are the x,y,z coordinates given in meters
            EPO4figure.isLoaded();
            figure(99);
            if length(loc) == 2
                plot3(loc(1),loc(2),0,'mp','LineWidth',4);
            else
                plot3(loc(1),loc(2),loc(3),'mp','LineWidth',4);
            end
        end
        
        function setKITT(loc)
            %setKITT adds a the current position of KITT to the figure
            %x,y and z are the x,y,z coordinates given in meters
            persistent lastloc

            EPO4figure.isLoaded();
            figure(99);
            if ~isempty(lastloc)
                plot3(lastloc(1),lastloc(2),lastloc(3)+0.001,'k.','MarkerSize',21);
            end

            if length(loc) == 2
                loc(3) = 0;
            end
            lastloc = loc;
            plot3(loc(1),loc(2),loc(3),'b.','MarkerSize',21);
        end

        function setObstacle(loc)
            %setObstacle adds a obstacle to the figure
            %x,y and z are the x,y,z coordinates given in meters
            EPO4figure.isLoaded();
            figure(99);
            if length(loc) == 2
                plot3(loc(1),loc(2),0,'rs','LineWidth',4);
            else
                plot3(loc(1),loc(2),loc(3),'rs','LineWidth',4);
            end
        end
    end
end