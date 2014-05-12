ipython

import sys
sys.path.append("/home2/data/Projects/CPAC_Regression_Test/C-PAC")

import numpy as np
from CPAC.cwas.mdmr import mdmr

# Basics
nsubjs = 68
nperms = 5000

pvals  = np.zeros((2,3))
fstats = np.zeros((2,3))

cpaste

for i in range(2):
	#  Loadup model python starts at 0, so column 2 should be indicated using 1
	model = np.loadtxt("/home/data/Projects/workingMemory/gRAICARAnalysis/modelTest.txt")
	for ji,j in enumerate([1,2,3]):

		cols = [j]
		# Setup Distance Matrix
		dmat = np.loadtxt("/home/data/Projects/workingMemory/gRAICARAnalysis/testDistMatrix%i.txt" % (i+1))

		nsubjs = dmat.shape[0]

		# Compute MDMR
		# Since there is only one distance matrix: pvals and fstats should be length 1
		pvals[i,ji], fstats[i,ji], _, _ = mdmr(dmat.reshape(nsubjs**2,1), model, cols, nperms)
--
np.savetxt('/home/data/Projects/workingMemory/gRAICARAnalysis/pvals.txt', pvals, fmt='%f')


