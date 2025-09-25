
library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

# Plot formatting constants
PLOT_TITLE_SIZE <- 18
AXIS_TITLE_SIZE <- 24
AXIS_TEXT_SIZE <- 18
STRIP_TEXT_SIZE <- 28
BASE_SIZE <- 24
POINT_SIZE <- 4
LINE_WIDTH <- 1
PLOT_WIDTH <- 11
PLOT_HEIGHT <- 6
PLOT_DPI <- 300
POSITION_LABEL <- "Position"
CORRECT_RATE_LABEL <- "Correct Response Rate"

# Y-axis scale constants
Y_MIN <- 0.5
Y_MAX <- 1.0
Y_BREAKS <- seq(0.5, 1.0, by = 0.1)

PLOT_THEME <- theme_bw(base_size = BASE_SIZE) +
  theme(
    plot.title = element_text(size = PLOT_TITLE_SIZE, face = "bold"),
    axis.title.x = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.title.y = element_text(size = AXIS_TITLE_SIZE, face = "bold"),
    axis.text.x = element_text(size = AXIS_TEXT_SIZE),
    axis.text.y = element_text(size = AXIS_TEXT_SIZE),
    legend.position = "none",
    strip.text = element_text(size = STRIP_TEXT_SIZE, face = "bold")
  )

all_results=read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/all_results.csv")
DF=read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/DF.csv")
allresf=read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/allresf.csv")


# Data processing for prediction plot - Test Position
df1_test = allresf %>% 
  mutate(correct = case_when( 
    (decision_isold==1) & (is_target=="true") ~ 1, 
    decision_isold==0 & is_target=="false" ~ 1,
    TRUE ~ 0)) %>%
  mutate(is_target = sub('"[^"]*$', '', type_specific)) %>%
  mutate(test_position_grouped = ceiling(as.numeric(initial_testpos) / 3)) %>%
  group_by(test_position_grouped, is_target, simulation_number) %>%
  summarize(meanx = mean(correct)) %>%
  group_by(test_position_grouped, is_target) %>%
  summarize(meanx = mean(meanx)) %>%
  mutate(position_type = "Test Position", position = test_position_grouped)

# Data processing for prediction plot - Study Position  
df1_study = allresf %>% 
  mutate(correct = case_when( 
    (decision_isold==1) & (is_target=="true") ~ 1, 
    decision_isold==0 & is_target=="false" ~ 1,
    TRUE ~ 0)) %>%
  mutate(is_target = sub('"[^"]*$', '', type_specific)) %>%
  mutate(study_position_grouped = ceiling(as.numeric(initial_studypos) / 3)) %>%
  group_by(study_position_grouped, is_target, simulation_number) %>%
  summarize(meanx = mean(correct)) %>%
  group_by(study_position_grouped, is_target) %>%
  summarize(meanx = mean(meanx)) %>%
  mutate(position_type = "Study Position", position = study_position_grouped)

# Combine both datasets
df1_combined = bind_rows(df1_test, df1_study)

# Create combined plot with facet_grid
pf4 = ggplot(data=df1_combined, aes(x=position, y=meanx, group=is_target)) +
  geom_line(aes(color=is_target, linetype=is_target), linewidth=LINE_WIDTH) +
  geom_point(aes(color=is_target, shape=is_target), size=POINT_SIZE) +
  facet_grid(.~position_type) +
  scale_color_manual(
    values = c("F" = "#E08214",            # orange for previous initial foil
              "FF" = "red",                # red for final new foil
              "Fn_p1" = "#E08214",         # orange for previous confusing foil
              "SO" = "#1A9850",            # green for previous studied only
              "SOn_p1" = "#1A9850",        # green for previous studied only confusing foil
              "T" = "#2166AC",             # blue for previous target
              "Tn_p1" = "#2166AC")         # blue for previous target confusing foil
  ) +
  scale_shape_manual(
    values = c("F" = 2,                    # open triangle
              "FF" = 8,                    # star
              "Fn_p1" = 2,                 # open triangle
              "SO" = 1,                    # open circle
              "SOn_p1" = 1,                # open circle
              "T" = 0,                     # open square
              "Tn_p1" = 0)                 # open square
  ) +
  scale_linetype_manual(
    values = c("F" = "dashed",
              "FF" = "solid",
              "Fn_p1" = "dashed",
              "SO" = "dashed",
              "SOn_p1" = "dashed",
              "T" = "solid",
              "Tn_p1" = "solid")
  ) +
  PLOT_THEME +
  labs(
    x = POSITION_LABEL, 
    y = CORRECT_RATE_LABEL, 
    title = "Final Test Within List PREDICTION"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1)) +
  scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))

ggsave("E3_final_test_within_list_pred.png", pf4, 
       width = PLOT_WIDTH, height = PLOT_HEIGHT, dpi = PLOT_DPI, bg = "white")
