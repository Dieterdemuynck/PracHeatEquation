function plotheat3d(x, t, u)
    % Plots the values of u(x, t) on a 3D waterfall plot.
    mesh(u)
    % Edit the axis to show correct values
    x_tick_difference = idivide(int16(length(x)), int16(15));
    t_tick_difference = idivide(int16(length(t)), int16(30));
    x_ticks = 0:x_tick_difference:length(x);
    t_ticks = 1:t_tick_difference:length(t);

    ax = gca;
    ax.YTick = x_ticks;
    ax.XTick = t_ticks;
    ax.YTickLabel = "x = " + x(x_ticks+1);
    ax.XTickLabel = "t = " + t(t_ticks);
end