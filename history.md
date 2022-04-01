# Changelog

### March 4, 2022

* Added multiple high confident setting
* Added germline QCI report
* Added QCI project level summary

### February 4, 2022

* Removed redundant samples in TCGA and ICGA
* Renamed the TCGA count to cBioportal count.
* Updated the GENIE count
* Added Cosmic census gene link

### January 20, 2022

* Updated fusion feature
  1. Removed the code from web site. I’ve made independent python scripts which can convert the pipeline fusion output to the processed format. (See [https://github.com/CCRGeneticsBranch/fusionTools](https://github.com/CCRGeneticsBranch/fusionTools))
  2. Use Gencode/ENSEMBL annotation only. Currently annotation: Gencode V37.
  3. Included intronic sequences when the breakpoints are close to the splice sites. The current cutoff is 100bp.
  4. All pipeline fusion results are reported. No filtering applied.
  5. Included RSEM isoform expression if the RSEM files are provided.
  6. No fusion protein will be predicted if the breakpoints are not in CDS.
  7. The default fusion are determined by canonical transcripts.
  8. Exon numbers are provided.
  9. If the breakpoints are not at splice junctions, the sequences between splice sites and breakpoints are provided. This is useful for checking ambiguous breakpoints.
  10. New tiering system.
  11. QCI annotation are included if found.
  12. Spanning read count UI is changed.
  13. Breakpoint regions are provided (CDS, UTR, intron…)
  14. Icons for Sanger fusion/cancer genes.
  15. Pfam domains are updated to latest version.
* Added patient level genotyping
* Added TCellExTRECT if exome results are found
* Tab UI has been changed to bootstrap style
* Added diagnosis list in project page if more than 10

### November 3, 2021

* Added canonical ENSEMBL track to IGV

### October 15, 2021

* Updated IGV.js to v2.10
* Changed the annotation track in IGV to Gencode v38
* Added CNV summary and download in project page

### October 5, 2021

* Added Cosmic mutational signature v3.

### August 10, 2021

* Added [reconCNV ](https://github.com/rghu/reconCNV)for visualization of Sequenza and CNVkit results

### June 22, 2021

* Upgraded [igv.js ](https://igv.org/app/)to 1.0.4.
* Added IGV to fusion data. The soft-clipping is on by default.

### June 4, 2021

* Added QCI filtering

### May 20, 2021

* Added download button for CNVkit page

### May 13, 2021

* Fixed links in mutalyzer and CIViC
* Added Labmatrix search

### April 15, 2021

* Added new columns to RNAseqQC

