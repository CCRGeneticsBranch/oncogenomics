#!/bin/bash

script_file=`realpath $0`
script_home=`dirname $script_file`

d=$1
rm $d/gsea*.txt
genesets=( NCI c2 c6 CytoSig )
for geneset in "${genesets[@]}"
do
	for fn in $d/*_weighted_${geneset}*/*/gsea_report_for*.xls;do
		bn=$(basename $fn);
		echo $fn | perl -ne 'm/.*\/(.*)\.rnk_weighted_.*/;print "${1}\t$_"' >> $d/gsea_${geneset}_meta_weighted.txt;
	done
	Rscript $script_home/mergeGSEAwithFDR.R $d/gsea_${geneset}_meta_weighted.txt GSEA_weighted_${geneset}

done
