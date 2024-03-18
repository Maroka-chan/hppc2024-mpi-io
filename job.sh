#!/usr/bin/env bash
#SBATCH --job-name=MPI-IO
#SBATCH --partition=modi_HPPC
# Set the number of nodes to run on; there are 64 cores / 128 threads per node
#SBATCH --nodes=1
# Set the number of MPI ranks
#SBATCH --ntasks=1
# Set the number of OpenMP threads per rank
#SBATCH --cpus-per-task=4
# Specify if the job will run with (=2) or without (=1) hyperthreading
#SBATCH --threads-per-core=1
##SBATCH --exclusive

# set loop scheduling to static
export OMP_SCHEDULE=static
# Schedule one thread per core. Change to "threads" for hyperthreading
export OMP_PLACES=cores
# Place threads as close to each other as possible
export OMP_PROC_BIND=close

# Set number of OpenMP thread to use (this should be 64 cores / number of ranks pr node)
export OMP_NUM_THREADS=4

# Run the program
mpiexec apptainer exec \
   ~/modi_images/ucphhpc/hpc-notebook:latest \
   ./ct_parallel --num-voxels 256 --input ct_data