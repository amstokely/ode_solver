NAME_LIST_FILE=$(pwd)/ode_solver.cfg
cd build; make clean; cmake ..; make; cd ../bin;
./lorenz ${NAME_LIST_FILE}
cd ../f90/utils; python graph.py;  cd ../../../
