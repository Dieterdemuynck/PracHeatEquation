function [a] = initval(x)
    % The initial values of the heat equation at time t=0.
    % This function should be edited depending on the function you want
    a = 1/2.*x .* (-3.*x + 30);
end