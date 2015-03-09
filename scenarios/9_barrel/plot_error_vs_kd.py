import sys
sys.path.append('../../tool/')
import partmc
import scipy.io
import os
import numpy
import math
import mpl_helper
import matplotlib.pyplot as plt

dataset_name = '0925'
exponent = 0.26
frac_dim = 2.2

ref_data = numpy.loadtxt("rmse_num_"+dataset_name+".dat")
list_kd = []
list_rmse = []
for i in range(0,ref_data.shape[0]):
    if (ref_data[i,2] == exponent and ref_data[i,3] == frac_dim): 
       list_kd.append(ref_data[i,1])
       list_rmse.append(ref_data[i,4])

list_kd, list_rmse = zip(*sorted(zip(list_kd, list_rmse)))

(figure, axes) = mpl_helper.make_fig(colorbar=False)
axes.plot(list_kd, list_rmse, '-bo')
axes.set_xlabel("Prefactor")
axes.set_ylabel(r"Root mean square error")
axes.set_title("exponent = %.2f, fractal dimension = %.1f" %(exponent, frac_dim))
axes.grid()
bbox_props_1 = dict(boxstyle="square,pad=0.3", fc="white", ec="r", lw=1)
axes.annotate('Exp.4', xy=(0.05, 0.05), xycoords='axes fraction',weight='extra bold', size=14, bbox=bbox_props_1)
filename_out = "rmse_vs_kd.pdf"
figure.savefig(filename_out)
