function plotheat3d(x, t, u)
    % Plots the values of u(x, t) on a 3D waterfall plot.
    mesh(x, t, u')
    % Edit the axis
    ax = gca;
    ax.XLabel.String = "Position in rod";
    ax.XLabel.FontSize = 12;
    ax.YLabel.String = "Elapsed time";
    ax.YLabel.FontSize = 12;
    ax.ZLabel.String = "Temperature";
    ax.ZLabel.FontSize = 12;
    
    colorbar
end