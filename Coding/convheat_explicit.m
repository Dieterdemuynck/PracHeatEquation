function [u, x, t] = convheat_explicit(L, Nx, T, Nt, alpha, Tom, H, K)
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
    delta_x = L/(Nx-1); % We can use these to calculate r
    delta_t = T/(Nt-1);
    x = 0:delta_x:L;
    t = 0:delta_t:T;

    % 2. Calculate first column of u
    u = zeros(Nx, Nt);
    u(:, 1) = initval(x);
    
    % 3. Set edge values to correct values
    u(Nx, 1) = Tom;

    % 4. Calculate the matrix bigT
    r = alpha * delta_t / (delta_x .^ 2);
    bigT = (1-2.*r) .* eye(Nx);
    for i = 2:Nx-1
        bigT(i, i-1) = r;
        bigT(i, i+1) = r;
    end
    % Addapting the matrix for the convective border conditions at x = 0:
    q = 2 .* H .* delta_x.^2 / K;
    bigT(1, 1) = 1 - (2 + q) * r;
    bigT(1, 2) = 2 * r;

    % 5. Calculate the rest of matrix u using matrix bigT
    for n = 2:Nt
        u(:, n) = bigT * u(:, n-1);
        % Remember: the outer values are either given or must be calculated
        % independently!
        u(Nx, n) = Tom;
        % Adding the last requested term to apply for the convection
        % property at x = 0:
        u(1, n) = u(1, n) + r * q * Tom;
    end
end