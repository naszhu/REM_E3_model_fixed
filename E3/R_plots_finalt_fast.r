library(data.table)  # Much faster than dplyr
library(ggplot2)
library(gridExtra)
library(dplyr, quietly=TRUE)  # Need ntile function

# Fast CSV reading
allresf <- fread("allresf.csv")
setDT(allresf)

# Optimize data processing with data.table - matching original logic exactly
allresf[, `:=`(
  test_position_num = as.numeric(test_position),
  list_number_num = as.numeric(list_number)
)]

# Correct logic matching original: correct when (decision=1 AND target=true) OR (decision=0 AND target=false)
allresf[, correct := fcase(
  decision_isold == 1 & is_target == "true", 1L,
  decision_isold == 0 & is_target == "false", 1L,
  default = 0L
)]

# Optimize DF00 computation
DF00 <- allresf[, `:=`(
  is_target_new = type_general,
  test_position_group = as.integer(cut(test_position_num, breaks=10, labels=1:10))
)][, .(meanx = mean(correct)), by = .(test_position_group, is_target_new, condition)]

setnames(DF00, "is_target_new", "is_target")

# Optimize DF001 computation  
DF001 <- allresf[, `:=`(
  is_target_new = fifelse(
    list_number_num == 10 & type_general %in% c("Tn", "SOn", "Fn"),
    substr(type_general, 1, nchar(type_general) - 1),
    type_general
  )
)][, .(meanx = mean(correct)), by = .(list_number_num, is_target_new, condition)]

setnames(DF001, c("list_number_num", "is_target_new"), c("list_number", "is_target"))

# Plot 1
p1 <- ggplot(DF001, aes(x=list_number, y=meanx, group=interaction(is_target,condition))) +
  geom_point(aes(color=is_target), size=8) +
  geom_line(aes(color=is_target), linewidth=1.5) +
  scale_color_manual(values=c("#56B4E9","red","#009E73","purple")) +
  scale_x_continuous(name="list number", breaks=1:10, labels=as.character(1:10)) +
  labs(title="Accuracy by list number in final test") +
  facet_grid(condition~.) +
  theme_minimal() +
  theme(text=element_text(size=20))

# Optimize DF2 computation
DF2 <- allresf[type_specific != "", 
  .(meanx = mean(correct)), by = .(type_specific, initial_testpos)
][initial_testpos > 0]  # Filter efficiently

# Plot 2
p2 <- ggplot(DF2, aes(x=initial_testpos, y=meanx, group=type_specific)) +
  geom_point(aes(color=type_specific, shape=type_specific), size=8) +
  geom_line(aes(color=type_specific), linewidth=1.5) +
  scale_color_manual(values=c("#56B4E9","red","#009E73","purple","orange","brown","pink")) +
  scale_shape_manual(values = c(4, 16, 17, 15, 0, 1, 2)) +
  scale_x_continuous(name="Position in initial study", breaks=seq(0,30,5)) +
  labs(title="Accuracy by initial study position") +
  theme_minimal() +
  theme(text=element_text(size=20))

# Optimize DF3 computation
# Sample data if too large for speed
if(nrow(allresf) > 100000) {
  sampled_data <- allresf[sample(.N, 50000)]
} else {
  sampled_data <- allresf
}

DF3 <- sampled_data[, .(meanx = mean(correct)), by = .(list_number_num, condition)]

# Plot 3  
p3 <- ggplot(DF3, aes(x=list_number_num, y=meanx, group=condition)) +
  geom_point(aes(color=condition), size=8) +
  geom_line(aes(color=condition), linewidth=1.5) +
  scale_color_manual(values=c("#56B4E9","red")) +
  scale_x_continuous(name="list number", breaks=1:10, labels=as.character(1:10)) +
  labs(title="Accuracy by list number and condition") +
  theme_minimal() +
  theme(text=element_text(size=20))

# Optimize position factor computation
allresf[, `:=`(
  pos_factor = factor(pmin(ceiling(test_position_num / 41.0), 12)),
  posSum = pmin(ceiling(test_position_num / 41.0), 12)
)]

DF4 <- allresf[, .(meanx = mean(correct)), by = .(pos_factor, posSum, is_target, condition)
][, .(meanx = mean(meanx)), by = .(pos_factor, posSum)]

# Plot 4
p4 <- ggplot(DF4, aes(x=posSum, y=meanx)) +
  geom_point(size=8) +
  geom_line(group=1, linewidth=1.5) +
  scale_x_continuous(name="Position factor", breaks=1:12) +
  labs(title="Performance by position factor") +
  theme_minimal() +
  theme(text=element_text(size=20))

# Generate optimized PNG
png(filename="plot2.png", width=2000, height=1800, type="cairo")
grid.arrange(p1, p2, p3, p4, ncol = 2, nrow=2)
dev.off()