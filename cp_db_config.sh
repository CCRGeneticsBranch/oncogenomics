target_type=$1
target_folder=$2
isNewServer=$3
EXPECTED_ARGS=3
E_BADARGS=65
if [ $# -ne $EXPECTED_ARGS ];
then
	echo "Note: Directories changed for CentOS Server locations"
  echo "Usage: `basename $0` [dev/prod] {destination folder} <0|oldServerName>"
	echo "     example: cp_db_config.sh dev /var/www/html/clinomics/ fr-s-bsg-onc-p"
  echo "if dev, then copies from 'clinomics_dev' under DOCUMENT_ROOT of OLD_SERVER. If prod, copies from 'clinomics'"
  echo "if isNewServer!=0, scp's from \$isNewServer server, otherwise copies from the same server"
	exit $E_BADARGS
fi

mountDir='/mnt/CCR-JK-oncogenomics/static'
sourceDir='/var/www/html'
if [ "$target_type" == "prod" ]
then
	source_folder="${sourceDir}/clinomics"
  xtraDirName='clinomics'
  if [ -e "${target_folder}/app/storage/project_data" ];then 
    echo "target/project_data already exist";
  else
	  ln -s ${mountDir}/project_data ${target_folder}/app/storage/project_data
  fi
elif [ "$target_type" == "dev" ];
then
  xtraDirName='clinomics_dev'
	source_folder="${sourceDir}/clinomics_dev"
  if [ -e "${target_folder}/app/storage/project_data" ];then 
    echo "target/project_data already exists"
  else
	   ln -s ${mountDir}/project_data_dev ${target_folder}/app/storage/project_data
  fi
else 
  source_folder="${sourceDir}/$target_type"
  if [ -e "${target_folder}/app/storage/project_data" ]; then 
    echo "target/project_data already exists"
  else
     ln -s ${mountDir}/project_data_dev ${target_folder}/app/storage/project_data
  fi
fi

echo "sourceDir = $sourcDir";
echo "isNewServer = $isNewServer";
if  [ "$isNewServer" != "0" ]; 
then 
  sourceDir='/var/www/html/clinomics'
  user=`whoami`
  echo '-------------------------'
  echo "[INFO] Important !!! ssh-keygen must be setup for user $user account to copy files over from $isNewServer!!"
  echo '-------------------------'
  if [[ $isNewServer =~ 'fr-s-bsg' ]]; then 
    source_folder="/mnt/webrepo/$isNewServer/htdocs/$xtraDirName"
  else
    source_folder="/var/www/html/$xtraDirName"
  fi
  scp ${user}@${isNewServer}:${source_folder}/app/config/database.php ${target_folder}/app/config/
  scp ${user}@${isNewServer}:${source_folder}/app/config/packages/jacopo/laravel-authentication-acl/database.php ${target_folder}/app/config/packages/jacopo/laravel-authentication-acl/
  scp ${user}@${isNewServer}:${source_folder}/app/config/session.php ${target_folder}/app/config/
  scp ${user}@${isNewServer}:${source_folder}/app/config/site.php ${target_folder}/app/config/
  scp -r ${user}@${isNewServer}:${source_folder}/public/ref ${target_folder}/public
  scp ${user}@${isNewServer}:${source_folder}/app/scripts/backend/getDBConfig.php ${target_folder}/app/scripts/backend/
  scp ${user}@${isNewServer}:${source_folder}/../index.php ${target_folder}/../.
  #These are directories in the storage directory
  scp ${user}@${isNewServer}:${source_folder}/app/storage/meta/ ${target_folder}app/storage/. -r
  scp ${user}@${isNewServer}:${source_folder}/app/storage/survival/ ${target_folder}app/storage/. -r

  ln -s ${mountDir}/GSEA_data ${target_folder}app/storage/GSEA 

else 
  cp ${source_folder}/app/config/database.php ${target_folder}/app/config/
  cp ${source_folder}/app/config/packages/jacopo/laravel-authentication-acl/database.php ${target_folder}/app/config/packages/jacopo/laravel-authentication-acl/
  cp ${source_folder}/app/config/session.php ${target_folder}/app/config/
  cp ${source_folder}/app/config/site.php ${target_folder}/app/config/
  ln -s $sourceDir/onco.data/ref  $target_folder/public/ref
  cp ${source_folder}/app/scripts/lib/getDBConfig.php ${target_folder}/app/scripts/lib/
  #These are directories in the storage directory
  cp ${source_folder}/app/storage/meta/ ${target_folder}/app/storage/. -r
  # echo cp ${source_folder}/app/storage/survival/ ${target_folder}/app/storage/. -r #deprecated??
  ln -s $sourceDir/onco.data/GSEA_data ${target_folder}/app/storage/GSEA 
  cp ${source_folder}/app/config/site.php ${target_folder}/app/config/.
fi
