#!/bin/bash

interrupt_handler() {
  exit 1
}
trap interrupt_handler SIGINT

function Info() {
  echo -e "\033[32m[Info] $@ \033[0m"
}

function Warning() {
  echo -e "\033[33;3m[Warning] $@ \033[0m"
}

function Error() {
  echo -e "\033[31m[Error] $@ \033[0m"
  exit 1
}

function run_1device_1s_1ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0
} &>$logs_dir/test_run_1device_1s_1ins_${model_name}_${data_type}_${thread_count}_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_1device_1s_1ins_48cores() {
  numa_node_0=0
  numa_node_0_hbm=0
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm 48 0
} &>$logs_dir/test_run_1device_1s_1ins_${model_name}_${data_type}_48_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_1device_1s_2ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 1
} &>$logs_dir/test_run_1device_1s_2ins_${model_name}_${data_type}_${thread_count}_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_1device_1s_4ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 1 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 2 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 3
} &>$logs_dir/test_run_1device_1s_4ins_${model_name}_${data_type}_${thread_count}_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_1device_2s_1ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  numa_node_1=1
  numa_node_1_hbm=1
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_1 $numa_node_1_hbm $thread_count 1
} &>$logs_dir/test_run_1device_2s_1ins_${model_name}_${data_type}_${thread_count}_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_1device_2s_2ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  numa_node_1=1
  numa_node_1_hbm=1
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 1 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_1 $numa_node_1_hbm $thread_count 2 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_1 $numa_node_1_hbm $thread_count 3
} &>$logs_dir/test_run_1device_2s_2ins_${model_name}_${data_type}_${thread_count}_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_2device_1s_1ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  numa_node_1=1
  numa_node_1_hbm=1
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0
} &>$logs_dir/test_run_2device_1s_1ins_${model_name}_${data_type}_${thread_count}_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_2device_1s_1ins_48cores() {
  numa_node_0=0
  numa_node_0_hbm=0
  numa_node_1=1
  numa_node_1_hbm=1
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm 48 0 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm 48 0
} &>$logs_dir/test_run_2device_1s_1ins_${model_name}_${data_type}_48_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_2device_1s_2ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  numa_node_1=1
  numa_node_1_hbm=1
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 1 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 1
} &>$logs_dir/test_run_2device_1s_2ins_${model_name}_${data_type}_${thread_count}_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_2device_1s_4ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  numa_node_1=1
  numa_node_1_hbm=1
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm 12 0 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm 12 1 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm 12 2 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm 12 3 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm 12 0 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm 12 1 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm 12 2 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm 12 3
} &>$logs_dir/test_run_2device_1s_4ins_${model_name}_${data_type}_12_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_2device_2s_1ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  numa_node_1=1
  numa_node_1_hbm=1
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_1 $numa_node_1_hbm $thread_count 1 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_1 $numa_node_1_hbm $thread_count 1
} &>$logs_dir/test_run_2device_2s_1ins_${model_name}_${data_type}_${thread_count}_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_4device_1s_1ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  numa_node_1=1
  numa_node_1_hbm=1
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_C} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_D} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0
} &>$logs_dir/test_run_4device_1s_1ins_${model_name}_${data_type}_${thread_count}_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_4device_1s_1ins_48cores() {
  numa_node_0=0
  numa_node_0_hbm=0
  numa_node_1=1
  numa_node_1_hbm=1
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm 48 0 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm 48 0 : \
    -n 1 -hosts ${IP_C} bash run.sh $numa_node_0 $numa_node_0_hbm 48 0 : \
    -n 1 -hosts ${IP_D} bash run.sh $numa_node_0 $numa_node_0_hbm 48 0
} &>$logs_dir/test_run_4device_1s_1ins_${model_name}_${data_type}_48_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_4device_1s_2ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  numa_node_1=1
  numa_node_1_hbm=1
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 1 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 1 : \
    -n 1 -hosts ${IP_C} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_C} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 1 : \
    -n 1 -hosts ${IP_D} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 0 : \
    -n 1 -hosts ${IP_D} bash run.sh $numa_node_0 $numa_node_0_hbm $thread_count 1
} &>$logs_dir/test_run_4device_1s_2ins_${model_name}_${data_type}_${thread_count}_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

function run_4device_1s_4ins() {
  numa_node_0=0
  numa_node_0_hbm=0
  numa_node_1=1
  numa_node_1_hbm=1
  mpirun -iface=${IFACE} $MPI_DEBUG \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm 12 0 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm 12 1 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm 12 2 : \
    -n 1 -hosts ${IP_A} bash run.sh $numa_node_0 $numa_node_0_hbm 12 3 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm 12 0 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm 12 1 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm 12 2 : \
    -n 1 -hosts ${IP_B} bash run.sh $numa_node_0 $numa_node_0_hbm 12 3 : \
    -n 1 -hosts ${IP_C} bash run.sh $numa_node_0 $numa_node_0_hbm 12 0 : \
    -n 1 -hosts ${IP_C} bash run.sh $numa_node_0 $numa_node_0_hbm 12 1 : \
    -n 1 -hosts ${IP_C} bash run.sh $numa_node_0 $numa_node_0_hbm 12 2 : \
    -n 1 -hosts ${IP_C} bash run.sh $numa_node_0 $numa_node_0_hbm 12 3 : \
    -n 1 -hosts ${IP_D} bash run.sh $numa_node_0 $numa_node_0_hbm 12 0 : \
    -n 1 -hosts ${IP_D} bash run.sh $numa_node_0 $numa_node_0_hbm 12 1 : \
    -n 1 -hosts ${IP_D} bash run.sh $numa_node_0 $numa_node_0_hbm 12 2 : \
    -n 1 -hosts ${IP_D} bash run.sh $numa_node_0 $numa_node_0_hbm 12 3
} &>$logs_dir/test_run_4device_1s_4ins_${model_name}_${data_type}_12_${loop_count}_${beam_width}_${input_length}_${output_length}_${batch_size}.log

############# PATH configuration #############
current_dir=$(pwd)
# workspace_dir=$(echo $current_dir | sed 's|\(.*\/xFasterTransformer\).*|\1|')
workspace_dir=$(echo $current_dir)

logs_dir=$(echo $current_dir/logs/$(date "+%Y-%m-%d-%H-%M-%S"))
mkdir -p $logs_dir

############# workspace environment check #############
# Read the expected version from the external file VERSION
# xft_expected_version=$(head -n 1 ${workspace_dir}/VERSION)
xft_expected_version=2.0.0
transformers_expected_version=4.39.0

# Check if the xfastertransformer software dependency exists in the current Python environment
if ! python3 -c "import xfastertransformer" &>/dev/null; then
  Error "xfastertransformer dependency not found. Please install it 'pip install xfastertransformer==$xft_expected_version'."
fi
# Check if the xfastertransformer software dependency exists in the current Python environment
if ! python3 -c "import transformers" &>/dev/null; then
  Error "transformers dependency not found. Please install it 'pip install transformer==$transformers_expected_version'."
fi

# Get the current installed version of xfastertransformer
xft_current_version=$(pip3 list | grep -E 'xfastertransformer' | awk '{print $2}')
transformers_current_version=$(pip3 list | grep -E 'transformers' | awk '{print $2}')

Info "(xfastertransformer version): $xft_current_version"
Info "(transformers version): $transformers_current_version"

# # Compare version information
# if [ "$xft_current_version" = "$xft_expected_version" ]; then
#   Info "Checkpoint(xfastertransformer version): Current xfastertransformer version: $xft_current_version."
# else
#   Info "Current xfastertransformer version does not match the expected version.
#         Expected version: $xft_expected_version, Current version: $xft_current_version.
#         Please reinstall it 'pip install --force-reinstall xfastertransformer==$xft_expected_version'."
# fi

# if [ "$xft_current_version" = "$xft_expected_version" ]; then
#   Info "Checkpoint(xfastertransformer version): Current xfastertransformer version: $xft_current_version."
# else
#   Info "Current xfastertransformer version does not match the expected version.
#         Expected version: $xft_expected_version, Current version: $xft_current_version.
#         Please reinstall it 'pip install --force-reinstall xfastertransformer==$xft_expected_version'."
# fi

# Check if mpirun command is available
if command -v mpirun &>/dev/null; then
  Info "Checkpoint(mpirun): mpirun command is available."
else
  Error "'mpirun' command not found. Please make sure MPI is installed and mpirun is in the PATH. Please refer to
  https://github.com/intel/xFasterTransformer?tab=readme-ov-file#multi-ranks"
fi

############# HW configuration #############

############# Delete me if you IP is all right #############
Warning "Checkpoint(device IP): Please manually update the IP address of the current testing environment." $0:$LINENO
############################################################

# set your device IP here
IFACE=eno1
IP_A=10.100.103.6
IP_B=10.100.103.5
IP_C=192.168.0.3
IP_D=192.168.0.4

Info "Checkpoint(device IP): IP address set successfully."

# enable it if testing at a cloud environment
# The mapping method for CPU IDs in the cloud server environment is different,
# for example, (0,1), (2,3), (...) where consecutive pairs of CPU IDs belong
# to a single physical core. In this mapping relationship,
# you can set the 'XFT_CLOUD_ENV' variable to '1' to bind to the correct physical core.
export XFT_CLOUD_ENV=0
Warning "Checkpoint(XFT_CLOUD_ENV): Please set the 'XFT_CLOUD_ENV' variable to '1' if testing at a cloud environment.
        Current XFT_CLOUD_ENV=${XFT_CLOUD_ENV}." $0:$LINENO

# sync manual
echo $workspace_dir

# ssh $IP_B "rm -rf $workspace_dir/"
# scp -r $workspace_dir $IP_B:$workspace_dir/

# 加载环境变量
# source /opt/intel/oneapi/setvars.sh --force --ccl-configuration=cpu
source /opt/intel/oneapi/ccl/latest/env/vars.sh --ccl-configuration=cpu

# set OpenMP lib.
# export LD_PRELOAD="/opt/intel/oneapi/2025.1/lib/libiomp5.so"
export $(python3 -c 'import xfastertransformer as xft; print(xft.get_env())')

# todo(marvin): enable HBM flat
enable_hbm=0

# enable log https://www.intel.com/content/www/us/en/docs/mpi-library/developer-reference-linux/2021-11/other-environment-variables.html#GUID-8357A7B3-5494-48AF-AA32-CAA4A778D195
# export I_MPI_DEBUG=1
# export FI_LOG_LEVEL=debug

# enable TCP
export FI_TCP_IFACE=eno1
export I_MPI_OFI_PROVIDER="tcp"
# export I_MPI_OFI_PROVIDER="tcp;ofi_rxm"

# enable eRDMA
# export FI_VERBS_IFACE=eno1
# export FI_PROVIDER="verbs;ofi_rxm"
# export FI_OFI_RXM_USE_SRX=0
# export FI_VERBS_RX_IOV_LIMIT=1

# export FI_OFI_RXM_BUFFER_SIZE=32768

############# OneCCL configuration #############
# export CCL_LOG_LEVEL=debug
# export CCL_ALLREDUCE=recursive_doubling
export CCL_ALLREDUCE="recursive_doubling:0-16384;2d:16385-524288;nreduce:524289-max"
# export CCL_PROCESS_LAUNCHER=none

export CCL_WORKER_COUNT=1

# export CCL_LOCAL_SIZE=0
# export CCL_LOCAL_RANK=0

#for 16 core * 2
#set CCL_WORKER_AFFINITY if necessary
# export CCL_WORKER_AFFINITY=30

############# XFT configuration #############
export XFT_ONECCL=1
# export XFT_ONECCL_BF16=1
export XFT_COMM_TIME=1
export XFT_FAKE_MODEL=1
export XFT_TIMELINE=0

# open for MPI debug information
MPI_DEBUG="-prot -verbose -print-rank-map -print-all-exitcodes"

############# BENCHMARK configuration #############
# batch_sizes=("1" "2" "4" "8" "16" "32")
batch_sizes=("1")
loop_count=1
beam_width=1
# input_lengths=("128" "512" "1024" "2016")
input_lengths=("32")
output_lengths=("128")
thread_counts=("16")
# data_types=("fp16" "bf16" "int8" "bf16_fp16" "bf16_int8")
data_types=("int4")
kv_cache_dtype=("fp16")
# model_paths=$(ls -d $workspace_dir/model_config/qwen2-*/)
model_paths=$(
  ls -d $workspace_dir/DeepSeek-R1-Distill-Qwen-1.5B-gptqmodel-4bit-xft/
  # ls -d $workspace_dir/model_config/qwen2-0_5b/
  # ls -d $workspace_dir/model_config/qwen2-32b/
  # ls -d $workspace_dir/model_config/qwen2-4b/
  # ls -d $workspace_dir/model_config/qwen2-7b/
  # ls -d $workspace_dir/model_config/qwen2-14b/ 
)

############# eval BENCHMARK #############
for model_path in $model_paths; do
  for data_type in "${data_types[@]}"; do
    for input_length in "${input_lengths[@]}"; do
      for batch_size in "${batch_sizes[@]}"; do
        for output_length in "${output_lengths[@]}"; do
          for thread_count in "${thread_counts[@]}"; do
            ######################################################
            export model_name=$(basename "$model_path")
            export data_type=$data_type
            export model_path=$model_path
            export thread_count=$thread_count
            export loop_count=$loop_count
            export beam_width=$beam_width
            export input_length=$input_length
            export output_length=$output_length
            export batch_size=$batch_size
            BENCHMARK="python3 "${current_dir}"/benchmark.py \
                --token_path "${model_path}" \
                --model_path "${model_path}" \
                --prompt_path "${current_dir}"/prompt.json \
                --model_name "${model_name}" \
                --dtype "${data_type}" \
                --kv_cache_dtype "${kv_cache_dtype}" \
                --batch_size "${batch_size}" \
                --token_in ${input_length}	\
                --token_out ${output_length} \
                --beam_width ${beam_width} \
                --iteration ${loop_count} \
                --padding False"
            
            export BENCHMARK=$BENCHMARK
            # echo $BENCHMARK
            # 1 device
            run_1device_1s_1ins
            # run_1device_2s_1ins

            # 2 devices
            # run_2device_1s_1ins
            # run_2device_2s_1ins

            # 4 devices
            # run_4device_1s_1ins

            ######################################################
          done
        done
      done
    done
  done
done
