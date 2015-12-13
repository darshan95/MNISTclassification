#!/bin/bash
#SBATCH -A CVIT
#SBATCH -n 12
#SBATCH -p long
#SBATCH --mem=90000
#SBATCH -C 96g
#SBATCH --error=job.%J.err 
#SBATCH --output=job.%J.out
#SBATCH -t 36:00:00

# Get time as a UNIX timestamp (seconds elapsed since Jan 1, 1970 0:00 UTC)
T="$(date +%s)"

# Do some work here
/scratch/matlab/R2013b/bin/matlab -nodesktop -nodisplay -nosplash -singleCompThread -r main &

wait

T="$(($(date +%s)-T))"
echo "Time in seconds: ${T}"

printf "Pretty format: %02d:%02d:%02d:%02d\n" "$((T/86400))" "$((T/3600%24))" "$((T/60%60))" "$((T%60))"
