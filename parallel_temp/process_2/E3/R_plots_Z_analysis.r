# Load required libraries
library(ggplot2)
library(dplyr)

# Read the data
all_results <- read.csv("all_results.csv")

# Create Z analysis plots

# Plot 1: Z_proportion by list_number
z_by_list_plot <- all_results %>%
  group_by(list_number) %>%
  summarise(
    mean_Z_proportion = mean(Z_proportion, na.rm = TRUE),
    se_Z_proportion = sd(Z_proportion, na.rm = TRUE) / sqrt(n())
  ) %>%
  ggplot(aes(x = list_number, y = mean_Z_proportion)) +
  geom_line(color = "#4e79a7", size = 1.2) +
  geom_point(size = 3, color = "#4e79a7") +
  geom_errorbar(aes(ymin = mean_Z_proportion - se_Z_proportion, 
                    ymax = mean_Z_proportion + se_Z_proportion), 
                width = 0.2, color = "#4e79a7") +
  labs(
    title = "Z Feature Proportion by List Number",
    subtitle = "Average proportion of Z=1 across all targets in memory pool",
    x = "List Number",
    y = "Mean Z Proportion",
    caption = "Error bars represent standard error"
  ) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

# Plot 2: Z_proportion by test_position within lists
z_by_testpos_plot <- all_results %>%
  group_by(list_number, test_position) %>%
  summarise(
    mean_Z_proportion = mean(Z_proportion, na.rm = TRUE),
    se_Z_proportion = sd(Z_proportion, na.rm = TRUE) / sqrt(n())
  ) %>%
  ggplot(aes(x = test_position, y = mean_Z_proportion, color = factor(list_number))) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  geom_errorbar(aes(ymin = mean_Z_proportion - se_Z_proportion, 
                    ymax = mean_Z_proportion + se_Z_proportion), 
                width = 0.2) +
  labs(
    title = "Z Feature Proportion by Test Position Within Lists",
    subtitle = "Z proportion changes during testing within each list",
    x = "Test Position",
    y = "Mean Z Proportion",
    color = "List Number",
    caption = "Error bars represent standard error"
  ) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  scale_color_viridis_d() +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank(),
    legend.position = "bottom"
  )

# Save the plots
ggsave("Z_proportion_by_list.png", z_by_list_plot, 
       width = 10, height = 6, dpi = 300)

ggsave("Z_proportion_by_test_position.png", z_by_testpos_plot, 
       width = 10, height = 6, dpi = 300)

# Display the plots
print(z_by_list_plot)
print(z_by_testpos_plot)

# Print summary statistics
cat("\n=== Z Feature Analysis Summary ===\n")
cat("Overall mean Z proportion:", mean(all_results$Z_proportion, na.rm = TRUE), "\n")
cat("Overall mean Z sum:", mean(all_results$Z_sum, na.rm = TRUE), "\n")

cat("\nZ proportion by list:\n")
z_summary_by_list <- all_results %>%
  group_by(list_number) %>%
  summarise(
    mean_Z_prop = mean(Z_proportion, na.rm = TRUE),
    mean_Z_sum = mean(Z_sum, na.rm = TRUE),
    n_obs = n()
  )
print(z_summary_by_list)
