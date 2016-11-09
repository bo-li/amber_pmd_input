#!/usr/bin/python

# coding: utf-8

import numpy as np
import scipy.stats as stats
import pylab as plt
import sys


f = file(sys.argv[1])


fdata = np.loadtxt(f)

h = sorted(fdata[:,1])


fit = stats.norm.pdf(h, np.mean(h), np.std(h))


plt.plot(h,fit,'-o')


plt.hist(h,normed=True)


plt.show()





