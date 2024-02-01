NAME_LIST_FILE=$(pwd)/ode_solver.cfg
cd build; make restore_namelist; make configure_namelist; make clean; cmake ..; make; make; 
cd ../bin; ./lorenz ${NAME_LIST_FILE};
cd ../; python f90/utils/graph.py --output_dir=$(pwd)/output;

