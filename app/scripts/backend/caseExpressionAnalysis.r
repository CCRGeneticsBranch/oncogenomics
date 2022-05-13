suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(DESeq2))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(pheatmap))
suppressPackageStartupMessages(library(ggrepel))

#example:
#Rscript /var/www/html/clinomics/app/scripts/backend/caseExpressionAnalysis.r \
#   /var/www/html/clinomics/app/storage/ProcessedResults/processed_DATA/SCMC/NaturalProduct/analysis/expression/meta.txt \
#   /var/www/html/clinomics/app/ref/RSEM/gencode.v36lift37.annotation.txt \
#   /var/www/html/clinomics/app/storage/ProcessedResults/processed_DATA/SCMC/NaturalProduct/analysis/expression
#sbatch /var/www/html/clinomics/site_data/scripts/backend/runGSEAPrerank.sh /mnt/projects/CCR-JK-oncogenomics/static/site_data/prod/storage/ProcessedResults/processed_DATA/SCMC/NaturalProduct/analysis/expression/SCMC_neopetrotaurine_C_11uM_6h.rnk /mnt/projects/CCR-JK-oncogenomics/static/site_data/prod/storage/ProcessedResults/processed_DATA/SCMC/NaturalProduct/analysis/expression/

plotPCA<-function(mat, fn, groups, scale=F, topn=1000) {
  v <- apply(mat,1,var)
  if (topn > 0)
    mat <- mat[which(v > sort(v, decreasing = T)[topn]),]
  pca<- prcomp(t(mat), scale = scale)
  pcaImp<-summary(pca)$importance
  scores = as.data.frame(pca$x)
  pdf(fn)
  p <- ggplot(data = scores, aes(x = PC1, y = PC2, label = rownames(scores), color=groups)) +
    geom_hline(yintercept = 0, colour = "gray65") +
    geom_vline(xintercept = 0, colour = "gray65") +
    xlab(paste("PC1 (", round(pcaImp[2,1]*100,0),"%)")) +
    ylab(paste("PC2 (", round(pcaImp[2,2]*100,0),"%)")) +
    geom_point(size=4) +
    geom_text_repel(force=T, alpha = 0.8, size = 3 ) +
    theme(legend.position="bottom", legend.text=element_text(size=6)) +
    #scale_fill_discrete(name="Group") +
    ggtitle("PCA")
  print(p)
  dev.off()
}

Args<-commandArgs(trailingOnly=T)
meta_file<-Args[1]
annotation_file <- Args[2]
out_dir <- Args[3]

dir.create(out_dir, showWarnings = FALSE)

#setwd("X:/hsienchao/oncogenomics/expression/SCMC/NaturalProduct")

meta <- read.table(meta_file, header=T, sep="\t")

anno <- read.table(annotation_file, header=T, sep="\t", fill=T)
count_mats <- anno
tpm_mats <- anno

#making matrix
for (i in c(1:length(meta$File))) {
  file <- meta$File[i]
  sample_id <- meta$SampleID[i]
  sample_name <- meta$SampleName[i]
  data <- as.data.frame(data.table::fread(file, sep="\t", header = TRUE))
  count <- data %>% dplyr::select(gene_id, expected_count)
  tpm <- data %>% dplyr::select(gene_id, TPM)
  if (substr(data$gene_id[1], 1, 4) == "ENSG") {    
    count$gene_id <- gsub("\\.[0-9]*_[0-9]*","",count$gene_id)
    count <- count %>% group_by(gene_id) %>% summarise(expected_count = sum(expected_count))
    tpm$gene_id <- gsub("\\.[0-9]*_[0-9]*","",tpm$gene_id)
    tpm <- tpm %>% group_by(gene_id) %>% summarise(TPM = sum(TPM))
    count_mats <- count_mats %>% inner_join(count, by=c("gene_id"="gene_id"))
    tpm_mats <- tpm_mats %>% inner_join(tpm, by=c("gene_id"="gene_id"))
  } else {
    count_mats <- count_mats %>% inner_join(count, by=c("gene_name"="gene_id"))
    tpm_mats <- tpm_mats %>% inner_join(tpm, by=c("gene_name"="gene_id"))
  }
  colnames(count_mats)[ncol(count_mats)] = sample_name
  colnames(tpm_mats)[ncol(tpm_mats)] = sample_name
}
write.table(count_mats, paste(out_dir,"/expression.count.tsv", sep= ""), sep="\t",row.names = F, col.names=T, quote = FALSE)
write.table(tpm_mats, paste(out_dir,"/expression.tpm.tsv", sep= ""), sep="\t",row.names = F, col.names=T, quote = FALSE)

#making coding matrix
tpm_mats <- tpm_mats %>% dplyr::filter(gene_type == "protein_coding")
tpm_coding <- tpm_mats[,c(8,10:ncol(count_mats))]
tpm_coding <- as.data.frame(tpm_coding %>% dplyr::group_by(gene_name) %>% summarise_all(list(sum)))
rownames(tpm_coding) <- tpm_coding$gene_name
tpm_coding$gene_name <- NULL
write.table(tpm_coding, paste(out_dir,"/expression.tpm.coding.tsv", sep= ""), sep="\t",row.names = T, col.names=NA, quote = FALSE)

count_mats <- count_mats %>% dplyr::filter(gene_type == "protein_coding")
counts <- count_mats[,c(8,10:ncol(count_mats))]
counts <- as.data.frame(counts %>% dplyr::group_by(gene_name) %>% dplyr::summarise_all(list(sum)))
rownames(counts) <- counts$gene_name
counts$gene_name <- NULL
counts <- round(counts)

meta$SampleGroup <- factor(meta$SampleGroup)
rownames(meta) <- meta$SampleID
meta$SampleID <- NULL
meta$File <- NULL
dds <- DESeqDataSetFromMatrix(countData=counts, colData=meta, design=~ SampleGroup)
ntd <- normTransform(dds)
library("vsn")
pdf(paste0(out_dir,"/Mean_SD_plot_without_rlog.pdf"))
meanSdPlot(assay(ntd))
dev.off()
keep <- rowSums(counts(dds)) >= 20
dds <- dds[keep,]
blind <- (nrow(meta) == nlevels(meta$SampleGroup))
rld <- rlog(dds, blind=blind)
rld_mat <- assay(rld)
pdf(paste0(out_dir,"/Mean_SD_plot_with_rlog.pdf"))
meanSdPlot(rld_mat)
dev.off()
sampleDists <- dist(t(rld_mat))
library("RColorBrewer")
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- meta$SampleGroup
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Reds")) )(255)
pdf(paste0(out_dir,"/SampleDistance.pdf"))
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)
dev.off()
plotPCA(rld_mat, paste0(out_dir,"/PCA.pdf"), meta$SampleGroup)

log2FCs <- list()
for(group in levels(meta$SampleGroup)){
  samples <- meta %>% dplyr::filter(SampleGroup == group)
  control_group <- samples$ControlGroup[1]
  if (group == control_group)
    next
  controls <- meta %>% filter(SampleGroup == control_group)
  log2FC <- apply(as.data.frame(rld_mat[,rownames(samples)]), 1, mean)-apply(as.data.frame(rld_mat[,rownames(controls)]), 1, mean)
  log2FCs[[group]] <- log2FC
  log2FC <- data.frame("value"=log2FC)
  rownames(log2FC) <- rownames(rld_mat)
  log2FC <- log2FC %>% dplyr::arrange(desc(value))
  write.table(log2FC, paste0(out_dir,"/",group,".rnk"), col.names = F, row.names = T, quote=F, sep="\t")
  print(group)
}
log2FCs <- as.data.frame(log2FCs)
write.table(log2FCs, paste0(out_dir,"/log2FC.tsv"), col.names = NA, row.names = T, quote=F, sep="\t")

plotPCA(log2FCs, paste0(out_dir,"/PCA_Log2FC.pdf"), colnames(log2FCs))

