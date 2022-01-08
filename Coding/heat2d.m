function [u, x, y] = heat2d(Nx, Ny, T, Nt, alpha, Tom, H, K)
    % OUTPUTS:
    % u = matrix Nx by Ny with the temperature values at t = T
    % x = array of length Nx with coordinates of discrete points in x dir.
    % y = array of length Nt with coordinates of discrete points in y dir.
    % 
    % INPUTS:
    % Nx = amount of discrete points in space on the x-axis
    % Ny = amount of discrete points in space on the y-axis
    % T = end time of the requested time interval
    % Nt = amount of discrete points in time
    % alpha = diffusivity constant
    % Tom = a nice guy- I mean, the ambient temperature
    % H = heat transfer coefficient
    % K = heat conduction coefficient
    %
    % ASSUMED GLOBAL VARIABLES:
    % NONE: for the initial values we assume all temperature values to be 0

    % 1. continuous intervals to discrete points for x and t
    delta_x = 1/(Nx-1); % use to calculate r_x
    delta_y = 1/(Ny-1); % use to calculate r_y
    delta_t = T/(Nt-1);
    x = 0:delta_x:1;
    y = 0:delta_y:1;
    % t = 0:delta_t:T;

    % 2. Setup initial values of u
    u = zeros(Nx, Ny);
    u(1, :) = sin(pi .* y); % edge condition at x = 0

    % 3. Calculate the r and q values
    % I had the brilliant idea to use 2 matrices, bigX and bigY, which I
    % could use on u_temp (see later) and u_temp transposed, and add up the
    % results. Sadly, after having gotten used to using matrices, I am
    % *required* to use 2 boring for loops. Oh well. Probably more
    % efficient anyway.
    r_x = alpha * delta_t / (delta_x .^ 2);
    r_y = alpha * delta_t / (delta_y .^ 2);
    q = 2 .* H .* delta_x.^2 / K;

    % 4. Calculate the next instance of u at a next timestep
    for n = 2:Nt
        % 4.1 Copy u to a new temporary matrix u_temp
        u_temp = zeros(Nx, Ny);
        u_temp(:, :) = u;
        
        % 4.2 Calculate each new value individually for u
        % Note: 3 of the 4 borders don't actually need to be recalculated,
        % as they are certain to stay at a constant value.
        for i = 2:Nx-1
            for j = 2:Ny-1
                x_differs = r_x .* (u_temp(i+1, j) + u_temp(i-1, j));
                y_differs = r_y .* (u_temp(i, j+1) + u_temp(i, j-1));
                eq_differs = (1 - 2 * r_x - 2 * r_y) .* u_temp(i, j);
                
                u(i, j) = x_differs + y_differs + eq_differs;
            end
        end

        % 4.3 Calculate the convection border values (at x = 1)
        % Note: we're not including the corners for this calculation.
        for j = 2:Ny-1
            x_differs = 2 * r_x .* u_temp(Nx-1, j);
            y_differs = r_y .* (u_temp(Nx, j+1) + u_temp(Nx, j-1));
            eq_differs = (1 + r_x * (q - 2) - 2 * r_y) .* u_temp(Nx, j);
            cst_term = r_x * q * Tom;

            u(Nx, j) = x_differs + y_differs + eq_differs - cst_term;
        end
    end
end