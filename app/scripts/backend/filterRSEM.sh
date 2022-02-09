script_dir=`dirname "$0"`
for o in ${script_dir}/../../../../onco.data/ProcessedResults/compass_exome/*/*/*/RSEM/*ENS.genes.results;do
	o=`realpath $o`
	i=`echo $o | sed 's/_ENS//g'`;
	echo $i;
	${script_dir}/filterRSEM.pl $i > $o;
done
