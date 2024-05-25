![Project Logo](Media/logo_small.png)
# Fordypningsoppgave/masteroppgave
![animation](Media/BsimPEBI.gif)

## To run files (hopefully):
- Rename 'config-template.JSON' to 'config.JSON' and modify it to suit your setup
    - output_folder: folder where output from simulations are stored
    - spe11utils_folder: folder of the spe11-utils repo (cloned from SINTEF-MRST-BitBucket)
    - decksave_folder: folder to save deck files to (as .mat-files). for example spe11utils_folder\deck, leave as empty string if you don't mind converting from the .DATA file each time (usually doesn't take a lot of time)
    - repo_folder: the folder where this repo is cloned.
    - geo_folder: the folder containing the spe11a.geo file.
    - spe11decks_folder: the folder containing the spe11-decks repo (https://github.com/sintefmath/spe11-decks)
- Run setup.m
    - This adds the scripts-folder as an mrst module called prosjektOppgave and adds it to the path
- Now you should be able run simulations, for example by running 'remoteSims(1)' to run whatever is setup as scenario 1 in 'remoteSims.m', or by modifying f.ex. 'runSims.m' 
    - main parts to change are gridcases and discmethods

## Info
- grid files are stored in ./grid-files
    - file name examples:
        - spe11a_ref3_alg6.m (gmsh file in matlab format. generated from .geo file from 11thSPE-CSP)
            - corresponding gridcase name: "6tetRef3"
            - meshed using gmsh algorithm 6
            - generated with keyword refinement_Factor = 3 (higher refinement -> coarser grid)
        - spe11a_struct280x120.m (gmsh file for structured grid. generated by scripts in 11thSPE-CSP)
            - corresponding gridcase name : "struct280x120"
        - spe11a_semi183x38_0.5_grid.mat (semi-structured grid generated from scripts in Vetle Nevlands master thesis https://github.com/vetlenev/Master-Thesis/tree/main/FluidFlower. resolution 183x38 and 0.5 density in unstructured regions)
        -  corresponding gridcase name: "semi183x154_0.5"

- disc-methods:
    - '' for tpfa
    - 'hybrid-avgmpfa' for tpfa around wells and avgmpfa elsewhere
    - 'hybrid-mpfa' for mpfa around wells and avgmpfa elsewhere
    - 'hybrid-ntpfa' for tpfa around well cells and along top pressure boundary
