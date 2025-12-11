############################################################
# Script: count_to_TPM_FPKM.R
# Purpose:
#   - 从基因 count + 基因长度计算 TPM 和 FPKM
#   - 可选：从 RPKM/FPKM 转换为 TPM
# Input:
#   1) 基因注释表 (含 Geneid)
#   2) 基因长度表 (两列：Geneid, Length)
#   3) count 矩阵 (行为基因，列为样本，需包含 Length 列)
# Author: [Your Name]
# Corresponding paper: [论文题目]
############################################################

rm(list = ls())

library(xlsx)
library(readxl)
library(dplyr)

## 1. 读入基因注释和基因长度并合并 -----------------------------

# 读入基因注释文件（需含 Geneid 列）
ann <- read_excel(file.choose())   # e.g. "gene_annotation.xlsx"

# 读入基因长度文件（Geneid + Length 两列）
input <- read_excel(file.choose()) # e.g. "gene_length.xlsx"

# 根据 Geneid 合并
merge <- left_join(ann, input, by = "Geneid")

# 删除缺失值行
merge <- na.omit(merge)

# 可选：保存合并结果
write.csv(merge, file = "merge_annotation_length.csv", row.names = FALSE)

## 2. 读入包含 Length 列的 count 矩阵 ----------------------------

# 注意：文件需包含一列 gene id，和若干样本列，以及一列 Length
mycounts <- read.csv(file.choose(), header = TRUE, stringsAsFactors = FALSE)

# 假设第一列为基因 ID
rownames(mycounts) <- mycounts[, 1]
mycounts <- mycounts[, -1]

# 最后一列为基因长度（单位：bp）
# 如果不是最后一列，请根据你的数据调整列号
# 例如：mycounts$Length <- mycounts$GeneLength 之类
head(mycounts)

## 3. 计算 TPM ---------------------------------------------------

# 转换为 kb
kb <- mycounts$Length / 1000

# 选取 count 列（去掉 Length）
# 根据你的矩阵真实列数调整结束列号，这里举例 2:115
countdata <- mycounts[, 1:(ncol(mycounts) - 1)]
# 如果第一列就是样本列、最后一列是 Length，则可以：
# countdata <- mycounts[, !(colnames(mycounts) %in% "Length")]

# 计算 RPK = counts / kb
rpk <- sweep(countdata, 1, kb, FUN = "/")

# TPM = RPK / sum(RPK) * 1e6
tpm <- t(t(rpk) / colSums(rpk) * 1e6)

write.table(tpm, file = "tpm.tsv", sep = "\t", quote = FALSE, col.names = NA)

## 4. 计算 FPKM --------------------------------------------------

# FPKM = counts / (length_kb * total_counts / 1e6)
# 这里用 total_counts = colSums(counts)
fpkm <- t(t(rpk) / colSums(countdata) * 1e6)

write.table(fpkm, file = "fpkm.tsv", sep = "\t", quote = FALSE, col.names = NA)

## 5. 从 RPKM/FPKM 转换为 TPM（如已有 RPKM 矩阵）-----------------

# 读入一个 RPKM/FPKM 矩阵（行为基因，列为样本）
# 注意：如果第一列是基因 ID，需要先 set rownames 再去掉该列
rpkm_mat <- read.csv(file.choose(), header = TRUE, row.names = 1)

# 检查每列总和
apply(rpkm_mat, 2, sum)

rpkmTOtpm <- function(x) {
  exp(log(x) - log(sum(x, na.rm = TRUE)) + log(1e6))
}

tpm_from_rpkm <- apply(rpkm_mat, 2, rpkmTOtpm)

# 再检查总和是否为 1e6
apply(tpm_from_rpkm, 2, sum)

write.csv(tpm_from_rpkm, file = "tpm_from_rpkm.csv")