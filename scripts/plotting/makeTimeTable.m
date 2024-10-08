clear all 
close all
%%
SPEcase = 'B';
% gridcases = {'cp_pre_cut_130x62', 'pre_cut_130x62', '5tetRef3-stretch', 'struct130x62', ''};%pre_cut_130x62, 5tetRef1.2
% gridcases = {'horz_ndg_cut_PG_130x62', 'horz_pre_cut_PG_130x62', 'cart_ndg_cut_PG_130x62', 'cart_pre_cut_PG_130x62'};filename = 'walltimes-nudge-vs-split-C';
gridcases = {'struct130x62', 'horz_pre_cut_PG_130x62', 'cart_pre_cut_PG_130x62', 'horz_ndg_cut_PG_130x62', 'cart_ndg_cut_PG_130x62'};filename = 'walltimes_PG-nudge';
% gridcases = {'horz_ndg_cut_PG_130x62', 'cart_ndg_cut_PG_130x62', 'cPEBI_130x62'};
% gridcases = {'horz_ndg_cut_PG_220x110', 'cart_ndg_cut_PG_220x110', 'cPEBI_220x110'};
% gridcases = {'horz_ndg_cut_PG_819x117', 'cart_ndg_cut_PG_819x117', 'cPEBI_819x117'};filename = 'walltimes_cut-vs-pebi-F';
% gridcases = {'struct819x117', 'horz_ndg_cut_PG_819x117', 'cart_ndg_cut_PG_819x117', 'cPEBI_819x117', '5tetRef0.31'};filename = 'walltimes_struct-cut-pebi-tri-F';
% gridcases = {'struct819x117', 'horz_ndg_cut_PG_819x117', 'cart_ndg_cut_PG_819x117', 'cPEBI_819x117', 'gq_pb0.19', '5tetRef0.31'};filename = 'walltimes_struct-cut-pebi-Q-tri-F';

deckcase = 'B_ISO_C'; %B_ISO_SMALL
% pdiscs = {'', 'cc', 'hybrid-avgmpfa', 'hybrid-ntpfa', 'hybrid-mpfa'};
pdiscs = {'', 'hybrid-avgmpfa', 'hybrid-ntpfa'};
tagcase = '';%normalRock

numcols = numel(gridcases);
numrows = numel(pdiscs);
data = NaN(numrows, numcols);
datarelcell = NaN(numrows, numcols);
decimals = 2;

for ig = 1:numel(gridcases)
    for ip = 1:numel(pdiscs)
        simcase = Simcase('SPEcase', SPEcase, 'deckcase', deckcase, 'usedeck', true, 'gridcase', gridcases{ig}, ...
                                    'tagcase', tagcase, ...
                                    'pdisc', pdiscs{ip});
        try
            wallTime = simcase.getWallTime;
        catch
            wallTime = NaN;
        end
        data(ip, ig) = round(wallTime, decimals);
        datarelcell(ip, ig) = wallTime/simcase.G.cells.num;
    end
end

data(data < 1e-6) = NaN;
T = array2table(data, 'VariableNames', cellfun(@(g)displayNameGrid(g, SPEcase), gridcases, UniformOutput=false), 'RowNames', cellfun(@(p)shortDiscName(p), pdiscs, UniformOutput=false));
datarelcell(datarelcell < 1e-6) = NaN;
mindat = min(datarelcell, [], 'all');
datarelcell = datarelcell / mindat;
%%

datarelcell = round(datarelcell, decimals);
celldatarelcell = cell(numel(pdiscs), numel(gridcases));
for ig = 1:numel(gridcases)
    for ip = 1:numel(pdiscs)
        rawtime = data(ip, ig);
        celldatarelcell{ip, ig} = sprintf('%0.2f (%0.2f)', rawtime, datarelcell(ip, ig));
    end
end
Trelcell = array2table(celldatarelcell, 'VariableNames', cellfun(@(g)displayNameGrid(g, SPEcase), gridcases, UniformOutput=false), 'RowNames', cellfun(@(p)shortDiscName(p), pdiscs, UniformOutput=false));
%%
table2latex(T, fullfile('./../rapport/Tables', [filename, '.tex']));
table2latex(Trelcell, fullfile('./../rapport/Tables', [filename,'_relcell','.tex']));
%%
savename =[filename, '.xlsx'];
writetable(Trelcell,filename, 'WriteRowNames', true)
%%
exportapp(fig, './plotsMaster/Tables/walltimes-pres.pdf')