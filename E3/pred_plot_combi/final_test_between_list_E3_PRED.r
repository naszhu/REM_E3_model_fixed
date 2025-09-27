
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
Y_MIN <- 0.47
Y_MAX <- 0.96
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
# This way of passing data will make Bool in julia df to  String in R true/false

    # head(allresf)
    DF00 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target=="true") ~ 1,
    decision_isold==0 & is_target=="false" ~1,TRUE ~ 0))%>%
    
     mutate(is_target=type_general)%>%
    mutate(test_position=as.numeric(test_position))%>%
    mutate(test_position_group=ntile(test_position,10))%>%
    group_by(test_position_group,is_target,condition)%>%
    summarize(meanx=mean(correct))

    # p10=ggplot(data=DF00, aes(x=test_position_group,y=meanx,group=interaction(is_target,condition)))+
    # geom_point(aes(color=is_target))+
    # geom_line(aes(color=is_target))+
    # scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # # ylim(c(0.5,1))+
    # # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # # allresf
    # facet_grid(condition~.)# ylim(c(50,100))
    # # grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)

# allresf%>% mutate(correct = case_when( (decision_isold==1) & (is_target=="true") ~ 1, 
#     decision_isold==0 & is_target=="false" ~1,TRUE ~ 0))%>%
#     # filter(is_target=="false")%>%
#     select(correct,decision_isold,is_target,condition,simulation_number)%>%as_tibble()
    
    DF001 = allresf %>% mutate(correct = case_when( (decision_isold==1) & (is_target=="true") ~ 1, 
    decision_isold==0 & is_target=="false" ~1,TRUE ~ 0))%>%
    mutate(is_target=type_general)%>%
    mutate(list_number=as.numeric(list_number))%>%
    mutate(is_target = case_when(list_number==10 & is_target%in%c("Tn","SOn","Fn") ~  substr(is_target, 1, nchar(is_target) - 1),
    TRUE ~ is_target))%>%
    group_by(list_number,is_target,condition)%>%
    summarize(meanx=mean(correct))



    # p101=ggplot(data=DF001, aes(x=list_number,y=meanx,group=interaction(is_target,condition)))+
    # geom_point(aes(color=is_target))+
    # geom_line(aes(color=is_target))+
    # scale_color_manual(values=c("#56B4E9","red","#009E73","purple"))+
    # # ylim(c(0.5,1))+
    # # scale_x_continuous(name="list number",breaks = 1:10,labels=as.character(1:10))+labs(title="Accuracy by list number in inital test ")
    # # # allresf
    # facet_grid(condition~.)# ylim(c(50,100))
    # # grid.arrange(p10, p101,p1,p3 ,p_in_20,p_in_20in10,ncol = 2,nrow=3)
    # # grid.arrange(p1, p4,p2,p3 ,ncol = 2,nrow=2)
# assume your data has a factor called “type_comment” with exactly these 7 levels
my.ltys <- c(
  "Tn"  = "longdash",  # 1. Target: studied & tested at (n), Foil (n+1)
  "SOn" = "dotted",    # 2. Studied-only (n); Foil (n+1)
  "T"   = "dotdash",   # 3. Target: started & tested at (n); Appear once
  "Fn"  = "dashed",    # 4. Foil (n), Foil (n+1)
  "F"   = "solid",     # 5. Foil (n); Appear once
  "SO"  = "dashed",    # 6. Studied-only (n); Appear once
  "FF"  = "solid"      # 7. Final Foil
)

my.shps <- c(
  "Tn"                = NA,    # no point glyph
  "SOn"          = 22,    # square (filled/colourable)
  "T"    = 8,     # asterisk/star
  "Fn"              = 24,    # filled triangle-up
  "F"      = 15,    # filled square
  "SO"     = 3,     # plus
  "FF"            = 16     # filled circle
)
    
    #assuming this list number is first-appear list number
    df_allfinal=DF001%>%mutate(test_position_group=list_number)%>%
    ungroup()%>%select(-list_number)%>%
    full_join(DF00,by=c("is_target","condition","test_position_group"))%>%
    mutate(initial_list_order=meanx.x,final_test_order=meanx.y)%>%
    select(-c("meanx.x","meanx.y"))%>%
    pivot_longer(cols=c("initial_list_order","final_test_order"),names_to="position_kind",values_to="val")%>%
    mutate(position_kind = case_when(
      position_kind == "final_test_order" ~ "Final Position",
      position_kind == "initial_list_order" ~ "Initial Position",
      TRUE ~ position_kind
    ))


# Create combined plot with facet_grid
pf1 = ggplot(data=df_allfinal, aes(test_position_group, val, group=interaction(position_kind, is_target))) +
  geom_line(aes(color=is_target, linetype=is_target), linewidth=LINE_WIDTH) +
  geom_point(aes(color=is_target, shape=is_target), size=POINT_SIZE) +
  facet_grid(. ~ position_kind) +
  scale_color_manual(
    values = c("Tn" = "#2166AC",            # blue for target
              "SOn" = "#1A9850",            # green for studied only
              "T" = "#2166AC",              # blue for target
              "Fn" = "#E08214",             # orange for foil
              "F" = "#E08214",              # orange for foil
              "SO" = "#1A9850",             # green for studied only
              "FF" = "red")                 # red for final foil
  ) +
  scale_shape_manual(
    values = c("Tn" = 0,                    # open square
              "SOn" = 1,                    # open circle
              "T" = 15,                     # solid square
              "Fn" = 2,                     # open triangle
              "F" = 17,                     # solid triangle
              "SO" = 16,                    # solid circle
              "FF" = 8)                     # star
  ) +
  scale_linetype_manual(
    values = c("Tn" = "dashed",
              "SOn" = "dashed",
              "T" = "solid",
              "Fn" = "dashed",
              "F" = "solid",
              "SO" = "solid",
              "FF" = "solid")
  ) +
  PLOT_THEME +
  labs(
    x = POSITION_LABEL, 
    y = CORRECT_RATE_LABEL, 
    title = "Final Test Between List PREDICTION"
  ) +
  scale_x_continuous(breaks = seq(0, 10, by = 1)) +
  scale_y_continuous(breaks = Y_BREAKS, limits = c(Y_MIN, Y_MAX))


pf1

ggsave("E3_final_test_between_list_pred.png", pf1, 
       width = PLOT_WIDTH, height = PLOT_HEIGHT, dpi = PLOT_DPI, bg = "white")
