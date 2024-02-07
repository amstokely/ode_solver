**Installation**
* ```bash
  mkdir build
    ```
* ```bash
    cd build
  ```
* ```bash
    cmake .. -DNetCDF_INCLUDE_DIR=$(nc-config --includedir) -DNetCDF_LIBRARIES=$(nc-config --libs)/libnetcdff.so
  ```
* ```bash
    make
  ```
  
**Usage**

  