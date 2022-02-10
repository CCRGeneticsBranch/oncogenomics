## Oncogenomics portal

Welcome to the tutorial of Oncogenomics. Oncogenomics is a web-based portal for displaying cancer analysis results such as SNPs calling, copy number analysis, gene fusion and RNAseq expression. Oncogenomics is developed by Dr. Javed Khan's lab at NCI. This portal can visualize results directly from the NGS pipeline: https://github.com/CCRGeneticsBranch/ngs_pipeline-v3.2.2. 
The mission of the Oncogenomics Section is to harness the power of high throughput genomic and proteomic methods to improve the outcome of children with high-risk metastatic, refractory and recurrent cancers. The research goals are to integrate the data, decipher the biology of these cancers and to identify and validate biomarkers and novel therapeutic targets and to rapidly translate our findings to the clinic. For more information about our research, visit the Oncogenomics Section website.

Oncogenomics has two versions: NIH internal site(available on NIH network): https://oncogenomics.ccr.cancer.gov/ Public site: https://clinomics.ccr.cancer.gov/

Tutorial is available on https://hsienchao-chou.gitbook.io/oncogenomics

### installation

Oncogenomics is a PHP Laravel 4.2 based web application. The code can be cloned to any PHP environment:
```
git clone git@github.com:CCRGeneticsBranch/oncogenomics.git
```

#### Config files

There are several config files needed to modified. The template files can be found:

app/config/database.template.php: Laravel database config file
app/config/site.template.php: Site specific config file
app/config/session.template.php: Laravel session config file

Please save them to:

app/config/database.php
app/config/site.php
app/config/session.php

#### Data directories

Users also need to create or assign softlinks to the following locations

app/storage/project_data: Preprocessed project data
app/storage/ProcessedResults: Pipeline results
app/storage/GSEA: GSEA results
app/storage/signout: Case signout folder
app/bin: location of internal tools
public/ref: Genome/transcriptome reference files

#### Setup for Khanlab

For website setup at Khanlab, please run the following command:

1. Internal development site:
```
install.sh /var/www/html/onco.data/config/dev.conf
```

2. Internal production site:
```
install.sh /var/www/html/onco.data/config/prod.conf
```

3. Public site:
```
install.sh /var/www/html/onco.data/config/pub.conf
```

#### Folder permission

Please make sure app/storage folder has group write permission
```
chmod -R g+w app/storage
```

