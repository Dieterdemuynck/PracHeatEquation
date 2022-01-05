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

    % First off: transform the continuous intervals for x and t to discreet
    % points:
    delta_x = L/(Nx-1); % Hey look, we can use these to calculate r
    delta_t = L/(Nt-1);
    x = 0:delta_x:L;
    t = 0:delta_t:T;

    % Secondly: we set up the first column of the output u, which should be
    % the initial values.
    % We fill up the matrix with a whole lotta zeros to preallocate some
    % space for the entire resulting matrix.
    u = zeros(Nx, Nt);
    u(:, 1) = initval(x);
    
    % Third, we assert whether the edge condition at x = L is valid.
    assert(u(Nx) == Tom, "Edge value at endpoint must be ambient temperature", u);
    % Note: we don't check x = 0, since there is no explicit value that the
    % rod must have at this point.

    % Fourth:
    % calculate bigT. bigT is a very nice matrix who'll help us calculate
    % the rest of u. Say hi to bigT. He's pretty nice.
    r = alpha * delta_t / (delta_x .^ 2);
    bigT = (2.*r-1) .* eye(Nx);
    for i = 2:Nx-1
        bigT(i, i-1) = r;
        bigT(i, i+1) = r;
    end
    % element (1,2) and (Nx, Nx-1) have not yet been set to r, however,
    % these do not matter, as we'll set them to the border conditions
    % (either Tom or a seperate calculated value).

    % Fifth:
    % Calculate the rest of u.
    for n = 2:Nt
        u(:, n) = bigT * u(:, n-1);
        % Remember: the outer values are either given or must be calculated
        % independently!
        u(Nx, n) = Tom;
        % Using the formula for the convection term at the edge case at
        % x=0:
        u(1, n) = K * (u(2, n) - Tom) / (H * 2 * delta_x) + Tom;
    end
end