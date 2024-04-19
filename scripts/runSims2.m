function timings = runSims2(server)
    mrstModule add ad-core ad-props incomp mrst-gui mimetic linearsolvers ...
    ad-blackoil postprocessing diagnostics prosjektOppgave...
    deckformat gmsh nfvm mpfa coarsegrid jutul
    % gridcases = {'tetRef10', 'tetRef8', 'tetRef6', 'tetRef4', 'tetRef2'};
    % schedulecases = {'simple-coarse', 'simple-std'};
    mrstVerbose off
    switch  server
    case 1
        SPEcase = 'C';
        gridcases = {'horz_ndg_cut_PG_50x50x50'};
        schedulecases = {''};
        pdiscs = {'hybrid-avgmpfa', 'hybrid-ntpfa', '', 'cc'};
        uwdiscs = {''};
        deckcases = {'B_ISO_C'};
        tagcase = '';
        resetData = false;
        resetAssembly = false;
        Jutul = false;
        direct_solver = false;
        mrstVerbose off;
    case 2
        SPEcase = 'C';
        gridcases = {'cart_ndg_cut_PG_50x50x50'};
        schedulecases = {''};
        pdiscs = {'hybrid-ntpfa', 'hybrid-avgmpfa', '', 'cc'};
        uwdiscs = {''};
        deckcases = {'B_ISO_C'};
        tagcase = '';
        resetData = false;
        resetAssembly = false;
        Jutul = false;
        direct_solver = false;
    case 3
        SPEcase = 'B';
        gridcases = {'struct819x117', 'horz_ndg_cut_PG_819x117', 'cart_ndg_cut_PG_819x117', 'cPEBI_819x117', 'gq_pb0.19', '5tetRef0.31'};
        schedulecases = {''};
        pdiscs = {'', 'cc', 'hybrid-avgmpfa'};
        uwdiscs = {''};
        deckcases = {'B_ISO_C_54C'};
        tagcase = '';
        resetData = false;
        resetAssembly = false;
        Jutul = false;
        direct_solver = false;
    case 4
        SPEcase = 'B';
        gridcases = {'struct819x117', 'horz_ndg_cut_PG_819x117', 'cart_ndg_cut_PG_819x117', 'cPEBI_819x117', 'gq_pb0.19', '5tetRef0.31'};
        schedulecases = {''};
        pdiscs = {'hybrid-ntpfa'};
        uwdiscs = {''};
        deckcases = {'B_ISO_C_54C'};
        tagcase = '';
        resetData = false;
        resetAssembly = false;
        Jutul = false;
        direct_solver = false;
    case 5
        SPEcase = 'B';
        gridcases = {'struct819x117', 'cPEBI_819x117', 'gq_pb0.19', '5tetRef0.31'};
        schedulecases = {''};
        pdiscs = {'hybrid-mpfa'};
        uwdiscs = {''};
        deckcases = {'B_ISO_C_54C'};
        tagcase = '';
        resetData = false;
        resetAssembly = false;
        Jutul = false;
        direct_solver = false;
    end
    if Jutul, mrstVerbose on,end
    warning('off', 'all');
    timings = struct();
    for ideck = 1:numel(deckcases)
        deckcase = deckcases{ideck};
        for igrid = 1:numel(gridcases)
            gridcase = gridcases{igrid};
            for ischedule = 1:numel(schedulecases)
                schedulecase = schedulecases{ischedule};
                for idisc = 1:numel(pdiscs)
                    pdisc = pdiscs{idisc};
                    for iuwdisc = 1:numel(uwdiscs)
                        uwdisc = uwdiscs{iuwdisc};
                        simcase = Simcase('SPEcase', SPEcase, 'deckcase', deckcase, 'usedeck', true, 'gridcase', gridcase, ...
                            'schedulecase', schedulecase, 'tagcase', tagcase, ...
                            'pdisc', pdisc, 'uwdisc', uwdisc, 'jutul', Jutul);

                        [~, ~, time] = solveMultiPhase(simcase, 'resetData', resetData, 'Jutul', Jutul, ...
                            'direct_solver', direct_solver, 'resetAssembly', resetAssembly);
                        disp(['Done with: ', simcase.casename]);
                        timings.(timingName(simcase.casename)) = time;

                    end
                end
            end
        end
    end
    disp(timings);
    warning('on', 'all');
end
