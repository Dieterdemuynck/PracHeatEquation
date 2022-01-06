function plotheat3d_ribbon(x, t, u)
    % Plots the values of u(x, t) on a 3D ribbonplot.
    ribbon(x, u, 1)
    % Edit the axis to show correct values
    % ax = gca;
    % ax.YTick = 0:length(x)-1;
    % ax.XTick = 1:length(t);
    % ax.YTickLabel = "x = " + x;
    % ax.XTickLabel = "t = " + t;
end