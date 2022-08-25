#/bin/bash
export PATH=/mnt/nasapps/development/perl/5.28.1/bin:$PATH
script_file=`realpath $0`
script_path=`dirname $script_file`
home=`realpath ${script_path}/../../../..`
script_home_dev=${home}/clinomics_dev/app/scripts/backend
script_home_production=${home}/clinomics/app/scripts/backend
script_home_public=${home}/clinomics_public/app/scripts/backend
data_home=${script_home_production}/../../metadata
todaysdate=`date "+%Y%m%d-%H%M"`;

master_files=()
flags=()
project_groups=()
no_change="Y"

master_file_mapping=$data_home/master_files.txt
projects=$1

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
	if [ -z $projects ];then
		rsync -aiz ${src_file} $data_home/
		new_modify_time=`stat --printf=%y $data_home/$file`
		[ "$modify_time" =  "$new_modify_time" ] ; modified=$?
		if [ $modified = "1" ];then 
			echo "file $file has been changed"
			no_change="N"
		fi
	fi
	master_files[${#master_files[@]}]=$data_home/$file
	flags[${#flags[@]}]=$modified
	project_groups[${#project_groups[@]}]=$project_group

done < $master_file_mapping

file_list=$(IFS=, ; echo "${master_files[*]}")
flag_list=$(IFS=, ; echo "${flags[*]}")
project_group_list=$(IFS=, ; echo "${project_groups[*]}")

if [ -z $projects ];then
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
else
	echo "Uploading public database..."
	echo "$script_home_public/syncMaster.pl -u -n public -i $file_list -m $flag_list -g $project_group_list -p $projects"
	perl $script_home_public/syncMaster.pl -u -n public -i $file_list -m $flag_list -g $project_group_list -p $projects
fi

