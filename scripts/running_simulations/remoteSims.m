%used for running simulations on remote computer
function timings = remoteSims(server)

    % gridcases = {'tetRef10', 'tetRef8', 'tetRef6', 'tetRef4', 'tetRef2'};
    % schedulecases = {'simple-coarse', 'simple-std'};
    mrstVerbose off
    switch  server
        case 1
            SPEcase = 'C';
            gridcases = {'flat_tetra'};
            schedulecases = {''};
            pdiscs = {''};
            uwdiscs = {''};
            deckcases = {'B_ISO_C'};
            tagcase = '';
            resetData = false;
            resetAssembly = true;
            do.runSimulation = true;
            Jutul = true;
            direct_solver = false;
        case 2
            SPEcase = 'C';
            gridcases = {'tet_zx10-F'};
            schedulecases = {''};
            pdiscs = {'', 'hybrid-avgmpfa','hybrid-ntpfa', 'hybrid-mpfa'};
            uwdiscs = {''};
            deckcases = {'B_ISO_C'};
            tagcase = '';
            resetData = false;
            resetAssembly = true;
            do.runSimulation = true;
            Jutul = false;
            direct_solver = false;
        case 3
            SPEcase = 'B';
            gridcases = {'5tetRef0.3', '5tetRef0.21', '5tetRef0.175'};
            schedulecases = {''};
            pdiscs = {'', 'hybrid-avgmpfa', 'hybrid-mpfa'};
            uwdiscs = {''};
            deckcases = {'RS'};
            tagcase = '';
            resetData = false;
            resetAssembly = true;
            do.runSimulation = true;
            Jutul = false;
            direct_solver = false;
        case 4
            SPEcase = 'B';
            gridcases = {'struct420x141', 'struct840x141'};
            schedulecases = {''};
            pdiscs = {'', 'hybrid-avgmpfa'};
            uwdiscs = {''};
            deckcases = {'RS'};
            tagcase = '';
            resetData = false;
            resetAssembly = true;
            do.runSimulation = true;
            Jutul = false;
            direct_solver = false;
        case 'test'
            SPEcase = 'A';
            gridcases = {'5tetRef10'};
            schedulecases = {''};
            pdiscs = {''};
            uwdiscs = {''};
            deckcases = {'RS'};
            tagcase = 'test';
            resetData = false;
            resetAssembly = true;
            do.runSimulation = true;
            Jutul = false;
            direct_solver = false;
        case 'august'
            SPEcase = 'A'; gridcases = {'5tetRef2'};
            % SPEcase = 'B'; gridcases = {'5tetRef0.8'};
            schedulecases = {''};
            pdiscs = {'', 'hybrid-avgmpfa'};
            uwdiscs = {'WENO'};
            deckcases = {'RS'};
            tagcase = '';
            resetData = false;
            resetAssembly = true;
            do.runSimulation = true;
            Jutul = false;
            direct_solver = false;
    end
    
    timings = struct();
    for ideck = 1:numel(deckcases)
        deckcase = deckcases{ideck};
        for igrid = 1:numel(gridcases)
            gridcase = gridcases{igrid};
            for ischedule = 1:numel(schedulecases)
                schedulecase = schedulecases{ischedule};
                for ipdisc = 1:numel(pdiscs)
                    pdisc = pdiscs{ipdisc};
                    for iuwdisc = 1:numel(uwdiscs)
                        uwdisc = uwdiscs{iuwdisc};
                        simcase = Simcase('SPEcase', SPEcase, 'deckcase', deckcase, 'usedeck', true, 'gridcase', gridcase, ...
                                        'schedulecase', schedulecase, 'tagcase', tagcase, ...
                                        'pdisc', pdisc, 'uwdisc', uwdisc);
                        if do.runSimulation
                            [ok, status, time] = runSimulation(simcase, 'resetData', resetData, 'Jutul', Jutul, ...
                                                'direct_solver', direct_solver, 'resetAssembly', resetAssembly);
                            disp(['Done with: ', simcase.casename]);
                            timings.(timingName(simcase.casename)) = time;
                        end
                    end
                end
            end
        end
    end
    disp(timings);
