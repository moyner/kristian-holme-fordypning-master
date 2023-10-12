function schedule = setupSchedule11A(simcase, varargin)

    schedulecase = simcase.schedulecase;
    
   
    if ~isempty(schedulecase)
        switch schedulecase
            case 'simple-std'
                injectionTimeStep = 10*minute;
                settleTimeStep    = 10*minute;
            case 'simple-coarse'
                injectionTimeStep = 30*minute;
                settleTimeStep    = 120*minute;
        end


        G = simcase.G;
        rock = simcase.rock;    
        
        endTime = 5*day;
        injInterval = 2.5*hour;
        
        [wells1, wells2, wells3] = setupWells11A(simcase, varargin{:});
        bc = setupBC11A(G);
        Tsettle = endTime - 2* injInterval;
        Nsettle = ceil(Tsettle/settleTimeStep);
        Ninterval = injInterval/injectionTimeStep;
        timesteps = [injectionTimeStep*ones(2*Ninterval, 1); settleTimeStep*ones(Nsettle,1 )];
    
        schedule.step.val = timesteps;
        schedule.step.control = [ones(Ninterval, 1); 
                                2*ones(Ninterval, 1);
                                3*ones(Nsettle, 1)];
        
        schedule.control = struct('W', wells1, 'src', [], 'bc', bc);
        schedule.control(2).W = wells2;
        schedule.control(2).bc = bc;
        schedule.control(3).W = wells3;
        schedule.control(3).bc = bc;
        % schedule = simpleSchedule(dt, 'w', wells1);
   

    elseif simcase.usedeck
        model = simcase.model;
        deck = simcase.deck;
        
        if ~isempty(simcase.gridcase)%using non-deck grid with deck-schedule
            deck_simcase = Simcase('deckcase', simcase.deckcase, 'usedeck', true);
            deckmodel = deck_simcase.model;
            deck = simcase.deck;
            schedule = convertDeckScheduleToMRST(deckmodel, deck);
            [cell1, cell2] = simcase.getinjcells;
            %change cells in schedule, and keep everything else
            for i = 1:numel(schedule.control)
                schedule.control(i).W(1).cells = cell1;
                schedule.control(i).W(2).cells = cell2;
            end
        else
            schedule = convertDeckScheduleToMRST(model, deck);
        end
        G = model.G;
        bf = boundaryFaces(G);
        bf = bf(G.faces.centroids(bf, 3) < 1e-12);

        bc = addBC([], bf, 'pressure', 1.1e5, 'sat', [1, 0]);
        for i = 1:numel(schedule.control)
            schedule.control(i).bc = bc;
        end
    else
        schedule = [];
        disp('No schedule assigned.')
    end
end