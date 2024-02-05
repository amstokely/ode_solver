import netCDF4 as nc
import numpy as np
from pathlib import Path
from matplotlib import pyplot as plt

fname = Path.cwd() / 'output/output.nc' 
ds = nc.Dataset(fname)
S = np.array(ds.variables['s'][:])
n = int(S.shape[0]/3)
X = S[0:n-1]
Y = S[n:2*n-1]
Z = S[2*n:3*n-1]
fig = plt.figure()
ax = fig.add_subplot(111, projection="3d")
ax.plot(X, Y, Z, lw=0.5)
ax.set_xlabel("X Axis")
ax.set_ylabel("Y Axis")
ax.set_zlabel("Z Axis")
ax.set_title("Lorenz Attractor")
plt.show()
