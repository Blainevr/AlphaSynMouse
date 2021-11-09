# AlphaSynMouse

This repository contains code for a short research placement that explores a mathematical model (the heterodimer model) adapted from Fornari et al [2] of how the protein alpha synuclein spreads throughout the mouse brain. It is unclear what the function of healthy alpha synuclein is, but it is known that this protein can misfold and this misfolded form is present in a range of diseases known as synucleinopathies, which includes Parkinson's disease. It is also now known that there are various misfolded arrangments of the protein known as strains [6] which that these spread differently throughout the mouse brain. This project aims to investigate in silico what factors contribute to this differential spread. 


The main file _Connectome Diffusion Model.m_ contains data which includes:


_WeightMatrix.m_ - contains connection strengths between regions 

_TractLengths.m_- Euclidean distance between centres of masses for different regions

_Volumes.m_      - Volume in voxels of the different regions

All taken from Oh et al (2014) [6]

_Data.m_ contains:

_SpreadData_ which is the by-hand-copied Pser129 scores from Rey et al 2019 [7] for the different strains (Figure 4)

_timepoints_ a vector of time points (in days) where the Pser129 scores were obtained.

This code is easily adapted to other data structured in a similar way, for arbitrary time points, and any other measure of disease burden. 


The main file loads this data, creates several graphical Laplacian's (essentially the graph discretised version of the Laplacian operator) for the different possible axonal directions of travel: retrograde, anterograde and unbiased. After this it creates a grid of bar charts showing the concentrations at the two timepoints for a selection of the strains on the right (retrograde only), and the associated Pser129 score on the left. Arbitrary values are taken for the models two free parameters.

The next section of the main file "%% Range of Behaviours across different parameter values and also directions" collects data about the spread for a range of parameter values and outputs tables of relative intensities of disease burden (scaled misfolded protein concentration) in the form of csv files. A range of spreading patterns is observed. These are scaled so that the PIR brain region has the same intensity for both Pser129 score and also the simulation because this region is consistently infected for all parameter regimes.

These csv files can then be used to create visualisations of the protein's spread using brain-render (https://github.com/brainglobe/brainrender). The software is not included in this repository, but the screenshot producing files are included. Press space once the image as loaded to allow the software to complete the screenshot and represent the next set of data.

This work is the first use of an ODE model including production, clearance, and mouse connectenome data used to to investigate the spread, and thus provides an idea of the relative influence of these parameters on overall spreading pattern. The screenshots included show a visual comparsion between the spread of the different strains in Rey et al's data, and also the spread as simulated. There is a strong similarity between the spread of ribbons and fibrils which appear to mainly go in retrograde direction and the retorgrade simulations. This fits with data in [3] which shows early transmission is best explained by retrograde transport.

The match is less close for the other strains, but anterograde spreads seems to match best.

This project was completed over a 6 week REP funded by MIBTP and supervised by Professor Johannes Boltze.


**References:**


1.   Claudi, Federico, Adam L. Tyson, and Tiago Branco. 2020. “Brainrender. A Python Based Software for Visualisation of Neuroanatomical and Morphological Data.” Cold Spring Harbor Laboratory. https://doi.org/10.1101/2020.02.23.961748.


3.   Fornari Sveva, Schäfer Amelie, Jucker Mathias, Goriely Alain and Kuhl Ellen 2019Prion-like spreading of Alzheimer’s disease within the brain’s connectomeJ. R. Soc. Interface.162019035620190356 http://doi.org/10.1098/rsif.2019.0356


5. Mezias C, Rey N, Brundin P, Raj A. Neural connectivity predicts spreading of alpha-synuclein pathology in fibril-injected mouse models: Involvement of retrograde and anterograde axonal propagation. Neurobiol Dis. 2020;134:104623. doi:10.1016/j.nbd.2019.104623


6.   Oh, S., Harris, J., Ng, L. et al. A mesoscale connectome of the mouse brain. Nature 508, 207–214 (2014). https://doi.org/10.1038/nature13186


7.   Rey, N.L., Bousset, L., George, S. et al. α-Synuclein conformational strains spread, seed and target neuronal cells differentially after injection into the olfactory bulb. acta neuropathol commun 7, 221 (2019). https://doi.org/10.1186/s40478-019-0859-3


Parameters obtained from:

k1: clearance rate of healthy protein, worked out based on half life in https://science.sciencemag.org/content/305/5688/1292.long
k0: production rate of healthy protein, chosen to match baseline levels in https://pubmed.ncbi.nlm.nih.gov/19155272/ given clearance rate k1 
k3: clearance rate of misfolded protein, chosen so system progresses towards disease state

