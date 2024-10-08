clear all
close all
%% Read Geometry
fn = 'C:\Users\holme\Documents\Prosjekt\Prosjektoppgave\src\11thSPE-CSP\geometries\spe11a.geo';
geodata = readGeo(fn);
%assign loops to Fascies
geodata.Facies{1} = [7, 8, 9, 32];
geodata.Facies{7} = [1, 31];
geodata.Facies{5} = [2, 3, 4, 5, 6];
geodata.Facies{4} = [10, 11, 12, 13, 14, 15, 22];
geodata.Facies{3} = [16, 17, 18, 19, 20, 21];
geodata.Facies{6} = [23, 24, 25];
geodata.Facies{2} = [26, 27, 28, 29, 30];
geodata.BoundaryLines = unique([1, 2, 12, 11, 9, 8, 10, 7, 6, 5, 3, 4, 24, 23, 22, 21, 20, 19, 18, 17, 16, 14, 15, 13]);
%% Define Background Grid
Lx = 2.8;
Ly = 1.2;
nx = 280;
ny = 12;
G = cartGrid([nx ny 1], [Lx, Ly 0.01]);
G = computeGeometry(G);
%% Presplit at internal points
[Gpresplit, t] = pointSplit(G, geodata.Point, 'verbose', true, 'waitbar', true, 'save', true);
% presplitstats = {};
presplitstats{end+1} = [nx*ny, t];
%% Load presplitted grid
nx = 280*2;
ny = 120*2;
Gpresplit = loadPresplit('nx', nx, 'ny', ny);
%% Perform main cutting
[Gcut, t] = cutCellGeo(Gpresplit, geodata, 'verbose', true);
% sliceStats{end+1} = [nx*ny, t];
%% Load cutcell grid
nx = 144;
ny = 48;
Gcut = loadCutCell('nx', nx, 'ny', ny);
%% Tag by layer
Gcc = tagbyFacies(Gcut, geodata);
%% Plot tag
plotCellData(Gcut, Gcut.cells.tag)
%%
gridcase = 'cut144x48';
simcase = Simcase('gridcase', gridcase);
figure
plotCellData(simcase.G, simcase.G.cells.tag);view(0,0);
