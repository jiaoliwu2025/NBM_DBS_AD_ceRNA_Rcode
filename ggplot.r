############################################################
# Script: ggplot_examples.R
# Purpose:
#   - 一些基于 ggplot2 的示例图形：
#       1) 箱线图 + 抖动散点
#       2) 带手动画色/形状/透明度的散点
#       3) 文本标签图
#       4) 风险分组 vs Age 的 violin + jitter 示例
############################################################

library(ggplot2)

## 1. 箱线图 + 抖动散点 -----------------------------------------
# 数据需要包含：
#   IDH      : 分组变量
#   Exp      : 表达量
#   Subtype  : 进一步分组（决定点形状）

dat1 <- read.delim(file.choose(), header = TRUE, stringsAsFactors = FALSE)

p_box <- ggplot(dat1, aes(x = IDH, y = Exp, col = IDH, shape = Subtype)) +
  geom_boxplot(fill = NA, width = 0.7, show.legend = FALSE) +
  geom_jitter(width = 0.6, show.legend = FALSE) +
  theme_bw() +
  ggtitle("Expression difference")

print(p_box)

## 2. 手动画色/形状/透明度的散点----------------------------------
# 数据需要包含：
#   functions : 因子，用于映射颜色、透明度、形状等
#   IDH, Exp : 同上

dat2 <- dat1   # 或者重新读入另一个数据文件

p_scatter <- ggplot(dat2,
                    aes(x = IDH,
                        y = Exp,
                        col = functions,
                        alpha = functions,
                        shape = functions,
                        size = 1.1)) +
  scale_colour_manual(values = c("red", "blue", "grey")) +
  scale_alpha_manual(values = c(1, 1, 0.2)) +
  scale_shape_manual(values = c(19, 19, 1)) +
  geom_jitter(show.legend = FALSE) +
  theme_bw() +
  ggtitle("Expression difference (by functions)")

print(p_scatter)

## 3. 文本标签图 -------------------------------------------------
# 数据需要包含：
#   TCGA, CGGA : x、y 坐标
#   Term       : 文本标签
#   Color      : 决定填充色的因子

dat3 <- read.delim(file.choose(), header = TRUE, stringsAsFactors = FALSE)

p_label <- ggplot(dat3,
                  aes(x = TCGA,
                      y = CGGA,
                      label = Term)) +
  geom_label(aes(fill = factor(Color)),
             colour = "white",
             fontface = "bold",
             size = 3) +
  geom_point() +
  theme_bw() +
  ggtitle("Expression difference (label plot)")

print(p_label)

## 4. RiskGroup vs Age 的 violin + jitter 示例--------------------
# 数据需要包含：
#   RiskGroup : 风险分组
#   Age       : 年龄

dat4 <- read.delim(file.choose(), header = TRUE, stringsAsFactors = FALSE)

p_violin <- ggplot(dat4,
                   aes(x = RiskGroup,
                       y = Age,
                       col = RiskGroup,
                       fill = RiskGroup)) +
  geom_violin(outlier.shape = NA,
              width = 0.6,
              alpha = 0.1,
              show.legend = FALSE) +
  geom_jitter(size = 0.4, width = 0.2, show.legend = FALSE) +
  scale_colour_manual(values = c("firebrick2", "dodgerblue3", "black")) +
  scale_fill_manual(values = c("firebrick2", "dodgerblue3", "black")) +
  theme_bw() +
  ggtitle("Validation Age")

print(p_violin)