#app/scripts/backend/syncPublic.sh <project name>

project_name=$1
url=https://fsabcl-onc01d.ncifcrf.gov/clinomics_public/public
root_dir=/mnt/projects/CCR-JK-oncogenomics/static/clones
pro_dir=$root_dir/clinomics
pub_dir=$root_dir/clinomics_public
sync_dir=$root_dir/clinomics_public/app/storage/ProcessedResults/update_list
suffix=`date +"%Y%m%d-%H%M%S"`

# step 1: sync master file

$pub_dir/app/scripts/backend/syncMaster.sh $project_name

# step 2: get project cases

$pro_dir/app/scripts/backend/getProjectCases.pl -p $project_name > $sync_dir/project_cases_$suffix.tsv

rm ${pub_dir}/app/storage/update_list/*

while IFS=$'\t' read -r -a cols
do
	patient_id=${cols[0]}
	case_id=${cols[1]}
	path=${cols[2]}
	succ_file=$pro_dir/app/storage/ProcessedResults/$path/$patient_id/$case_id/successful.txt
	echo $succ_file
	if [ -f $succ_file ];then
		echo $succ_file >> ${sync_dir}/new_list_${path}.txt
	fi
done < $sync_dir/project_cases_$suffix.tsv


