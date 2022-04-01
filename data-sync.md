---
description: Description of how Oncogenomics syncs data daily
---

# Data sync

### On biowulf

* At 23:00 daily, a cron job script **/data/khanlab/projects/updatedSync/check\_processed\_runs.sh** is launched to gather all newly processed cases from pipeline.
* &#x20;The path of project location is defined in **/data/khanlab/projects/updatedSync/projects.txt**

| Project         | Path                                                               |
| --------------- | ------------------------------------------------------------------ |
| processed\_DATA | /data/khanlab/projects/processed\_DATA/                            |
| clinomics       | /data/khanlab2/ProcessedResults\_TGEN/                             |
| wulab           | /data/Wulab/processed\_DATA/                                       |
| Acc\_19         | /data/Acc\_19/processed\_DATA/                                     |
| BeatCC          | /data/khanlab3/BeatCC/processed\_DATA/                             |
| compass\_tso500 | /data/Compass/Analysis/ProcessedResults\_NexSeq/OncoPilot/         |
| compass\_exome  | /data/Compass/Analysis/ProcessedResults\_NexSeq/ExomeRNA\_Results/ |

* For each project, three files will be generated in **/data/khanlab/projects/updatedSync/update\_list2**:
  1. new\_list\_\[project name].txt
  2. today\_list\_\[project name].txt
  3. yesterday\_list\_\[project name].txt
  4.  The logic of **check\_processed\_runs.sh:**

      * Copy **today\_list.txt** to **yesterday list.txt**
      * Save timestamp (with format "Y") of all **successful.txt** and **failed\_delete.txt** to **today\_list.txt** using **stat** command
      * Save the difference between **today\_list.txt** and **yesterday list.txt** to **new\_list.txt**



### On Frederick server (fsabcl-onc01d)

*   At 2:00 daily, a cron job script "**/var/www/html/clinomics/app/scripts/backend/syncProcessedResults.sh all db all**" is launched to sync and upload the data to database.

    * Sync "new\_list.txt" on biowulf (defined in **/var/www/html/clinomics/app/scripts/backend/project\_mapping.txt**) to **/var/www/html/onco.data/ProcessedResults/update\_list**
    * For each case, sync data to **/var/www/html/onco.data/ProcessedResults/**
    * Run script **/var/www/html/clinomics/app/scripts/backend/deleteCase.pl** to delete cases with "**failed\_delete.txt**"
    * Run script **/var/www/html/clinomics/app/scripts/backend/loadVarPatients.pl** to upload cases with "**successful.txt**" to database&#x20;
    * Run script **/var/www/html/clinomics/app/scripts/backend/refreshViews.pl** to refresh materialized views on Oracle database
    * Run script **/var/www/html/clinomics/app/scripts/backend/updateVarCases.pl** to determine the case name (defined in master file) for the processed cases


* At 5:00 daily, a cron job script "**/var/www/html/clinomics/app/scripts/backend/syncProcessedResults.sh all bam all**" is launched to sync BAM files.
* At 10:00 daily, a cron job script "**/var/www/html/clinomics/app/scripts/backend/syncProcessedResults.sh all tier all**" is launched to update variants tiering based on AVIA annotation. (This should be launched after AVIA processing is finished)
