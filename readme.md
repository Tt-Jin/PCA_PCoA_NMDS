# 数据降维方法

PCA、PCoA、NMDS 三种数据降维分析方法及可视化

### PCA

- PCA_ade4，使用 ade4 包进行 PCA 分析并绘图
- PCA_FactoMineR，使用 factoextra 包进行 PCA 分析并绘图

1. Plotting settings 部分是读入样本分组文件，识别样本和分组数量的多少，自动设置点的颜色、形状、图例列数

2. PCA analysis using ade4(FactoMineR) 部分是读入绘图数据，调用 R 包进行 PCA 分析，输出样本坐标文件，及 PC1、PC2 主成分对样品数据差异的贡献度

3. PCA plot using ggplot2 部分是使用 ggplot2 绘图

(1) geom_text 函数添加样本名称，不需要展示时，注释掉即可
(2) stat_ellipse 函数添加聚类圆圈，不需要展示时，注释掉即可

### PCoA

- PCoA，基础 PCoA 绘图
- PCoA_box_dot_PERMANOVA，基础 PCoA 图，添加边缘箱线图和 PERMANOVA 检验

1. Plotting settings 部分是读入样本分组文件，识别样本和分组数量的多少，自动设置点的颜色、形状、图例列数

2. PCoA analysis with vegan 部分是读入绘图数据，调用 vegan 包进行 PCoA 分析并绘图，输出样本距离矩阵，样本坐标文件，及 PCoA1、PCoA2 主坐标对样品矩阵数据差异的贡献度

(1) vegdist 函数计算距离矩阵，通过 method 选择计算距离矩阵的方法 (例如 euclidean, bray ...)
(2) cmdscale 函数进行 PCoA 分析

3. p value 部分是调用 adonis2 函数进行 PERMANOVA 非参数检验

4. PCoA plot + boxplot using ggplot2 部分是使用 ggplot2 绘图

plot 是基础的 PCoA 散点图

(1) geom_text 函数添加样本名称，不需要展示时，注释掉即可
(2) stat_ellipse 函数添加聚类圆圈，不需要展示时，注释掉即可

box1 是主坐标 PCoA1 箱式图

(1) geom_boxplot 函数添加箱线图
(2) stat_boxplot 函数添加误差棒
(3) geom_jitter 函数添加散点
(4) coord_flip 函数将柱子‘放倒’

box2 是主坐标 PCoA2 箱式图

box3 是展示 PERMANOVA 计算的 p value等文本信息

plot_layout 函数合并以上 4 个图片


### NMDS

- NMDS，基础 NMDS 绘图
- NMDS_box_dot_ANOSIM，基础 NMDS 图，添加边缘箱线图和 ANOSIM 检验

1. Plotting settings 部分是读入样本分组文件，识别样本和分组数量的多少，自动设置点的颜色、形状、图例列数

2. NMDS analysis with vegan 部分是读入绘图数据，调用 vegan 包进行 NMDS 分析并绘图，输出样本坐标文件 (无权重意义)，及 stress 值

(1) vegdist 函数计算距离矩阵，通过 method 选择计算距离矩阵的方法 (例如 euclidean, bray ...)
(2) metaMDS 函数进行 NMDS 分析

3. p value 部分是调用 anosim 函数进行 ANOSIM  非参数检验

4. NMDS plot + boxplot using ggplot2 部分是使用 ggplot2 绘图

plot 是基础的 NMDS 散点图

(1) geom_text 函数添加样本名称，不需要展示时，注释掉即可
(2) stat_ellipse 函数添加聚类圆圈，不需要展示时，注释掉即可

box1 是 NMDS1 箱式图

(1) geom_boxplot 函数添加箱线图
(2) stat_boxplot 函数添加误差棒
(3) geom_jitter 函数添加散点
(4) coord_flip 函数将柱子‘放倒’

box2 是 NMDS2 箱式图

box3 是展示 ANOSIM 计算的 p value等文本信息

plot_layout 函数合并以上 4 个图片


### 最重要的是：

码代码不易，如果你觉得我的教程对你有帮助，请小红书(号4274585189)关注我！！！

