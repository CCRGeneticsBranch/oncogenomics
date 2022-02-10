<?php

return array(

	/*
	|--------------------------------------------------------------------------
	| Site specific variables
	|--------------------------------------------------------------------------
	|	
	|
	*/
	'cache' => 0,
	'cache.var' => 0,
	'cache.mins' => 60*24,
	'var.use_table' => 1,	
	'avia' => false,
	#'avia_table' => 'avia.hg19_avia3@abcc_lnk',//PROD; database links have to be checked for each DB 
    #'avia_version' => 'avia.avia_db_ver@abcc_lnk',//PROD
    'avia_table' => 'hg19_annot@aviap_lnk',
    #'avia_table' => 'hg19_annot@pub_lnk',
    'avia_version' => 'avia_db_ver@aviap_lnk',
    'url' => 'https://fsabcl-onc01d.ncifcrf.gov/clinomics/public',
    'url_production' => 'https://oncogenomics.ccr.cancer.gov/production/public',
    'url_dev' => 'https://fsabcl-onc01d.ncifcrf.gov/clinomics_dev/public',
    'R_LIBS' => '/mnt/nasapps/development/R/r_libs/4.0.2/',
    'R_PATH' => '/mnt/nasapps/development/R/4.0.2/bin/',
    'isPublicSite'=>0,
    'projects' => 
    	array(
    		"RNAseq_Landscape_Manuscript" => 
    			array(
    				"GSEA"=>false
    			),                
    		"COG_NCI_UK_RMS" => 
    			array(
    				"GSEA"=>false,
    				"germline"=>true,
    				"somatic"=>true,
    				"rnaseq"=>false,
    				"variants"=>true,
    				"fusion"=>false,
    				"mutation_burden"=>true,
                    "hotspot"=>true,
                    "cnv"=>false,
    				"hotspot"=>true,
    				"expression"=>false,
    				"qc"=>false,
                    "igv"=>true,
    				"download"=>false,
                    "survival_meta_list"=>array("Diagnosis","Cohort","Grouping FP or FN","Risk Group","Anatomic Group","Stage","Sex","Race","Study","ALK","ARID1A","ATM","BCOR","BRAF","CDK4","CDKN2A","CTNNB1","DICER1","ERBB2","FBXW7","FGFR1","FGFR4","HRAS","IGF1R","KRAS","MDM2","MET","MTOR","MYCN","MYOD1","NF1","NRAS","PDGFRA","PIK3CA","PTEN","PTPN11","SOS1","TP53","Tier 1 Lesion count")
    			)
    	),
    // Has to be registered for each site due to callback urls
    'auth'=>array(
            'redirect'=>'https://fsabcl-onc01d.ncifcrf.gov/clinomics/public/login',
            'oauth'=>'https://cilogon.org/oauth2',
            'client_id'=>'cilogon:/client_id/1f20b9575caaff38c161cf58483910ff',
            'client_secrete'=>'hZYxdiWBYb5NuG-ZsKuBGj9oyl4eg3ESBVTT3XhgOWZ8rDOjj3zEHiW0J8ZTYjHO0nFtlQhvoAFdnB8otLOH6Q',
            'scope'=>"email+profile+org.cilogon.userinfo+openid",
            'website'=>'https://cilogon.org/oauth2'
    )
);
