#!/usr/bin/env bash

set -e

rsync -az ../hppc2024-mpi-io/ ~/modi_mount/Project/hppc2024-mpi-io/

cd ~/modi_mount/Project/hppc2024-mpi-io/

make

for size in 256 512
#for size in  1024
do
# for i in 1 2 4 8 16 24 32 40 48 56 64
for ranks in 1 2 4 8 16 32 64 128 256 512
do
for procs in 1 2
# for procs in 1
do
# nodes=$((($ranks*$procs-1)/64+1))
for nodes in 1 2 4
do

if [[ $(($ranks*$procs)) -ge $(($nodes*64+1)) ]]
then
continue
fi

#trap 'rm job_"$m"_"$procs"_"$ranks".sh' EXIT

# threads=$((($nodes*128)/($ranks/$procs)))
threads=$((($nodes*128)/$ranks))

echo job_"$size"_"$procs"_"$ranks"_"$threads".sh
cat <<EOT > job_"$size"_"$procs"_"$ranks"_"$threads".sh
#!/usr/bin/env bash
#SBATCH --job-name=FWC
#SBATCH --partition=modi_HPPC
#SBATCH --nodes=$nodes --ntasks=$ranks --threads-per-core=2
#SBATCH --cpus-per-task=$procs
#SBATCH --exclusive
#SBATCH --output=slurm_Hyper_size_"$size"_nodes_"$nodes"_ranks_"$ranks"_cpuperrank_"$procs"_ompthreads_"$threads".out

mpiexec apptainer exec ~/modi_images/ucphhpc/hpc-notebook:latest ./ct_parallel --num-voxels $size --input ct_data --out outfile
EOT

# set loop scheduling to static
export OMP_SCHEDULE=static
# Schedule one thread per core. Change to "threads" for hyperthreading
export OMP_PLACES=threads
# Place threads as close to each other as possible
export OMP_PROC_BIND=close
# Set number of OpenMP thread to use (this should be 64 cores / number of ranks pr node)
export OMP_NUM_THREADS=$((($nodes*128)/$ranks))



sbatch job_"$size"_"$procs"_"$ranks"_"$threads".sh
rm job_"$size"_"$procs"_"$ranks"_"$threads".sh
done
done
done
done