#!/bin/bash

script_file=`realpath $0`
home=`dirname $script_file`

while read line
do
    if echo $line | grep -F = &>/dev/null
    then
        key=$(echo "$line" | cut -d '=' -f 1)
	    value=$(echo "$line" | cut -d '=' -f 2)
	    #echo "$key-->$value"
        if [ "$key" == "database" ];then 
            echo "cp $value $home/app/config"
            echo "cp $value $home/app/config/packages/jacopo/laravel-authentication-acl/"
            cp $value $home/app/config
            cp $value $home/app/config/packages/jacopo/laravel-authentication-acl/
        fi
        if [ "$key" == "site" ] || [ "$key" == "session" ];then
            echo "cp $value $home/app/config"
            cp $value $home/app/config
        fi
        if [ "$key" == "project_data" ] || [ "$key" == "ProcessedResults" ] || [ "$key" == "GSEA" ] || [ "$key" == "signout" ];then
            echo "ln -s $value $home/app/storage/$key"
            ln -s $value $home/app/storage/$key
        fi
        if [ "$key" == "bin" ];then
            echo "ln -s $value $home/app/bin"
            ln -s $value $home/app/bin
        fi
        if [ "$key" == "ref" ];then
            echo "ln -s $value $home/public/ref"
            ln -s $value $home/public/ref
        fi
    fi
done < $1
chmod -R g+w $home/app/storage
