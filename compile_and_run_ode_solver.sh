NAME_LIST_FILE=$(pwd)/ode_solver.cfg
cd build; make restore_namelist; make configure_namelist; make clean; rm -rf *; cmake ..; make; make;
cd ../bin; ./lorenz ${NAME_LIST_FILE};
cd ..; python vis_results.py;
rm output/output.nc;
