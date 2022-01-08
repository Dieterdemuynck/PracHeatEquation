function plotheat1d(x, t, u, frames)
    % Plots the values of u(x, t_i) on a 1D figure for every i element of 
    % frames. The plottype used is a heatmap.
    
    % 1. Create transposed copy of u with only the requested frames
    frames = flip(frames);
    data = (u(:, frames))';

    % 2. Plot the data on a heatmap
    h = heatmap(x, t(frames), data);
    
    % 3. Adjust axis titles and colormap colors
    h.XLabel = "Position in rod";
    h.YLabel = "Elapsed time";
    colormap default;
end