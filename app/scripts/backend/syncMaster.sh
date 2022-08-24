#/bin/bash
export PATH=/mnt/nasapps/development/perl/5.28.1/bin:$PATH
script_file=`realpath $0`
script_path=`dirname $script_file`
html_home=`realpath ${script_path}/../../../..`
script_home_dev=${html_home}/clinomics_dev/app/scripts/backend
script_home_production=${html_home}/clinomics/app/scripts/backend
data_home=${script_home_production}/../../metadata
todaysdate=`date "+%Y%m%d-%H%M"`;

master_files=()
flags=()
project_groups=()
no_change="Y"

while IFS=$'\t' read -r -a cols
do
	src_file=${cols[0]}
	project_group=${cols[1]}
	file=$(basename $src_file)
	echo -e "$src_file\t$project_group\t$file"
	modify_time=""
	if [ -f $data_home/$file ];then
		modify_time=`stat --printf=%y $data_home/$file`
	fi
	rsync -aiz ${src_file} $data_home/
	new_modify_time=`stat --printf=%y $data_home/$file`
	[ "$modify_time" =  "$new_modify_time" ] ; modified=$?
	if [ $modified = "1" ];then 
		echo "file $file has been changed"
		no_change="N"
	fi
	master_files[${#master_files[@]}]=$data_home/$file
	flags[${#flags[@]}]=$modified
	project_groups[${#project_groups[@]}]=$project_group

done < $data_home/master_files.txt

file_list=$(IFS=, ; echo "${master_files[*]}")
flag_list=$(IFS=, ; echo "${flags[*]}")
project_group_list=$(IFS=, ; echo "${project_groups[*]}")

if [[ $no_change = "N" ]];then
	echo "Uploading production database..."
	echo "$script_home_production/syncMaster.pl -u -n production -i $file_list -m $flag_list -g $project_group_list"
	perl $script_home_production/syncMaster.pl -u -n production -i $file_list -m $flag_list -g $project_group_list
	echo "Uploading development database..."
	echo "$script_home_production/syncMaster.pl -u -n production -i $file_list -m $flag_list -g $project_group_list"
	perl $script_home_production/runDBQuery.pl "select distinct patient_id,case_name from sample_case_mapping order by patient_id" > ${data_home}/case_list.txt
	echo "$script_home_production/runDBQuery.pl \"select distinct patient_id,case_name from sample_case_mapping order by patient_id\" > ${data_home}/case_list.txt"
	scp ${data_home}/case_list.txt helix:/data/Clinomics/MasterFiles/	
	perl $script_home_dev/syncMaster.pl -u -n development -i $file_list -m $flag_list -g $project_group_list
elif [[ $todaysdate =~ 090[0-6] ]]
then 
	# Run once a day so I know cron is running
	echo "-------------------------";
	echo "Masters files is not updated @$todaysdate" 
	echo -e $msg
	echo "-------------------------";
fi
