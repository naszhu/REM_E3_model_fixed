
library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

# Plot formatting constants
PLOT_TITLE_SIZE <- 16
AXIS_TITLE_SIZE <- 24
AXIS_TEXT_SIZE <- 18
STRIP_TEXT_SIZE <- 28
BASE_SIZE <- 24
POINT_SIZE <- 4
LINE_WIDTH <- 1
PLOT_WIDTH <- 6
PLOT_HEIGHT <- 6
PLOT_DPI <- 300
POSITION_LABEL <- "Position"
CORRECT_RATE_LABEL <- "Correct Response Rate"

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

DF2 = all_results %>% 
mutate(is_target=case_when(is_target=="true"~1,TRUE~0),correct=decision_isold==is_target)%>%
# mutate(correct=decision_isold==is_targe)%>%
# mutate(test_position=as.numeric(test_position))%>%
mutate(is_target=type_specific)%>%
mutate(is_target=case_when(is_target %in% c("T","Tn+1")~"T",
                    is_target %in% c("F","Fn+1")~"F",
                    TRUE~paste("Fb",is_target,sep="-")))%>%
group_by(list_number,is_target,simulation_number)%>%
summarize(meanx=mean(correct))%>%
group_by(list_number,is_target)%>%
summarize(meanx=mean(meanx))
p1=ggplot(data=DF2, aes(x=list_number,y=meanx,group=is_target))+
    geom_point(aes(color=is_target,shape=is_target),size=POINT_SIZE)+
    geom_line(aes(color=is_target,linetype=is_target),linewidth=LINE_WIDTH)+
    scale_x_continuous(name=POSITION_LABEL,breaks = 1:10,labels=as.character(1:10))+
    # labs(title="Initial Test Between List Prediction", y="Correct Response Rate")+
    
    scale_color_manual(
        values = c("F" = "red",
                   "Fb-Fn" = "#E08214", 
                   "Fb-SOn" = "#1A9850",
                   "Fb-Tn" = "#2166AC",
                   "T" = "#2166AC")
    ) +
    scale_shape_manual(
        values = c("F" = 8,           # star
                   "Fb-Fn" = 2,       # open triangle
                   "Fb-SOn" = 1,      # open circle
                   "Fb-Tn" = 0,       # open square
                   "T" = 0)           # open square
    ) +
    scale_linetype_manual(
        values = c("F" = "solid",
                   "Fb-Fn" = "solid",
                   "Fb-SOn" = "solid", 
                   "Fb-Tn" = "solid",
                   "T" = "solid")
    ) +
    PLOT_THEME +
    labs(
        x = POSITION_LABEL, 
        y = CORRECT_RATE_LABEL, 
        title = "Initial Test Between List PREDICTION"
    )


ggsave("E3_initial_test_between_list_pred.png", p1, 
       width = PLOT_WIDTH, height = PLOT_HEIGHT, dpi = PLOT_DPI, bg = "white")
