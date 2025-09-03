library(data.table)  # Much faster than dplyr for large datasets
library(ggplot2)
library(gridExtra)

# Faster CSV reading with data.table
all_results <- fread("all_results.csv")
DF <- fread("DF.csv")

# Convert to data.table for speed
setDT(all_results)
setDT(DF)

# Pre-compute commonly used transformations - matching original logic exactly
all_results[, `:=`(
  is_target_num = fifelse(is_target == "true", 1L, 0L)
)]
all_results[, correct := fifelse(decision_isold == is_target_num, 1L, 0L)]

# Optimize df1 computation using data.table syntax (much faster)
df1 <- all_results[, `:=`(
  is_target_new = fcase(
    type_specific %in% c("T","Tn+1"), "T",
    type_specific %in% c("F","Fn+1"), "F", 
    default = paste0("Fb-", type_specific)
  )
)][, .(meanx = mean(correct)), by = .(testpos, is_target_new, simulation_number)
][, .(meanx = mean(meanx)), by = .(testpos, is_target_new)
][, `:=`(test_position_grouped_foralltests = ceiling(testpos / 3))
][, .(meanx = mean(meanx)), by = .(test_position_grouped_foralltests, is_target_new)
][, meanx_m := mean(meanx), by = test_position_grouped_foralltests]

setnames(df1, "is_target_new", "is_target")
df1[, is_target := factor(is_target)]

# Plot 1 - optimized
p_in_20 <- ggplot(df1, aes(x=test_position_grouped_foralltests, y=meanx, group=is_target)) +
  geom_line(aes(color=is_target), linewidth=1.5) +
  geom_point(aes(color=is_target, shape=is_target), size=10) +
  geom_line(aes(y=meanx_m), color="black", linewidth=1.5) +
  theme_minimal() +
  theme(text=element_text(size=20)) +
  scale_color_manual(values=c("blue","green","green","green","purple")) +
  scale_shape_manual(values = c(4, 16, 17, 15, 0))

# Optimize DF2 computation
DF2 <- all_results[, `:=`(
  is_target_new = fcase(
    type_specific %in% c("T","Tn+1"), "T",
    type_specific %in% c("F","Fn+1"), "F",
    default = paste0("Fb-", type_specific)
  )
)][, .(meanx = mean(correct)), by = .(list_number, is_target_new, simulation_number)
][, .(meanx = mean(meanx)), by = .(list_number, is_target_new)]

setnames(DF2, "is_target_new", "is_target")

p1 <- ggplot(DF2, aes(x=list_number, y=meanx, group=is_target)) +
  geom_point(aes(color=is_target, shape=is_target), size=10) +
  geom_line(aes(color=is_target), linewidth=1.5) +
  scale_x_continuous(name="list number", breaks=1:10, labels=as.character(1:10)) +
  labs(title="Accuracy by list number in initial test") +
  scale_color_manual(
    labels = c("F", "Fb-Fn", "Fb-SOn", "Fb-Tn", "T"),
    values = c("blue", "green", "green", "green", "purple")
  ) +
  scale_shape_manual(values = c(4, 16, 17, 15, 0)) +
  theme_minimal() +
  theme(text=element_text(size=20))

# Optimize DF3 computation
DF3 <- all_results[type_specific == "F", .(meanx = mean(N_imageinlist)), 
                   by = .(list_number, simulation_number, ilist_image)
][, .(meanx = mean(meanx)), by = .(list_number, ilist_image)
][, list_number := factor(list_number)]

p4 <- ggplot(DF3, aes(x=ilist_image, y=meanx, group=list_number)) +
  geom_point(aes(color=list_number)) +
  geom_line(aes(color=list_number)) +
  geom_text(aes(label = round(meanx, 3)), nudge_y = 0.01, size=10) +
  labs(title="Ratio of activated trace for 10 lists in 10 color") +
  scale_x_reverse(name="traces from which list", breaks=1:10, labels=as.character(1:10)) +
  theme_minimal() +
  theme(text = element_text(size = 30))

# Optimize serial position computation
df_serial <- all_results[, `:=`(
  studypos_grouped = ceiling(studypos/3),
  is_target_new = fcase(
    type_specific %in% c("T","Tn+1"), "T",
    type_specific %in% c("F","Fn+1"), "F",
    default = paste0("Fb-", type_specific)
  )
)][, .(meanx = mean(correct)), by = .(studypos_grouped, is_target_new, simulation_number)
][, .(meanx = mean(meanx)), by = .(studypos_grouped, is_target_new)]

setnames(df_serial, c("studypos_grouped", "is_target_new"), c("studypos", "is_target"))
df_serial[, is_target := factor(is_target)]

p_serial <- ggplot(df_serial, aes(x=studypos, y=meanx)) +
  geom_line(aes(color=is_target), linewidth=2) +
  geom_point(size=10, aes(color=is_target, shape=is_target)) +
  theme_minimal() +
  theme(text=element_text(size=20)) +
  scale_shape_manual(values = c(4, 16, 17, 15, 0)) +
  scale_color_manual(values=c("blue","green","green","green","purple")) +
  scale_y_continuous(breaks = seq(0.55, 0.8, by = 0.05), limits = c(0.55, 0.8))

# Optimize sampling data computation
sampling_data <- all_results[is_sampled == "true" & is_target == "true" & decision_isold == 1,
  .(is_same_item_num = fifelse(is_same_item == "true", 1L, 0L)), 
  by = .(simulation_number, testpos, list_number)
][, .(prob_correct = mean(is_same_item_num)), by = .(simulation_number, testpos, list_number)
][, .(prob_correct = mean(prob_correct)), by = .(testpos, list_number)
][, .(prob_correct = mean(prob_correct)), by = list_number]

sampling_accuracy_plot <- ggplot(sampling_data, aes(x = list_number, y = prob_correct)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  labs(
    title = "Probability of Correct Sampling When Item is Sampled",
    x = "List Number",
    y = "Probability of Correct Sampling"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    text=element_text(size=30)
  )

# Optimize Z plots
z_by_list_data <- all_results[, .(
  mean_Z_proportion = mean(Z_proportion, na.rm = TRUE),
  se_Z_proportion = sd(Z_proportion, na.rm = TRUE) / sqrt(.N)
), by = list_number]

z_by_list_plot <- ggplot(z_by_list_data, aes(x = list_number, y = mean_Z_proportion)) +
  geom_line(color = "#4e79a7", linewidth = 1.2) +
  geom_point(size = 3, color = "#4e79a7") +
  geom_errorbar(aes(ymin = mean_Z_proportion - se_Z_proportion, 
                    ymax = mean_Z_proportion + se_Z_proportion), 
                width = 0.2, color = "#4e79a7") +
  labs(
    title = "Z Feature Proportion by List Number",
    x = "List Number",
    y = "Mean Z Proportion"
  ) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  theme_minimal() +
  theme(text=element_text(size=30))

z_by_testpos_data <- all_results[, .(
  mean_Z_proportion = mean(Z_proportion, na.rm = TRUE),
  se_Z_proportion = sd(Z_proportion, na.rm = TRUE) / sqrt(.N)
), by = .(list_number, testpos)]

z_by_testpos_plot <- ggplot(z_by_testpos_data, aes(x = testpos, y = mean_Z_proportion, color = factor(list_number))) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  geom_errorbar(aes(ymin = mean_Z_proportion - se_Z_proportion, 
                    ymax = mean_Z_proportion + se_Z_proportion), 
                width = 0.2) +
  labs(
    title = "Z Feature Proportion by Test Position Within Lists",
    x = "Test Position (testpos)",
    y = "Mean Z Proportion",
    color = "List Number"
  ) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  scale_color_viridis_d() +
  theme_minimal() +
  theme(
    text=element_text(size=30),
    legend.position = "bottom"
  )

# Generate plot with optimized PNG settings
png(filename="plot1.png", width=2000, height=1800, type="cairo")
grid.arrange(p1, p4, p_serial, p_in_20, sampling_accuracy_plot, z_by_testpos_plot, z_by_list_plot, ncol = 3, nrow=3)
dev.off()