function cellblocks = getCellblocks(simcase, varargin)
    opt = struct('paddingLayers', 1);
    opt = merge_options(opt, varargin{:});

    if strcmp(simcase.tagcase, 'tpfaTop')
        tpfatop = true;
    else
        tpfatop = false;
    end
    
    paddingLayers = opt.paddingLayers;
    G = simcase.G;
    pdisc = simcase.pdisc;

    [inj1, inj2] = simcase.getinjcells;
    injectionCells = [inj1; inj2];

    tpfaCells = findCellNeighbors(G, injectionCells, paddingLayers);


    if tpfatop && ~isempty(pdisc) && contains(pdisc, 'ntpfa','IgnoreCase', true) && strcmp(simcase.SPEcase, 'A')
        bccells = getbcCells(simcase);
        bccells = findCellNeighbors(G, bccells, paddingLayers);
        tpfaCells = union(tpfaCells, bccells);
    end
    


    otherCells = setdiff((1:G.cells.num)', tpfaCells);

    cellblocks{1} = tpfaCells;
    cellblocks{2} = otherCells;
end


