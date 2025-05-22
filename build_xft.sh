rm -rf ./build
mkdir build && cd build
# make clean
export CC=icx
export CXX=icpx
cmake .. \
    -D CMAKE_C_COMPILER=/opt/intel/oneapi/compiler/2025.1/bin/icx \
    -D CMAKE_CXX_COMPILER=/opt/intel/oneapi/compiler/2025.1/bin/icpx \
    -D CMAKE_BUILD_TYPE=Debug \
    -D BUILD_WITH_SHARED_LIBS=OFF \
    -D CMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -D WITH_PIPELINE_PARALLEL=ON \
    -D WITH_TIMELINE=ON \
    -D XFT_BUILD_TESTS=ON
make -j


# Create whl package
# cd <root_directory>
XFT_PYPKG_TYPE=devel python3 setup.py bdist_wheel --verbose --dist-dir=/home/harvey/dev_workspace/
# add tag
XFT_PYPKG_TYPE=release python setup.py egg_info --tag-build="avx512+fp32" bdist_wheel --verbose

# oneCCL Installation
# [Recommended] Use provided scripts to build it from source code.
cd 3rdparty
sh prepare_oneccl.sh
source ./oneccl/build/_install/env/setvars.sh

# 源码编译安装

python setup.py build
mv ./3rdparty/mkl/local/* ./3rdparty/mkl/


python setup.py install
# 开发模式安装
python setup.py develop
# 卸载
python setup.py develop --uninstall


# Here is a example on local.
export $(python -c 'import xfastertransformer as xft; print(xft.get_env())')

OMP_NUM_THREADS=48 mpirun \
  -n 1 numactl -N 0  -m 0 ${RUN_WORKLOAD} : \
  -n 1 numactl -N 1  -m 1 ${RUN_WORKLOAD} 


SINGLE_INSTANCE=1



#AutoGPTQ Installation
https://github.com/AutoGPTQ/AutoGPTQ
git clone https://github.com/PanQiWei/AutoGPTQ.git && cd AutoGPTQ

BUILD_CUDA_EXT=0 CUDA pip install -vvv --no-build-isolation -e .
python setup.py install
