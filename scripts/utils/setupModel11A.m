function model = setupModel11A(simcase, varargin)
    opt = struct();
    opt = merge_options(opt, varargin{:});
    
    G = simcase.G;
    rock = simcase.rock;
    fluid = simcase.fluid;

    usedeck = simcase.usedeck;
    deck = simcase.deck;
    
    gravity([0, 0, 9.81]);
    gravity on


    if ~usedeck
        water = true;
        oil = false;
        gas = true;
        model = GenericBlackOilModel(G, rock, fluid, 'water', water, 'oil', oil, 'gas', gas);
    else
        model = selectModelFromDeck(G, rock, fluid, deck);
    end

    model.OutputStateFunctions{end+1} = 'CapillaryPressure';
    model.outputFluxes = false;
    model.AutoDiffBackend = DiagonalAutoDiffBackend('useMex', true);
    model.dpMaxRel = 0.2; %copied from initEclipseProblem
end