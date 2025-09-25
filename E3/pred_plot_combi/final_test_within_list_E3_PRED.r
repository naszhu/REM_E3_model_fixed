
library(dplyr)
library(ggplot2)
library(tidyr)
library(gridExtra)

all_results=read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/all_results.csv")
DF=read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/DF.csv")
allresf=read.csv("/home/lea/Insync/naszhu@gmail.com/Google Drive/shulai@iu.edu 2022-09-04 14:28/IUB/Project-context/design3/modeling/allresf.csv")


allresf%>%mutate(as.factor(type_specific))%>% summary()

allresf %>% filter(type_specific=='Tr"n\\+1" => "n_p1"')%>%group_by(type_specific,initial_testpos)%>%summarize(meanx=mean(decision_isold))

    DF_fbyi = allresf %>% 
        mutate(correct = case_when( 
            (decision_isold==1) & (is_target=="true") ~ 1, 
            decision_isold==0 & is_target=="false" ~1,
            TRUE ~ 0))%>%
       mutate(
  is_target = sub('"[^"]*$', '', type_specific) ) %>%  
        # select(correct,initial_studypos, initial_testpos,is_target,condition,simulation_number)%>%
        pivot_longer(cols=c("initial_studypos","initial_testpos"),names_to="pos_factor",values_to="posSum")%>%
        mutate(posSum=as.numeric(posSum),posSum = ceiling(posSum/3))%>%
        # mutate(list_number=as.numeric(list_number))%>%
        group_by(pos_factor,posSum,is_target,simulation_number)%>%
        summarize(meanx=mean(correct))%>%
        group_by(pos_factor,posSum,is_target)%>%
        summarize(meanx=mean(meanx))


    pf4= ggplot(data=DF_fbyi,aes(x=posSum,meanx))+
        geom_point(aes(color=is_target,shape=is_target),size=8)+
        geom_line(aes(color=is_target),size=2)+

        facet_grid(.~pos_factor)+
        labs(title="Final test by initial test position")+
        # ylim(c(0.5,1))+
        theme(
                plot.caption = element_text(hjust = 0, size = 14, face = "bold"),  # Align the caption to the left and customize its appearance
            plot.margin = margin(t = 10, b = 40),
            text=element_text(size=30) # Increase font size globally
        )+
    scale_color_manual(values=c("red","blue","blue","green","green","purple","purple"))+
    scale_shape_manual(values = c(
        16,   # circle
        17,   # triangle
        15,   # square
        0,    # hollow square
        3,    # plus sign
        NA,
        8    # star (asterisk)
    ))
    # scale_color_manual(values=c("grey","red","blue","green"))  # pf3
    pf4
    # ensure_device(3)
    # dev.set(3)  # Target window for Plot 1

ggsave("E3_final_test_within_list_pred.png", pf4, 
       width = PLOT_WIDTH, height = PLOT_HEIGHT, dpi = PLOT_DPI, bg = "white")
