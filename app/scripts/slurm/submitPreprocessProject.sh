#!/usr/bin/env bash
#SBATCH --partition=norm
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=24:00:00

#example: sbatch /mnt/projects/CCR-JK-oncogenomics/static/site_data/prod/submitPreprocessProject.sh /mnt/projects/CCR-JK-oncogenomics/static/ProcessedResults/update_list/compass_exome_db_20220405-233934_caselist.txt chouh@nih.gov https://oncogenomics.ccr.cancer.gov/production/public
script_file=`realpath $0`
script_home=`dirname $script_file`
$script_home/../preprocessProjectMaster.pl -p $1 -e $2 -u $3 -m -g
