#!/usr/bin/env bash

#SBATCH --account=project_465000538
#SBATCH --mem=0
#SBATCH --partition=standard-g
#SBATCH --time=10:30:00

#SBATCH --ntasks-per-node=8
#SBATCH --gpus-per-node=8
#SBATCH --threads-per-core=2
#SBATCH --nodes=1
#SBATCH -J test
#SBATCH --exclusive

#export OMP_NUM_THREADS=1

export ROCR_VISIBLE_DEVICES=$SLURM_LOCALID

bench="./test-cublas-parallel"

#
# Bind mask for two threads per core
#
MYMASKS2="0x${c}00000000000000${c}000000000000,0x${c}00000000000000${c}00000000000000,0x${c}00000000000000${c}0000,0x${c}00000000000000${c}000000,0x${c}00000000000000${c},0x${c}00000000000000${c}00,0x${c}00000000000000${c}00000000,0x${c}00000000000000${c}0000000000"


case gpaw in

rect)
	#for n in 1000 5000 `seq 10000 10000 1000000`
	for n in 1000 5000 `seq 10000 10000 1000000`
	#for n in 10000
	do
	cmd=(
			srun
			--cpu-bind=mask_cpu:"$MYMASKS2"
			#omnitrace-sample --profile --config $(realpath ./omnitrace.cfg) --
      ${bench}
			-m $n -n $n -k $n
			--its 200
			--complex
	    )
	set -x
	${cmd[@]}
	set +x
	done

	;;

gpaw)

	for i in {1..100}; do
	cmd=(
			srun
      ${bench}
			-m 10000 -n 10000 -k 10000
			--its 500
			--complex
	    )
	set -x
	${cmd[@]}
	set +x
	done
	;;

esac
