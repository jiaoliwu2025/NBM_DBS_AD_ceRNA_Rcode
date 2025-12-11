############################################################
# Script: volcano_plot.R
# Purpose:
#   - 绘制火山图
# Input:
#   - 一个制表符分隔的文件，至少包含：
#       FC   : log2 fold change
#       P    : -log10(p-value) 或 -log10(adjusted p-value)
#       COL  : 用于分组着色的因子（如 "up", "down", "ns"）
############################################################

library(ggplot2)

# 读入差异分析结果（例如 DESeq2 输出后自行整理）
dat <- read.delim(file.choose(), header = TRUE, row.names = 1)

# 检查列名是否包含 FC, P, COL
str(dat)

p <- ggplot(data = dat,
            aes(x = FC,
                y = P,
                colour = COL)) +
  geom_point(alpha = 0.4, size = 1.75) +
  theme_bw() +
  xlab("log2(fold change)") +
  ylab("-log10(p-value)") +
  scale_colour_manual(values = c("dodgerblue", "darkgrey", "firebrick2")) +
  ggtitle("Volcano plot")

print(p)

ggsave("volcano_plot.pdf", p, width = 6, height = 5)
ggsave("volcano_plot.png", p, width = 6, height = 5, dpi = 300)