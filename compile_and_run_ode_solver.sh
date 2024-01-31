
cd build; make clean; cmake ..; make; cd ../bin;
./lorenz /home/astokely/CLionProjects/ode_solver/f90/src/ode_solver.cfg;
cd ../f90/utils; python graph.py;  cd ../../../
