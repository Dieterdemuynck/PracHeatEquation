function plotheatplate3d(x, y, u)
    % Plots the values of u(x, t) on a 3D waterfall plot.
    mesh(x, y, u')
    % Edit the axis to show correct values
    ax = gca;
    ax.XLabel.String = "X-coordinate of position in plate";
    ax.XLabel.FontSize = 12;
    ax.YLabel.String = "Y-coordinate of position in plate";
    ax.YLabel.FontSize = 12;
    ax.ZLabel.String = "Temperature";
    ax.ZLabel.FontSize = 12;

    colorbar
end