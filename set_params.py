import netCDF4 as nc
import numpy as np


def generate_splash_conditions(nx, ny, x0, y0, A, sigma, H0=0):
    x = np.linspace(0, nx - 1, nx)
    y = np.linspace(0, ny - 1, ny)
    X, Y = np.meshgrid(x, y)

    # Initial water height with a Gaussian disturbance
    H = H0 + A * np.exp(-((X - x0) ** 2 + (Y - y0) ** 2) / (2 * sigma ** 2))

    # Initial velocities (optional, for simplicity set to 0)
    U = np.zeros_like(H)
    V = np.zeros_like(H)

    return H, U, V

nx, ny = 400, 400  # Domain size
x0, y0 = 50, 200  # Center of the splash
A = 10  # Amplitude of the splash
sigma = 20  # Width of the Gaussian disturbance
H0 = 10  # Background water height

H, U, V = generate_splash_conditions(nx, ny, x0, y0, A, sigma, H0)


Lx = 1E+1
Ly = 1E+1
dx = float(Lx / (nx - 1))
dy = float(Ly / (ny - 1))
domain = np.arange(0, np.pi, np.pi / (nx * ny))

ic = np.zeros(3 * nx * ny, dtype='f4')
ic[0: nx * ny] = U.flatten()
ic[nx * ny: 2 * nx * ny] = V.flatten()
ic[2 * nx * ny:] = H.flatten()

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
