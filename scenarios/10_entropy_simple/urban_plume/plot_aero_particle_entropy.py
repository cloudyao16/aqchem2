#!/usr/bin/env python

import sys, os
sys.path.append("../../../tool")
import mpl_helper
import scipy.io
import numpy as np
import matplotlib.pyplot
from matplotlib.patches import Polygon
from matplotlib.patches import FancyArrowPatch


(figure, axes) = mpl_helper.make_fig(right_margin=0.8)

ncf = scipy.io.netcdf_file("out/urban_plume2_process.nc")
time = ncf.variables["time"].data / 3600

avg_part_entropy = ncf.variables["avg_part_entropy"].data
avg_part_entropy_err = ncf.variables["avg_part_entropy_ci_offset"].data
entropy_of_avg_part = ncf.variables["entropy_of_avg_part"].data
entropy_of_avg_part_err = ncf.variables["entropy_of_avg_part_ci_offset"].data
tot_entropy_ratio = ncf.variables["tot_entropy_ratio"].data

axes.plot(time, avg_part_entropy, "b-", label = r'$\bar{H}$')
axes.plot(time, entropy_of_avg_part, "k:", label = r'$\bar{\hat{H}}$')
axes.plot(time, tot_entropy_ratio, "r--", markersize = 2, label = r'$\gamma$')
axes.set_xlabel(r"time / h")
axes.set_ylabel(r"quantity")
axes.set_xlim([0,48])
axes.set_xticks([0, 6, 12, 18, 24, 30, 36, 42, 48])

axes.annotate(r"$\bar{H}$", (time[42], avg_part_entropy[42]),
              verticalalignment="bottom", horizontalalignment="right",
              bbox = dict(facecolor='white', edgecolor='white'),
              xytext=(0, 5), textcoords='offset points')
axes.annotate(r"$\bar{\hat{H}}$", (time[66], entropy_of_avg_part[66]),
              verticalalignment="bottom", horizontalalignment="right",
              bbox = dict(facecolor='white', edgecolor='white'),
              xytext=(0, 5), textcoords='offset points')
axes.annotate(r"$\gamma$", (time[102], tot_entropy_ratio[102]),
              verticalalignment="bottom", horizontalalignment="right",
              bbox = dict(facecolor='white', edgecolor='white'),
              xytext=(0, 5), textcoords='offset points')

#axes.legend(loc = 'lower right')
axes.grid(True)

figure.savefig("out/urban_plume_particle_entropy_all.pdf")

(figure, axes) = mpl_helper.make_fig(right_margin=0.8)

axes.plot(avg_part_entropy, tot_entropy_ratio, "b-")
axes.set_xlabel(r"$\bar{H}$")
#axes.set_xlim([0,0.7])
#axes.set_xticks([0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7])
#pts = np.array([[0,0], [1.4,1], [0,1]])
#p = Polygon(pts,closed=True,alpha=0.05)
#axes.add_patch(p)
axes.arrow(avg_part_entropy[3],tot_entropy_ratio[3], (avg_part_entropy[4]-avg_part_entropy[3]),(tot_entropy_ratio[4]-tot_entropy_ratio[3]), fc="b", ec="b", head_width=0.03, head_length=0.02)

axes.set_ylabel(r"$\gamma$")
axes.grid(True)
figure.savefig("out/gamma_versus_h_bar.pdf")
