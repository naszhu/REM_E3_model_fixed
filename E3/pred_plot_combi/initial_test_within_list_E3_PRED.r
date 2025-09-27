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
Y_MIN <- 0.44
Y_MAX <- 0.9
Y_BREAKS <- seq(0.4, 0.9, by = 0.1)

all_results=read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/all_results.csv")
DF=read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/DF.csv")


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


# Data processing for prediction plot
df1_test = all_results %>%
  mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target) %>%
  mutate(is_target=type_specific) %>%
  mutate(is_target=case_when(is_target %in% c("T","Tn+1")~"T",
                    is_target %in% c("F","Fn+1")~"F",
                    TRUE~paste("Fb",is_target,sep="-"))) %>%
  group_by(testpos,is_target,simulation_number) %>%
  summarize(meanx=mean(correct)) %>%
  group_by(testpos,is_target) %>%
  summarize(meanx=mean(meanx)) %>%
  mutate(test_position_grouped = ceiling(testpos / 3)) %>%
  group_by(test_position_grouped, is_target) %>%
  summarise(meanx = mean(meanx)) %>%
  mutate(position_type = "Test Position", position = test_position_grouped)

df1_study = all_results %>%
  mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target) %>%
  mutate(is_target=type_specific) %>%
  mutate(is_target=case_when(is_target %in% c("T","Tn+1")~"T",
                    is_target %in% c("F","Fn+1")~"F",
                    TRUE~paste("Fb",is_target,sep="-"))) %>%
  group_by(studypos,is_target,simulation_number) %>%
  summarize(meanx=mean(correct)) %>%
  group_by(studypos,is_target) %>%
  summarize(meanx=mean(meanx)) %>%
  mutate(study_position_grouped = ceiling(studypos / 3)) %>%
  group_by(study_position_grouped, is_target) %>%
  summarise(meanx = mean(meanx)) %>%
  mutate(position_type = "Study Position", position = study_position_grouped)

# Combine both datasets
df1_combined = bind_rows(df1_test, df1_study)

# Create combined plot with facet_grid
p_in_20 = ggplot(data=df1_combined, aes(x=position, y=meanx, group=is_target)) +
  geom_line(aes(color=is_target, linetype=is_target), linewidth=LINE_WIDTH) +
  geom_point(aes(color=is_target, shape=is_target), size=POINT_SIZE) +
  facet_grid(.~position_type) +
  scale_color_manual(
    values = c("F" = "#E08214",           # orange for new foil
              "Fb-Fn" = "#E08214",        # orange for confusing foil foil
              "Fb-SOn" = "#1A9850",       # green for confusing foil studied only
              "Fb-Tn" = "#2166AC",        # blue for confusing foil target
              "T" = "#2166AC")            # blue for target
  ) +
  scale_shape_manual(
    values = c("F" = 17,                  # solid triangle
              "Fb-Fn" = 2,                # open triangle
              "Fb-SOn" = 1,               # open circle
              "Fb-Tn" = 0,                # open square
              "T" = 0)                    # open square
  ) +
  scale_linetype_manual(
    values = c("F" = "solid",
              "Fb-Fn" = "dashed",
              "Fb-SOn" = "dashed",
              "Fb-Tn" = "dashed",
              "T" = "solid")
  ) +
  PLOT_THEME +
  labs(
    x = POSITION_LABEL, 
    y = CORRECT_RATE_LABEL, 
    title = "Initial Test Within List PREDICTION"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1)) +
  scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))

ggsave("E3_initial_test_within_list_pred.png", p_in_20, 
       width = PLOT_WIDTH, height = PLOT_HEIGHT, dpi = PLOT_DPI, bg = "white")
