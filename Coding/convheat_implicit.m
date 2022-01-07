function [u, x, t] = convheat_implicit(L, Nx, T, Nt, alpha, Tom, H, K)
    % OUTPUTS:
    % u = matrix of Nx by Nt with in the n-th column the solution after
    % n-th timesteps.
    % x = array of length Nx with coordinates of discrete points in space
    % t = array of length Nt with coordinates of discrete points in time
    % 
    % INPUTS:
    % L = length of rod
    % Nx = amount of discrete points in space
    % T = end time of the requested time interval
    % Nt = amount of discrete points in time
    % alpha = diffusivity constant
    % Tom = a nice guy- I mean, the ambient temperature
    % H = heat transfer coefficient
    % K = heat conduction coefficient
    %
    % ASSUMED GLOBAL VARIABLES:
    % initval(x), a function which maps each position x between 0 and L to
    % the respective initial temperature value of the rod at position x.

    % 1. continuous intervals to discrete points for x and t
    delta_x = L/(Nx-1);
    delta_t = T/(Nt-1);
    x = 0:delta_x:L;
    t = 0:delta_t:T;

    % 2. Calculate first column of u
    u = zeros(Nx, Nt);
    u(:, 1) = initval(x);
    
    % 3. Set edge values to correct values
    u(Nx, 1) = Tom;

    % 4. Calculate the matrix bigA
    r = alpha .* delta_t / (delta_x .^ 2);
    bigA = (1+2.*r) .* eye(Nx);
    for i = 2:Nx-1
        bigA(i, i-1) = -r;
        bigA(i, i+1) = -r;
    end
    % Set the last row to those of the unit matrix:
    bigA(Nx, Nx) = 1;
    % Set the first row to the requested calculation for the convection
    % term
    q = 2 .* H .* delta_x.^2 / K;
    bigA(1, 1:2) = [1 + r .* (2 + q), - 2 .* r];

    % 5. Calculate the matrix bigB to easily create the vector b
    bigB = (1-2.*r) .* eye(Nx);
    for i = 2:Nx-1
        bigB(i, i-1) = r;
        bigB(i, i+1) = r;
    end
    % To simplify calculation.
    bigB(Nx, Nx) = 0;
    % Including calculation for the convection term
    % Note: no constant term has been added yet.
    bigB(1, 1:2) = [1 - r .* (2 + q), 2 .* r];

    % 6. Solve the equation using the almost-tridiagonal matrix bigA:
    for n = 2:Nt
        % 6.1: Calculate vector b
        b = bigB * u(:, n-1);
        b(1) = b(1) + 2 .* r .* q .* Tom;  % constant term for condition at x = 0
        b(Nx) = Tom;  % condition at x = L

        % 6.2 Create extended matrix and solve
        A = [bigA, b];
        A = rref(A);

        % 6.3 Perform a check to see if there is in fact a proper solution
        for i = 1:Nx
            if A(i, i) ~= 1
                error("singular matrix at n %d position (%d, %d)", n, i, i);
            end
        end

        % 6.4 Add the last column to the resulting matrix u
        u(:, n) = A(:, Nx + 1);
    end
end