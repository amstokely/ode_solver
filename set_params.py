import netCDF4 as nc

ds = nc.Dataset('params.nc', 'w', format='NETCDF4')
ds.createDimension('n', 1)
sigma = ds.createVariable('sigma', 'f4', )
sigma[:] = [10.0]
rho = ds.createVariable('rho', 'f4', )
rho[:] = [28.0]
beta = ds.createVariable('beta', 'f4', )
beta[:] = [8.0 / 3.0]
x0 = ds.createVariable('x0', 'f4', )
x0[:] = [10.0]
y0 = ds.createVariable('y0', 'f4', )
y0[:] = [0.0]
z0 = ds.createVariable('z0', 'f4', )
z0[:] = [10.0]
ds.close()

