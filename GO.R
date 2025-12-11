############################################################
# Script: GO_bubble_plot.R
# Purpose:
#   - 根据 GO 富集结果绘制气泡图
# Input:
#   - 一个制表符分隔或 csv 文件，至少包含：
#       Term (或 BP): GO term 描述
#       GeneCount: 富集到的基因数
#       P_log10: -log10(p-value) 或类似统计量
#       pvalue: 原始 p 值（可选，仅用于参考）
# Example:
#   见 example_GO_input.xlsx
############################################################

library(ggplot2)
library(readxl)

# 方式 1：读入 xlsx（与你给的示例文件类似）
# dat <- read_excel("example_GO_input.xlsx")

# 方式 2：读入 txt/csv
dat <- read.delim(file.choose(), header = TRUE, stringsAsFactors = FALSE)

# 根据你实际的列名调整：
# 假设：
#   Term      : GO term 或 “BP” 列
#   GeneCount : 富集到的基因数（“Gene Count”）
#   P_log10   : -log10(p-value) (“p=-log10”)
#   pvalue    : 原始 p 值 (“p-value”)
# 这里统一改个内部列名，方便后续代码书写：
colnames(dat) <- c("Term", "GeneCount", "P_log10", "tmp", "pvalue")

# 画图：x 轴为 P_log10，y 轴为 GO term，点大小为基因数，颜色为 P_log10
p <- ggplot(dat,
            aes(x = P_log10,
                y = Term,
                size = GeneCount,
                col = P_log10,
                fill = P_log10)) +
  geom_point(shape = 21) +
  theme_bw() +
  scale_color_gradient(low = "dodgerblue", high = "dodgerblue4") +
  scale_fill_gradient(low = "dodgerblue", high = "dodgerblue4") +
  labs(x = "-log10(p-value)",
       y = "GO term",
       title = "GO enrichment bubble plot")

print(p)

# 如需保存：
ggsave("GO_bubble_plot.pdf", p, width = 6, height = 5)
ggsave("GO_bubble_plot.png", p, width = 6, height = 5, dpi = 300)