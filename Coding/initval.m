function [a] = initval(x)
    % The initial values of the heat equation at time t=0.
    % This function should be edited depending on the function you want
    % a = 5.*x .* (-5.*x + 30);
    % a = 50;
    % a = 20.*x;
    a = 1/10 .* x .* (x-5) .* (x.^2-2.*x+30) .* (x.^2-x-5) + 100;
end