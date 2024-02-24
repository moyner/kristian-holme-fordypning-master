clear all
close all
%%
nx = 460;
ny = 64;
G1 = GenerateCutCellGrid(nx, ny, 'save', true, 'bufferVolumeSlice', false);
G2 = GenerateCutCellGrid(nx, ny, 'save', true, 'bufferVolumeSlice', false, 'type', 'cartesian');
nx=220;ny=110;
G3 = GeneratePEBIGrid(nx, ny, 'save', true, 'bufferVolumeSlice', false, 'FCFactor', 0.94);
%%
G1 = load('grid-files/cutcell/horizon_nudge_cutcell_PG_460x64_B.mat').G;
G2 = load('grid-files/cutcell/cartesian_nudge_cutcell_PG_460x64_B.mat').G;
G3 = load('grid-files/PEBI/cPEBI_220x110_B.mat').G;
%%
grids = {G1, G2, G3};
names = {'HNCP-M', 'CNCP-M', 'cPEBI-M'};
%%
T = tiledlayout(numel(grids), 1);

for ig = 1:numel(grids)
    G = grids{ig};
    name = names{ig};
    nexttile(ig);
    histogram(log10(G.cells.volumes));
    title(sprintf('Grid: %s, Cells: %d', name, G.cells.num));
    xlabel('Log10(cell volumes)');
    ylabel('Frequency');
end

%%
exportgraphics(T, sprintf('./../plotsMaster/histograms/horz_ndg-cart_ndg-cPEBI-M.pdf'));
exportgraphics(T, sprintf('./../plotsMaster/histograms/horz_ndg-cart_ndg-cPEBI-M.png'));

%%

T = tiledlayout(numel(grids), 1);

for ig = 1:numel(grids)
    G = grids{ig};
    N = getNeighbourship(G);
    Conn = getConnectivityMatrix(N);
    [I, J] = find(Conn);
    sz = J(end);
    [~, nbs] = rlencode(J);

    name = names{ig};
    nexttile(ig);
    histogram(nbs);
    title(sprintf('Grid: %s, Cells: %d', name, G.cells.num));
    xlabel('Number of neighbors');
    ylabel('Frequency');
end

%%
exportgraphics(T, sprintf('./../plotsMaster/histograms/horz_ndg-cart_ndg-cPEBI-M-neighbors.pdf'));
exportgraphics(T, sprintf('./../plotsMaster/histograms/horz_ndg-cart_ndg-cPEBI-M-neighbors.png'));
%%
T = tiledlayout(numel(grids), 1);

for ig = 1:numel(grids)
    G = grids{ig};
    name = names{ig};
    nexttile(ig);
    histogram(log10(G.faces.areas));
    title(sprintf('Grid: %s, Cells: %d', name, G.cells.num));
    xlabel('Log10(face areas)');
    ylabel('Frequency');
end

%%
exportgraphics(T, sprintf('./../plotsMaster/histograms/horz_ndg-cart_ndg-cPEBI-M-faceA.pdf'));
exportgraphics(T, sprintf('./../plotsMaster/histograms/horz_ndg-cart_ndg-cPEBI-M-faceA.png'));