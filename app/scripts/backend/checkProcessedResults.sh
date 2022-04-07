#!/bin/bash
target_project=$1
EXPECTED_ARGS=1
E_BADARGS=65
export PATH=/mnt/nasapps/development/perl/5.28.1/bin:$PATH
if [ $# -ne $EXPECTED_ARGS ]
then
	echo "Usage: `basename $0` {target project}"
	exit $E_BADARGS
fi

export ADMIN_ADDY='chouh@nih.gov';

script_file=`realpath $0`
script_home=`dirname $script_file`
data_home=${script_home}/../../storage/ProcessedResults
project_file=$script_home/project_mapping.txt
echo "project_file = $project_file";
echo -e "Project\tPath\tPatient_ID\tCase_ID\tBiowulf\tFrederick" > ${data_home}/processed_list/diff_case_list.txt
while IFS=$'\t' read -r -a cols
do
	project=${cols[0]}
	succ_list_path=${cols[1]}
	source_path=${cols[2]}
	project_desc=${cols[3]}
	today_list_path=`echo $succ_list_path | sed 's/new_list/today_list/'`
	echo "working on $project"
	if [ "$target_project" == "$project" ] || [ "$target_project" == "all" ]
	then
		project_home=${data_home}/${project}
		stat -c "%n %Y" $data_home/$project/*/*/successful.txt | awk -F/ 'BEGIN {OFS="\t"}{print $(NF-2),$(NF-1),$NF}' > $data_home/processed_list/fsabcl/case_list_${project}.txt
		bn=`basename ${today_list_path}`
		rsync ${today_list_path} ${data_home}/processed_list/biowulf 2>&1
		awk -F/ 'BEGIN {OFS="\t"}{print $(NF-2),$(NF-1),$NF}' ${data_home}/processed_list/biowulf/$bn | grep successful > ${data_home}/processed_list/biowulf/case_list_${project}.txt
		grep -Fvxf $data_home/processed_list/fsabcl/case_list_${project}.txt $data_home/processed_list/biowulf/case_list_${project}.txt | awk -v prj=$project -v sp=$source_path -F"\t" 'BEGIN{OFS="\t"}{print prj,sp,$1,$2,"Y","N"}'>> ${data_home}/processed_list/diff_case_list.txt
		grep -Fvxf $data_home/processed_list/biowulf/case_list_${project}.txt $data_home/processed_list/fsabcl/case_list_${project}.txt | awk -v prj=$project -v sp=$source_path -F"\t" 'BEGIN{OFS="\t"}{print prj,sp,$1,$2,"N","Y"}'>> ${data_home}/processed_list/diff_case_list.txt

	fi	
done < $project_file
