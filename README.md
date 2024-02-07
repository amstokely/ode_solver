**Installation**

 Clone the ode_solver repository
```bash
git clone https://github.com/amstokely/ode_solver.git
```
Enter the projects root directory,
```bash
cd ode_solver
```
create a build directory
```bash
mkdir build
```
and enter it.
```bash
cd build
```
If netcdf is discoverable by cmake as NetCDF, then run
  ```bash
  cmake ..
  ```
However, if you have a new version of netcdf, which is called netCDF from cmake's perspective, then you have to manually set the netcdf include 
directory and shared library paths. These can be found by running nc-config --includedir and nc-config --libs, respectively. The below command wraps this
into a single cmake command.
```bash
cmake .. -DNetCDF_INCLUDE_DIR=$(nc-config --includedir) -DNetCDF_LIBRARIES=$(nc-config --libs)/libnetcdff.so
```
Now build the project
```bash
make
```
and return to the root directory
```bash
cd ..
```

---
  
<h2>Examples</h2>

<h3>Shallow Water Equations</h3>
* Generate an input NetCDF parameter file using the ```set_params.py``` script
```bash
python set_params.py
```
* This creates an input file called ```params.nc``` which stores the initial conditions, grid size, and dx/dy values used
to solve the shallow water equations.



  