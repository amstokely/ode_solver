import netCDF4 as nc
import numpy as np

Lx = 1E+4
Ly = 1E+4
nx = 150
ny = 150
dx = float(Lx / (nx - 1))
dy = float(Ly / (ny - 1))
X = np.random.normal(
    1, 0.4, (nx * ny,)).astype('f4'
                                 ).reshape((nx, ny))
Y = np.random.normal(
    1, 0.4, (nx * ny,)).astype('f4'
                               ).reshape((nx, ny))



ic = np.zeros(3 * nx * ny, dtype='f4')
ic[:nx * ny] = X.flatten()
ic[nx * ny:2 * nx * ny] = Y.flatten()
ic[2 * nx * ny:] = np.random.rand(nx * ny).astype('f4')


ds = nc.Dataset('params.nc', 'w', format='NETCDF4')
ds.createDimension('n', 1)
nc_nx = ds.createVariable('nx', 'i4', dimensions=('n',))
nc_nx[:] = nx
nc_ny = ds.createVariable('ny', 'i4', dimensions=('n',))
nc_ny[:] = ny
nc_dx = ds.createVariable('dx', 'f4', dimensions=('n',))
nc_dx[:] = dx
nc_dy = ds.createVariable('dy', 'f4', dimensions=('n',))
nc_dy[:] = dy
ic_dim = ds.createDimension('ic_dim', 3 * nx * ny)
nc_ic = ds.createVariable('ic', 'f4', ('ic_dim',))
nc_ic[:] = ic
ds.close()
