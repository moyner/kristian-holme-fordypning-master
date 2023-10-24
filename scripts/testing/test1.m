clear all
close all
%%
mrstModule add ad-core ad-props incomp mrst-gui mpfa mimetic linearsolvers ...
    ad-blackoil postprocessing diagnostics nfvm gmsh prosjektOppgave...
    deckformat
%% SimpleTest
saveplot = false;
grid = 'semi188x38_0.3';
simcase{1} = Simcase('gridcase', grid, ...
    'discmethod', '');
simcase{2} = Simcase('gridcase', grid, ...
    'discmethod', 'hybrid-avgmpfa-oo');
simcase{3} = Simcase('gridcase', grid, ...
    'discmethod', 'hybrid-ntpfa-oo');
% simcase{4} = Simcase('gridcase', grid, ...
%     'discmethod', 'hybrid-mpfa-oo');
for i = 1:numel(simcase)
    simpleTest(simcase{i}, 'direction', 'tb', ...
        'paddingLayers', -1, 'saveplot', saveplot, ...
        'uniformK', false);
end

% plotCellData(simcase.G, simcase.G.cells.volumes);view(0,0);
%% Find boundary faces
%find side faces
xMin = min(G.nodes.coords(:,1));
xMax = max(G.nodes.coords(:,1));

yMin = min(G.nodes.coords(:,2));
yMax = max(G.nodes.coords(:,2));

slack = 1e-7;
logSideFaces = G.faces.centroids(:,1) < xMin+slack | G.faces.centroids(:,1) > xMax-slack | G.faces.centroids(:,2) < yMin+slack...
    | G.faces.centroids(:,2) > yMax-slack;

logBdryFaces = ( G.faces.neighbors(:,1) == 0 | G.faces.neighbors(:,2) == 0);

logNonSideFaces =  logBdryFaces & ~logSideFaces;
plotFaces(G, find(logNonSideFaces));
view(12,25);
shg;
%% Cellblocks
gridcase = 'tetRef6';
deckcase = 'RS';
simcase = Simcase('gridcase', gridcase, 'deckcase', deckcase, 'usedeck', false, ...
    'schedulecase', '');
getCellblocks(simcase)


%% Plot difference between two cases
gridcase = 'tetRef10';
deckcase = 'RS';
discmethods = {'', 'hybrid-avgmpfa-oo'};
sim1 = Simcase('deckcase', deckcase, 'gridcase', gridcase, ...
    'discmethod', '');
sim2 = Simcase('deckcase', deckcase, 'gridcase', gridcase, ...
    'discmethod', '', 'tagcase', 'newPVT');
states1 = sim1.getSimData;
states2 = sim2.getSimData;
figure
G = sim1.G;
%% cont. diff plot
clf;
plotGrid(G, 'facealpha', 0);view(0,0);
step = 10;
ctm1 = states1{step}.FlowProps.CapillaryPressure{2};
ctm2 = states2{step}.FlowProps.CapillaryPressure{2};
ctmDifference = abs(ctm1-ctm2); 
plotCellData(G, ctmDifference)
colorbar;
axis tight;

%% Plot Cellblocks
simcase = Simcase('gridcase', 'tetRef10', 'discmethod', 'hybrid-ntpfa-oo');
cellblocks = getCellblocks(simcase);
G = simcase.G;
plotGrid(G, 'facealpha', 0);
plotGrid(G, cellblocks{1}, 'facecolor', 'yellow');
% plotGrid(G, cellblocks{2}, 'facecolor', 'red');
view(0,0);
axis tight;
title('tpfa cells');
%% plot top bc cells
simcase = Simcase('gridcase', 'tetRef2');
bcCells = getbcCells(simcase);
plotGrid(simcase.G, 'facealpha', 0);view(0,0);
plotGrid(simcase.G, bcCells);



%% Plot grid
gridcase = 'semi263x154_0.3';
gridcase = '6tetRef3';
simcase = Simcase('gridcase', gridcase);
figure
plotGrid(simcase.G, 'faceAlpha', 0);view(0,0);axis tight;axis equal;
% plotGrid(simcase.G, cellBlocks{1});


%% Print number of cells
gridcase = 'semi263x154_0.3';

simcase = Simcase('gridcase', gridcase);
disp(['gridcase ', gridcase, 'cells: ', num2str(simcase.G.cells.num)]);

%%
simcase = Simcase('deckcase', 'RS', 'usedeck', true, 'schedulecase', 'simple-std');
% plotCellData(simcase.G, simcase.rock.poro);view(0,0);

%%
geometriesFolder = "C:\Users\holme\OneDrive\Dokumenter\_Studier\Prosjekt\11SPE\src\11thSPE-CSP\geometries";
%%
file = fullfile(geometriesFolder, "spe11a_ref3.m");


G = gmshToMRST(file);
save(fullfile(geometriesFolder, 'spe11a_ref3_grid.mat'), "G");
%%
load(fullfile(geometriesFolder, 'spe11a_ref3_grid.mat'));
rock = createRock11A(G);
%%
plotCellData(G, rock.perm);
%%
[err, errvect, fwerr] = computeOrthError(G, rock, setupTables(G));
%%
figure
plotCellData(G, fwerr);
figure 
plotCellData(G, err);
%% Setup
deck = readEclipseDeck('spe11-utils\deck\CSP11A_RS.DATA');
deck = convertDeckUnits(deck);
refinement = 10;
dim = 3;
G = setupGrid11A('refinement_factor', refinement, 'dim', dim);
rock = setupRock11A(G);
fluid = setupFluid11A('deck', deck);
model = setupModel11A(G, rock, fluid, 'usedeck', true);
schedule = setupSchedule11A(G, rock, 'dim', dim);
% initState = initResSol(G, 1*atm, [1, 0]);
state0 = initStateDeck(model, deck);
nls = getNonLinearSolver(model);
nls.maxTimestepCuts = 20;
%% Setup
injectionTimeStep = 2*minute;
refinement_factor = 3;
settleTimeStep = 2*hour;
[state0, model, schedule, nls] = setup11A('refinement_Factor', refinement_factor, ...
                                          'injectionTimeStep', injectionTimeStep, ...
                                          'settleTimeStep'   , settleTimeStep,...
                                          'dim'              , 3);
%% Full deck sim setup
deckname = 'RSRV';
simcase = Simcase('deckcase', deckname, 'usedeck', true);
%%
solveMultiPhase(simcase, 'resetData', true)
%%
[states, wellsols, reports] = simcase.getSimData;
% states = states{1};
%%
plotToolbar(simcase.G, states);
view(0,0);
%%
simcase = Simcase('SPEcase', 'A', 'gridcase', 'tetRef10', ...
    'fluidcase', 'simple');

%%
solveMultiPhase(simcase, 'usedeck', false);

%%
[states, wellsols, reports] = simcase.getSimData();
%% Simulate
disp('Starting simulation...');
[wellSols, state, report]  = simulateScheduleAD(state0, model, schedule, 'NonLinearSolver', nls);
%%
plotToolbar(G, states, 'field', 's:2', 'startplayback', true)
axis tight; colorbar;
%%
figure
plotGrid(G)
plotGrid(G, [schedule.control(2).W.cells], 'facecolor', 'red')

%%
initpressure = state{1}.pressure;
for i = 1:numel(state)
    state{i}.pressureDiff = state{i}.pressure - initpressure;
end

%%
deckcase = 'RS';
gridcase = 'tetRef10';
schedulecase = 'simple';
simcase = Simcase('deckcase', deckcase,'usedeck', true, 'gridcase', gridcase, ...
    'schedulecase', schedulecase);

%%
[ok, status, time] = solveMultiPhase(simcase, 'resetData', true);
%%
gridcase = '5tetRef3';
simcase = Simcase('gridcase', gridcase);
%% Plot perm
figure
plotToolbar(simcase.G, simcase.rock.perm);view(0,0);
%% Plot poro
plotToolbar(simcase.G, simcase.rock.poro);view(0,0);
%% Plot
simcase.plotStates