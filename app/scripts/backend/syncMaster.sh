#/bin/bash
export PATH=/mnt/nasapps/development/perl/5.28.1/bin:$PATH
script_file=`realpath $0`
script_path=`dirname $script_file`
html_home=`realpath ${script_path}/../../../..`
script_home_dev=${html_home}/clinomics_dev/app/scripts/backend
script_home_production=${html_home}/clinomics/app/scripts/backend
data_home=${script_home_production}/../../metadata

#clinomics_master_file=$data_home/Sequencing_Tracking_Master_clinomics.txt
#khanlab_master_file=$data_home/Sequencing_Tracking_Master.txt
clinomics_master_file=$data_home/ClinOmics_Sequencing_Master_File_db.txt
khanlab_master_file=$data_home/Sequencing_Tracking_Master_db.txt
other_master_file=$data_home/SequencingMasterFile_OutsidePatients_db.txt
compass_master_file=$data_home/COMPASS_MasterFile.txt
compass_lims_master_file=$data_home/COMPASS_LIMS_MasterFile.txt
tcga_master_file=$data_home/TCGAMaster.txt
gtex_master_file=$data_home/GTEXMaster.txt
gb_master_file=$data_home/gb_master_file.txt
todaysdate=`date "+%Y%m%d-%H%M"`;
if [ ! -f $clinomics_master_file ]
then
	before_clinomics_modify_time=""
else
	before_clinomics_modify_time=`stat --printf=%y $clinomics_master_file`
fi

if [ ! -f $khanlab_master_file ]
then
	before_khanlab_modify_time=""
else
	before_khanlab_modify_time=`stat --printf=%y $khanlab_master_file`
fi

if [ ! -f $other_master_file ]
then
	before_other_modify_time=""
else
	before_other_modify_time=`stat --printf=%y $other_master_file`
fi

if [ ! -f $compass_master_file ]
then
	before_compass_modify_time=""
else
	before_compass_modify_time=`stat --printf=%y $compass_master_file`
fi

if [ ! -f $compass_lims_master_file ]
then
	before_compass_lims_modify_time=""
else
	before_compass_lims_modify_time=`stat --printf=%y $compass_lims_master_file`
fi

if [ ! -f $gb_master_file ]
then
	before_gb_modify_time=""
else
	before_gb_modify_time=`stat --printf=%y $gb_master_file`
fi

echo "Rsync..."
#rsync -aiz biowulf2:/data/khanlab/ref/MasterFile/SequencingMasterFile.txt $data_home/
#rsync -aiz biowulf2:/data/khanlab/ref/MasterFile/Sequencing_Tracking_Master.txt $data_home/
#mnt_data_home=/is2/projects/CCR-JK-oncogenomics/active/data
mnt_data_home=/mnt/projects/CCR-JK-oncogenomics/active/data
rsync -aiz ${mnt_data_home}/SequencingMasterFile_OutsidePatients_db.txt $data_home/
rsync -aiz ${mnt_data_home}/ClinOmics_Sequencing_Master_File_db.txt $data_home/
rsync -aiz ${mnt_data_home}/Sequencing_Tracking_Master_db.txt $data_home/
rsync -aiz helix:/data/Compass/Analysis/ProcessedResults_NexSeq/OncoPilot/COMPASS_MasterFile.txt $data_home/
rsync -aiz helix:/data/Compass/Analysis/ProcessedResults_NexSeq/OncoPilot/COMPASS_LIMS_MasterFile.txt $data_home/
rsync -aiz helix:/data/khanlab3/Erica/ngs_pipeline/gb_master_file.txt $data_home/
#rsync -aiz biowulf2:/data/khanlab/ref/MasterFile/Sequencing_Tracking_Master_clinomics.txt $data_home/
after_khanlab_modify_time=`stat --printf=%y $khanlab_master_file`
after_clinomics_modify_time=`stat --printf=%y $clinomics_master_file`
after_other_modify_time=`stat --printf=%y $other_master_file`
after_compass_modify_time=`stat --printf=%y $compass_master_file`
after_compass_lims_modify_time=`stat --printf=%y $compass_lims_master_file`
after_gb_modify_time=`stat --printf=%y $gb_master_file`

[ "$before_khanlab_modify_time" =  "$after_khanlab_modify_time" ] ; khanlab_modified=$?
[ "$before_clinomics_modify_time" =  "$after_clinomics_modify_time" ] ; clinomics_modified=$?
[ "$before_other_modify_time" =  "$after_other_modify_time" ] ; other_modified=$?
[ "$before_compass_modify_time" =  "$after_compass_modify_time" ] ; compass_modified=$?
[ "$before_compass_lims_modify_time" =  "$after_compass_lims_modify_time" ] ; compass_lims_modified=$?
[ "$before_gb_modify_time" =  "$after_gb_modify_time" ] ; gb_modified=$?
if [ $khanlab_modified = "1" ]
then 
	echo "Testing  master files..." `date`
	echo "$script_home_dev/VerifyMasterFile.pl -i $khanlab_master_file"
	perl $script_home_dev/VerifyMasterFile.pl -i $khanlab_master_file

fi
msg=' '
msg="$msg Khanlabmodified = $khanlab_modified ($after_khanlab_modify_time vs $before_khanlab_modify_time)"
msg="$msg\nClinomics_modified? $clinomics_modified ($after_clinomics_modify_time vs $before_clinomics_modify_time";
msg="$msg\nOther modified? $other_modified ($after_other_modify_time vs $before_other_modify_time)";
msg="$msg\nCompass modified? $compass_modified ($after_compass_modify_time vs $before_compass_modify_time)";
msg="$msg\nCompass LIMS modified? $compass_lims_modified ($after_compass_lims_modify_time vs $before_compass_lims_modify_time)";
msg="$msg\nGB modified? $gb_modified ($after_gb_modify_time vs $before_gb_modify_time)";
if [ $khanlab_modified = "1" ] || [ $clinomics_modified = "1" ] || [ $other_modified = "1" ] || [ $compass_modified = "1" ] || [ $compass_lims_modified = "1" ] || [ $gb_modified = "1" ]
then
	echo -e $msg
	echo '------------------'
	echo `date`
	scp $clinomics_master_file $khanlab_master_file $other_master_file $compass_master_file $compass_lims_master_file $gb_master_file helix:/data/Clinomics/MasterFiles/
	echo "Uploading production database..."
	echo "$script_home_production/syncMaster.pl -u -n production -i $clinomics_master_file,$khanlab_master_file,$other_master_file,$compass_master_file,$compass_lims_master_file,$gb_master_file,$tcga_master_file,$gtex_master_file -m $clinomics_modified,$khanlab_modified,$other_modified,$compass_modified,$compass_lims_modified,$gb_modified,0,0"
	perl $script_home_production/syncMaster.pl -u -n production -i $clinomics_master_file,$khanlab_master_file,$other_master_file,$compass_master_file,$compass_lims_master_file,$gb_master_file,$tcga_master_file,$gtex_master_file -m $clinomics_modified,$khanlab_modified,$other_modified,$compass_modified,$compass_lims_modified,$gb_modified,0,0	
	perl $script_home_production/runDBQuery.pl "select distinct patient_id,case_name from sample_case_mapping order by patient_id" > ${data_home}/case_list.txt
	echo "$script_home_production/runDBQuery.pl \"select distinct patient_id,case_name from sample_case_mapping order by patient_id\" > ${data_home}/case_list.txt"
	scp ${data_home}/case_list.txt helix:/data/Clinomics/MasterFiles/
	echo "Uploading development database..."
	echo "$script_home_dev/syncMaster.pl -u -i $clinomics_master_file,$khanlab_master_file,$other_master_file,$compass_master_file,$compass_lims_master_file,$tcga_master_file,$gtex_master_file -m $clinomics_modified,$khanlab_modified,$other_modified,$compass_modified,$compass_lims_modified,0,0"
	perl $script_home_dev/syncMaster.pl -u -i $clinomics_master_file,$khanlab_master_file,$other_master_file,$compass_master_file,$compass_lims_master_file,$gb_master_file,$tcga_master_file,$gtex_master_file -m $clinomics_modified,$khanlab_modified,$other_modified,$compass_modified,$compass_lims_modified,$gb_modified,0,0

	echo "done!";
elif [[ $todaysdate =~ 090[0-6] ]]
then 
	# Run once a day so I know cron is running
	echo "-------------------------";
	echo "Masters files is not updated @$todaysdate" 
	echo -e $msg
	echo "-------------------------";
fi


#select s1.sample_id, s1.patient_id, s1.biomaterial_id, s1.source_biomaterial_id, s1.exp_type, s1.tissue_cat, s1.tissue_type, s2.sample_id as normal_sample from samples s1, samples s2 where s1.patient_id=s2.patient_id and s1.tissue_cat='tumor' and s2.tissue_cat in ('normal','blood') and s1.exp_type=s2.exp_type and s1.platform='Illumina' and s2.platform='Illumina' and s1.relation='self' and s2.relation='self' order by s1.sample_id
#select s1.sample_id, s1.patient_id, s1.biomaterial_id, s1.source_biomaterial_id, s1.exp_type, s1.tissue_cat, s1.tissue_type, s2.sample_id as rna_sample from samples s1, samples s2 where s1.patient_id=s2.patient_id and s1.tissue_cat='tumor' and s1.exp_type <> 'RNAseq' and s2.exp_type='RNAseq' and s1.source_biomaterial_id=s2.source_biomaterial_id and s1.platform='Illumina' and s2.platform='Illumina' and s1.relation='self' and s2.relation='self' order by s1.sample_id
