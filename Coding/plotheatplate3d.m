function plotheatplate3d(x, y, u)
    % Plots the values of u(x, t) on a 3D waterfall plot.
    mesh(u)
    % Edit the axis to show correct values
    x_tick_difference = idivide(int16(length(x)), int16(15));
    y_tick_difference = idivide(int16(length(y)), int16(15));
    x_ticks = 1:x_tick_difference:length(x);
    y_ticks = 1:y_tick_difference:length(y);

    ax = gca;
    ax.XTick = x_ticks;
    ax.YTick = y_ticks;
    ax.YTickLabel = "x = " + x(x_ticks);
    ax.XTickLabel = "y = " + y(y_ticks);
end