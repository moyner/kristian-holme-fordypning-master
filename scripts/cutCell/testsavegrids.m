clear all
close all
%%
nx = 2640;
ny = 380;
gridcase = sprintf('cPEBI_%dx%d', nx, ny);
tagcase = 'allcells-bufferMult';
SPEcase = 'B';
simcase = Simcase('SPEcase', SPEcase, 'gridcase', gridcase, 'tagcase', tagcase);
name = sprintf('cPEBI_%dx%d', nx, ny);
simcase.saveGridRock(name);
%%
load(['grid-files/gridrock_simready/', name]);

%% 
plotToolbar(G, G);view(10,10);
axis tight %equal;