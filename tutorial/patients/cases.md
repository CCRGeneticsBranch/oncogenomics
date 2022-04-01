# Cases

A case tab typically consists of a list of side panels:

## Summary

* **Pipeline version**
*   **Samples**

    Sample list has the following columns:

    * **Sample**: sample name.
    * **DNA/RNA**
    * **Experiment type**: exome/panel/RNAseq/ChIPseq/HiC
    * **Platform**: Illumina or others
    * **Library type**: this could be capture kit version or RNAseq library preparation methods (polyA, Access or ribozero)
    * **Tumor/Normal**
    * Other project specific columns.
* **Coverage summary plot:** A cumulative coverage plot.
* **Mutation summary plot:** A bar plot grouped by variant types and tiers.

## Mutation tabs

![](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/mutation.png)

### Mutation types

1. **Germline**: for paired tumor/normal DNA-seq, the variants specific to normal sample.
2. **Somatic**: for paired tumor/normal DNA-seq, the variants specific to tumor sample.
3. **Tumor**: the variants for tumor only DNA-seq samples.
4. **RNAseq**: the RNAseq variants.
5. **Hotspots**: the variants for hotspot mutations only.

### Variant filtering

There are several ways to filter out unwanted variants.

1. **Gene sets**: Use "**Add filter**" button to filter the variants by gene sets.
2. **Show all**: All filtering conditions will be removed.
3. **Reset**: The default cut-off will be restored.
4. **MAF (Minor allele frequency)**: The upper limit of MAF will keep the rare variants only.
5. **Min Total Cov (Minimum total coverage)**: This cut-off will filter out low coverage variants.
6. **Min VAF (Minimum VAF)**: This cut-off will filter out the variants with low VAF.
7. **Tier**: Only the tiers selected will be shown.
8. **Flag**: Only flagged variants will be displayed.
9. **No FP**: Do not show the false positive variants. These are highly recurrent variants in ClinOmics project.
10. **High Conf**: High confident variants.&#x20;

    The definition:

    * **Germline calls**: Only from Haplo caller&#x20;
      * **Panel and Exome**&#x20;
        * Total coverage > 20x and&#x20;
        * Fisher score < 75 and&#x20;
        * VAF >= 0.25&#x20;
    * **Somatic calls**: Only from Mutect and Strelka&#x20;
      * **Exome**&#x20;
        * Tumor total coverage >=20x and&#x20;
        * Normal total coverage >=20x and&#x20;
        * VAF >= 0.10
      * **Panel**&#x20;
        * Tumor total coverage >=50x and&#x20;
        * Normal total coverage >=20x and&#x20;
        * iii. VAF >= 0.05&#x20;

### Variant tiering

Oncogenomics has two tiering systems: germline and somatic. For RNAseq and tumor only samples, both tiering will be reported.

#### Germline

![](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/Germline-Classification--03022017-1.svg)

#### Somatic

![](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/Somatic-Classification--01032017-1.svg)

### Variant annotations

Oncogenomics provides a variety of annotations to help users evaluate the importance of variants. Users can always show/hide columns by clicking "**Select Columns**". The detailed description of these columns:

* **Flag**:
  * ![](https://clinomics.ccr.cancer.gov/clinomics/public/images/circle\_green.png): Not flagged
  * ![](https://clinomics.ccr.cancer.gov/clinomics/public/images/circle\_red.png): Might be false positive variant.
  * ![](https://clinomics.ccr.cancer.gov/clinomics/public/images/info2.png): Flagged in other samples.
* **ACMG Guide**: A simple ACMG form that help users determine the ACMG classification. See [https://www.acmg.net/ACMG/Medical-Genetics-Practice-Resources/Practice-Guidelines.aspx](https://www.acmg.net/ACMG/Medical-Genetics-Practice-Resources/Practice-Guidelines.aspx) for details.
* **Libraries:** By clicking ![](https://clinomics.ccr.cancer.gov/clinomics/public/images/details\_open.png), a caller summary information table will be displayed:
  * **Sample name**.
  * **Experiment type**: Exome/Panel/RNAseq.
  * **Tumor/Normal**.
  * **Caller**.
  * **Qual**: Calling quality.
  * **Fisher score**: the score can be used to determine if strand bias is observed.
  * **Total coverage**: the total read count.
  * **Variant coverage:** the read count with variants.
  * **VAF**: variant allele frequency.
  * **VAF ratio**: tumor VAF/normal VAF.
  * **Relation**: the relation to the target patient.
* **IGV**: display the IGV viewer.

![](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/igv.png)

* **Gene cohort**: the percent of patients having mutations in the same gene.
* **Site cohort**: the percent of patients having mutations at the same site.
* **Caller**: the caller name.
* **Chr**: chromosome of the variant.
* **Start**: start position of the variant (1-based)
* **End**: end position of the variant
* **Ref**: the reference bases
* **Alt**: the mutation bases
* **Region**: exonic/splicing/UTR or intronic.
* **Gene**: gene symbol
* **Exonic function:**&#x20;
  * **SNV**: nonsynonymous mutations (synonymous mutations are pre-filtered)
  * **splicing**: splice site mutations
  * **stopgain**: early stop codon gained
  * **stoploss**: stop codon mutations
  * **frameshift** deletion/insertion: in-frame indels
  * **nonframeshift** deletion/insertion: out-of-frame indels
* **AAChange**: amino acids changes
* **Pecan**: links to St Jude PeCan ([https://pecan.stjude.cloud/](https://pecan.stjude.cloud))
* **CIViC**: CIViC precision medicine info ([https://civicdb.org/home](https://civicdb.org/home))
* **CLIA Actionable**: Actionable mutations defined in:
  * **CanDL**
  * **CLViC**
  * **My Cancer Genome**
  * **NCI MATCH Trail**
* **dbSNP**: dbSNP links
* **MAF (Minor allele frequency)**:  the minor allele frequency in known population:
  * **ExAC/ExAC nonTCGA** ([https://exac.broadinstitute.org/](https://exac.broadinstitute.org))
  * **gnomAD** ([https://gnomad.broadinstitute.org/](https://gnomad.broadinstitute.org))
  * **NCI60** ([https://dtp.cancer.gov/discovery\_development/nci-60/](https://dtp.cancer.gov/discovery\_development/nci-60/))
  * **1000 Genome** ([https://www.internationalgenome.org/1000-genomes-summary](https://www.internationalgenome.org/1000-genomes-summary))
* **Prediction**: prediction tool results
  * **CADD** ([https://cadd.gs.washington.edu/](https://cadd.gs.washington.edu))
  * **fathmm** ([http://fathmm.biocompute.org.uk/](http://fathmm.biocompute.org.uk))
  * **MA** (MutationAssessor, [http://mutationassessor.org/r3/](http://mutationassessor.org/r3/))
  * **PP2HDIV** (PolyPhen-2 HDIV, [http://genetics.bwh.harvard.edu/pph2/](http://genetics.bwh.harvard.edu/pph2/))
  * **PP2HVAR** (PolyPhen-2 HVAR, [http://genetics.bwh.harvard.edu/pph2/](http://genetics.bwh.harvard.edu/pph2/))
  * **PROVEAN** ([http://provean.jcvi.org/index.php](http://provean.jcvi.org/index.php))
  * **SIFT** ([https://sift.bii.a-star.edu.sg/](https://sift.bii.a-star.edu.sg))
  * **VEST** ([https://karchinlab.org/apps/appVest.html](https://karchinlab.org/apps/appVest.html))
* **Clinvar**: the Clinvar results:
  * **Accession**
  * **Review status:** ([https://www.ncbi.nlm.nih.gov/clinvar/docs/review\_status/](https://www.ncbi.nlm.nih.gov/clinvar/docs/review\_status/))
  * **Significance:** ([https://www.ncbi.nlm.nih.gov/clinvar/docs/clinsig/](https://www.ncbi.nlm.nih.gov/clinvar/docs/clinsig/))
  * **Disease name**
  * **Pubmed ID**
  * **VarID:** Varant ID
* **Clinvar badged** ([https://www.clinicalgenome.org/tools/clinical-lab-data-sharing-list/](https://www.clinicalgenome.org/tools/clinical-lab-data-sharing-list/))
* **Cosmic**: ([https://cancer.sanger.ac.uk/cosmic](https://cancer.sanger.ac.uk/cosmic))
* Reported: the number of patients reported mutations from:
  * **cBioPortal/TCGA:** ([http://www.cbioportal.org/](http://www.cbioportal.org))
  * **ICGC** ([https://dcc.icgc.org/](https://dcc.icgc.org))
  * **GENIE** ([https://www.aacr.org/professionals/research/aacr-project-genie/aacr-project-genie-data/](https://www.aacr.org/professionals/research/aacr-project-genie/aacr-project-genie-data/))
  * **Pediatric Cancer Genome** (compiled by Dr. Javed Khan's lab)
* **HGMD** ([http://www.hgmd.cf.ac.uk/ac/index.php](http://www.hgmd.cf.ac.uk/ac/index.php))
* **Intervar** ([https://wintervar.wglab.org/](https://wintervar.wglab.org))
* **OncoKB** ([https://www.oncokb.org/](https://www.oncokb.org))
* **Loss of function**: if variants are:
  * splicing variants
  * stopgain/stoploss variants
  * indels
* **Total coverage**: the total read count.
* **Variant coverage:** the read count with variants.
* **VAF**: variant allele frequency (variant coverage/total coverage).
* **VAF ratio**: tumor VAF/normal VAF.
* **Matched total coverage**: Matched DNA/RNA read count.
* **Normal total coverage**: Matched normal DNA read count.

## CNV **(Copy Number Variants)**

Oncogenomics support two CNV tools: Sequenza ([https://cran.r-project.org/web/packages/sequenza/vignettes/sequenza.html](https://cran.r-project.org/web/packages/sequenza/vignettes/sequenza.html)) and CNVkit ([https://cnvkit.readthedocs.io/en/stable/](https://cnvkit.readthedocs.io/en/stable/)). Sequenza requires tumor/normal paired samples. CNVkit recommends combining all normal samples into a "pooled reference".

### Sequenza

Sequenza is a tool to analyze genomic sequencing data from paired normal-tumor samples, including cellularity and ploidy estimation; mutation and copy number (allele-specific and total copy number) detection, quantification and visualization.

* **Genome View PDF:** Genome-whide visualization of the allele-specific and absolute copy number results, and raw profile of the depth ratio and allele frequency.&#x20;

![Allele-specific copy number](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/sequenza\_allele.png)

![Absolute copy number](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/sequenza\_total.png)

![Depth ratio and allele frequency](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/sequenza\_raw.png)

* **Chromosome View PDF:** Visualization per chromosome of depth.ratio, B-allele frequency and mutations, using the selected or estimated solution. One chromosome per slide

![](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/sequenza\_chr.png)

*   **Table View:**

    The Sequenza CNV table shows the reported CNV segments and associated genes.&#x20;

    * **Table columns**:
      * **Sample ID:** The sample ID
      * **Chromosome**: The chromosome of the segment
      * **Start**: The start coordinate of the segment
      * **End**: The end coordinate of the segment
      * **Length**: The length of the segment in MB
      * **CNt**: Estimated total copy number value
      * **Allele A**: Estimated number of A-alleles
      * **Allele B**: Estimated number of B-alleles (minor allele)
      * **Hotspot Genes**: The [hotspot gene list](../gene-sets.md#hotspot-genes)
      * **Gene list**: All genes in the segment
    * **Filtering**:
      * **Gene set**: Use "Add filter" button to add gene set filtering
      * **Copy number**: Use "Any", ">=", "<="  or "=" to set the copy number filtering
      * **Show diploid**: Show diploid segments.
    * **Gene Centric View**: Instead of showing gene list in a row, this mode will show one gene per row. Users can use this mode if they look for a gene of interest.
    * **Exact gene search**: By checking "Exact gene match", the search will show exact matches only. This is useful if users do not want to see the partial matched genes.
    * **Summary information**:
      * **Length(Non-diploid/Total)**: The ratio of total non-diploid length to the total length.
      * **A**: Number of non-diploid rows.
      * **C**: Number of chromosome with non-diploid rows.
      * **GI**: Genomic index (A/C)
      * **Segments**: Total number of segments
    * **Expression plot**: It is useful to see the expression level of the genes. By clicking the gene links in gene list/hotspot genes, a sorted scatter expression plot will be displayed. The big red circle represents the current sample. This plot shows the distribution of the expression level (log(TPM+1)) in the current project.



![](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/cnv\_exp.png)

### CNVkit

CNVkit is a software toolkit to infer and visualize copy number from high-throughput DNA sequencing data. It is designed for use with hybrid capture, including both whole-exome and custom target panels, and short-read sequencing platforms such as Illumina and Ion Torrent.

* **Genome View**:

![Genome-wide log2 ratio plot](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/cnvkit\_genome.PNG)

Scrolling down this tab, users will see the interactive plots for each chromosome. These interactive views were created by [reconCNV](https://github.com/rghu/reconCNV). Users can see the gene list when hovering the mouse pointer over the segment dots.

![reconCNV view](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/cnvkit\_chr.png)

* **Table View**:
  * **Chromosome**: The chromosome of the segment
  * **Start**: The start coordinate of the segment
  * **End**: The end coordinate of the segment
  * **Length**: The length of the segment in MB
  * **log2**: Weighted mean of log2 ratios of the segment
  * **Depth**: Weighted mean of un-normalized read depths of the segment
  * **Probes**: Weighted mean of number of probes in the segment
  * **Weight**: The sum of the weights of the bins supporting the segment
  * **Hotspot Genes**: The [hotspot gene list](../gene-sets.md#hotspot-genes)
  * **Gene list**: All genes in the segment
*   **Gene Centric View**:

    Instead of showing gene list in a row, this mode will show one gene per row. Users can use this mode if they look for a gene of interest.
* **Exact gene search**: By checking "Exact gene match", the search will show exact matches only. This is useful if users do not want to see the partial matched genes.
* **Expression plot**: It is useful to see the expression level of the genes. By clicking the gene links in gene list/hotspot genes, a sorted scatter expression plot will be displayed. The big red circle represents the current sample. This plot shows the distribution of the expression level (log(TPM+1)) in the current project.

## TIL

We use [TcellExTRECT ](https://github.com/McGranahanLab/TcellExTRECT)a WES based tool to estimate T cell fractions.&#x20;

* **Status**: OK or not enough coverage.
* **Fraction**: The estimated T cell fraction(0 to 1)
* **Purity**: Tumor purity estimated by Sequenza.
* **Ploidy**: The tumor ploidy estimated by Sequenza.

**TCRA plot**: The visualization output from T Cell ExTRECT. This can be very useful to check that everything is working. The following produces the pre and post GC corrected versions of the log ratio within the TCRA loci, reads are coloured by the class of VDJ segment they are, e.g. TCRA-V segments are blue. Note that the TCRA loci also includes segments related to TCR delta (TCRD or TRD), e.g. TCRD-V. Vertical dotted lines represent the regions of the genome used for the normalised baseline (Norm region start and Norm region end) as well as the 'Focal region' that is used in the calculation of the TCRA fraction as the location we expect to see maximum signal. ([https://github.com/McGranahanLab/TcellExTRECT](https://github.com/McGranahanLab/TcellExTRECT))

![](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/tcell.png)

## Fusions

Oncogenomics uses [fustionTools ](https://github.com/CCRGeneticsBranch/fusionTools)to annotation fusion reports. In short, the features of fusionTools are:

1. Determine the fusion cDNA and protein sequences
2. Determine the fusion type (in-frame, out-of-frame or right gene intact)
3. Tier the importance of the fusion events
4. Visualize the results in html format

### Output table

By default, the main table shows the fusion results from **canonical transcripts** (even the canonical transcripts do not output predicted fusion protein products).

* **Details**: By clicking ![](https://clinomics.ccr.cancer.gov/clinomics/public/images/details\_open.png), a detailed transcript level table will be displayed. This table is sorted by protein length. Please note the transcript pairs that do not generate fusion protein will not be shown here. Also, it is possible different transcript pairs produce the same protein sequences.

![](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/fusion.png)

By clicking another ![](https://clinomics.ccr.cancer.gov/clinomics/public/images/details\_open.png) in the detailed table, a fusion plot will be shown:

![](https://github.com/CCRGeneticsBranch/fusionTools/raw/main/plot.png)

The plot shows both fusion DNA and proteins. The domains are predicted using Pfam. The bottom of the plot is the predicted cDNA and protein sequence.

![](https://github.com/CCRGeneticsBranch/fusionTools/raw/main/sequences.png)

* **IGV**: Checking IGV viewer is always a good way to make sure the fusion event is real. The IGV window will split into two parts: the upstream part will be on the left and downstream part will be on the right. By default, the soft-clipping option is on. The soft-clipping sequences are usually fusion counterpart sequences.

![](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/fusion\_igv.png)

* **Left gene:** The gene symbol of left (5 prime end) gene. ![](https://clinomics.ccr.cancer.gov/clinomics/public/images/flame.png) means this gene belongs to [Sanger curated and Mitelman fusion genes](../gene-sets.md#sanger-and-mitelman-fusion-genes). ![](https://clinomics.ccr.cancer.gov/clinomics/public/images/circle\_red.png)means this gene belongs to [Clinomics cancer genes](../gene-sets.md#clinomics-cancer-genes).
* **Right gene**: The gene symbol of right (3 prime end) gene.![](https://clinomics.ccr.cancer.gov/clinomics/public/images/flame.png) means this gene belongs to [Sanger curated and Mitelman fusion genes](../gene-sets.md#sanger-and-mitelman-fusion-genes). ![](https://clinomics.ccr.cancer.gov/clinomics/public/images/circle\_red.png)means this gene belongs to [Clinomics cancer genes](../gene-sets.md#clinomics-cancer-genes).
* **Left Chr**: The left gene chromosome
* **Left Position**: The breakpoint position of left gene.
* **Right Chr**: The rihgt gene chromosome
* **Right Position**: The breakpoint position of right gene.
* **Tools**: The original fusion callers and spanning read count. For Arriba, there will be three numbers: (split reads in left gene, split reads in right gene and discordant reads). The gene to which the longer segment of the split read aligns is defined as the anchor.
* **Type**:
  * **In-frame**: The frame is intact in right gene.&#x20;
  * **Out-of-frame**: The frame is shifted in right gene. An early stop codon is expected.
  * **Right gene intact**: the breakpoint of right gene is before the start codon. These fusion events might produce whole right gene proteins but use the left gene promoters.
  * **No proteins**. If the breakpoint is in intronic regions, 3/5 UTRs or intergenic regions, no protein sequences will be reported with the following two exceptions:
    * Right gene intact
    * The breakpoint is intronic but very close to splice sites (<100bp). In this case, Oncogenomics will try to rescue this fusion by using intronic sequences.
* **Var level**: The fusion tiering.

![](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/fusion\_tier.png)

* **Left region**: The left breakpoint regions in canonical transcript(exon, introns, UTR or upstream intergenic, downstream intergenic).
* **Right region**: The right breakpoint regions in canonical transcript (exon, introns, UTR or upstream intergenic, downstream intergenic).
* **Canonical left trans**: The Ensembl canonical transcript accession of the left gene
* **Canonical right trans**: The Ensembl canonical transcript accession of the right gene

## Expression

Expression tab shows the RNAseq expression level as log2 TPM. If the RNAseq sample has corresponding Exome sample, the Sequenza estimated copy number column will be added to the expression table. By clicking TPM or  copy number link, the sorted scatter plot of project level logTPM or copy number will be shown in a popup window.

![](https://clinomics.ccr.cancer.gov/clinomics/public/images/tutorial/exp\_cnv.png)

## Signature

## HLA

## Neoantigen

## Circos

## Download

## QC
