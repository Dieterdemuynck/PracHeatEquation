function [u, x, t] = heat_explicit(L, Nx, T, Nt, alpha, Tom)
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
    %
    % ASSUMED GLOBAL VARIABLES:
    % initval(x), a function which maps each position x between 0 and L to
    % the respective initial temperature value of the rod at position x.

    % I notice there's no argument for the initial temperature values.
    % Which is absolute bonkers, in my opinion. This means I have to use
    % global variables (or rather a global "function") to send initial
    % values to this function. FYI, global vars are generally bad practice.
    % Don't do globals, kids.

    % First off: transform the continuous intervals for x and t to discreet
    % points:
    delta_x = L/(Nx-1); % Hey look, we can use these to calculate r
    delta_t = L/(Nt-1);
    x = 0:delta_x:L;
    t = 0:delta_t:T;

    % Secondly: we set up the first column of the output u, which should be
    % the initial values. (Emphasis on 'should', if you don't mess up on
    % how to properly call the function)
    % Note: x (and t) are rows, not columns. We want columns, so we have to
    % transpose the matrix. We also fill up the matrix with a whole lotta
    % zeros to preallocate some space for the entire resulting matrix.
    u = zeros(Nx, Nt);
    u(:, 1) = initval(x);
    
    % Third, we assert whether the edge conditions are actually valid.
    % If the function were to return different values than the edge values
    % at the edges, it's because something is /very obviously wrong/
    assert(u(1) == 0, "initial value at 0 must be 0", u);
    assert(u(Nx) == Tom, "Edge value at endpoint must be ambient temperature", u);
    % Note: if I was allowed to edit the functions input, I could have been
    % able to create an optional argument with which I can turn this check
    % off, potentially to avoid rounding errors being the cause.

    % Fourth:
    % calculate bigT. bigT is a very nice matrix who'll help us calculate
    % the rest of u. Say hi to bigT. He's pretty nice.
    bigT = (2.*r-1) .* eye(Nx);
    for i = 2:Nx-1
        bigT(i, i-1) = r;
        bigT(i, i+1) = r;
    end
    % element (1,2) and (Nx, Nx-1) have not yet been set to r, however,
    % these do not matter, as we'll set them to the border conditions
    % (either 0 or Tom).

    % Fifth:
    % Calculate the rest of u.
    for n = 2:Nt
        u(:, n) = bigT * u(:, n-1);
        % Remember: we set the outer values to 0 and Tom!
        u(1, n) = 0;
        u(Nx, n) = Tom;
    end
end