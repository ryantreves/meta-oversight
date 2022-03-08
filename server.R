#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
require(shinydashboard)
require(ggplot2)
require(dplyr)
require(highcharter)
library(readxl)
require(tidyr)
library(lubridate)

#Import data
data <- read_excel("data.xlsx", col_types = c("text", "text", "text", "text",
                                               rep("text", 262))) %>% as_tibble()
#Standardize date formats
data[,3] <- lapply(data[,3], mdy)

#Transform data from wide to long format
data_long <- gather(data, key=date, value=status, `6/11/2021`:`2/27/2022`,
                    factor_key=TRUE)
data_long[,5] <- lapply(data_long[,5], mdy)

#Create new variable `rec_age`
data_long$`rec_age` <- data_long$date-data_long$`30_day`
data_long <- subset(data_long, rec_age>=0)

#Replace `NA`s with `No status`
data_long <- mutate(data_long, across(status, ~replace_na(.x, "No status")))

#Extract percentages of each status based on rec_age
perc_data <- tibble(rec_age=sort(unique(data_long$rec_age)), `No status`=0,
                    `In progress`=0, `Under investigation`=0, `Complete`=0,
                    `Closed`=0)
for (i in perc_data$rec_age) {
  perc_data[i+1,2] <- nrow(subset(data_long,
                                  rec_age==i & status=="No status")
                           )/nrow(subset(data_long, rec_age==i))
  perc_data[i+1,3] <- nrow(subset(data_long,
                                  rec_age==i & status=="In progress")
                           )/nrow(subset(data_long, rec_age==i))
  perc_data[i+1,4] <- nrow(subset(data_long,
                                  rec_age==i & status=="Under investigation")
                           )/nrow(subset(data_long, rec_age==i))
  perc_data[i+1,5] <- nrow(subset(data_long,
                                  rec_age==i & status=="Complete")
                           )/nrow(subset(data_long, rec_age==i))
  perc_data[i+1,6] <- nrow(subset(data_long,
                                  rec_age==i & status=="Closed")
                           )/nrow(subset(data_long, rec_age==i))
}

perc_data_long <- tidyr::pivot_longer(perc_data, cols=`No status`:`Closed`,
                                      names_to="Status", values_to="Percent")

# #Adjusting data for Time series plot
perc_data_long$Percent <- perc_data_long$Percent*100
perc_data_long$Percent <- round(perc_data_long$Percent, 1)
#Make data sparser to allow more smoothing
perc_data_long_sparse <- dplyr::filter(perc_data_long, rec_age %% 5 == 0)

#For Table
list <- c('Change policy','Change policy','Commission independent assessment',
          'Improve transparency and change policy','Improve transparency',
          'Improve transparency and change policy','Improve transparency',
          'Conduct internal assessment','Conduct internal assessment',
          'Improve transparency','Clarify standard','Clarify standard',
          'Improve transparency','Improve transparency','Clarify standard',
          'Change policy','Commission independent assessment',
          'Improve transparency','Conduct internal assessment','Change policy',
          'Improve transparency','Improve transparency','Clarify standard',
          'Conduct internal assessment','Improve transparency',
          'Clarify standard','Change policy and clarify standard',
          'Improve transparency','Change policy','Change policy',
          'Improve transparency','Clarify standard','Improve transparency',
          'Clarify standard','Clarify standard','Clarify standard',
          'Improve transparency','Clarify standard','Change policy',
          'Improve transparency','Improve transparency','Improve transparency',
          'Change policy','Change policy','Change policy','Change policy',
          'Change policy','Change policy','Change policy','Change policy',
          'Change policy','Change policy','Improve transparency',
          'Conduct internal assessment','Improve transparency',
          'Improve transparency','Improve transparency','Improve transparency',
          'Conduct internal assessment','Improve transparency',
          'Improve transparency','Improve transparency','Improve transparency',
          'Change policy','Clarify standard','Improve transparency',
          'Improve transparency','Change policy','Improve transparency',
          'Improve transparency','Clarify standard','Improve transparency',
          'Improve transparency and clarify standard',
          'Conduct internal assessment','Improve transparency',
          'Conduct internal assessment','Change policy','Improve transparency',
          'Clarify standard','Improve transparency','Improve transparency',
          'Improve algorithm','Change policy and clarify standard',
          'Improve transparency','Change policy','Improve transparency',
          'Improve transparency')
rec_summaries <- tibble(`  `=sort(unique(list)),
                        ` `=summary(sort(as.factor(list)))) %>% arrange(-` `)

#For pie chart
data_by_action <- tibble(action=c("Assessing feasibility", "Implementing fully",
                                  "Implementing in part", "Work Meta already does",
                                  "No further action"),
                         count=c(19, 27, 21, 14, 6))

server <- function(input, output) {
    #Table (figure 1)
    output$table <- renderTable(rec_summaries)
    
    #Pie chart (figure 2)
    output$hcontainer2 <- renderHighchart({
        highchart() %>%
        hc_add_series(data_by_action, type="pie", hcaes(x=action, y=count),
                      colors=list("#F2A6A6", "#EC8383", "#E44E4E", "#B11B1B",
                                  "#590D0D")) %>%
        hc_tooltip(headerFormat="", pointFormat="{point.y}") %>%
        hc_xAxis(title = list(text = "Recommendation Age (days)")) %>%
        hc_title(text="What action does Meta say it will take in response to
                 Oversight Board recommendations?",align="center") %>%
        hc_subtitle(text="For 87 recommendations",align="center")
    })
    output$hcontainer3 <- renderHighchart ({

        #Time series plot (figure 3)
        highchart()  %>%
            hc_add_series(filter(perc_data_long_sparse, Status=="Closed"),
                          "spline", hcaes(rec_age, Percent),
                          name = "Closed", color="#A2E2AA") %>%
            hc_add_series(filter(perc_data_long_sparse, Status=="In progress"),
                          "spline", hcaes(rec_age, Percent),
                      name = "In progress", color="#540D6E") %>%
            hc_add_series(filter(perc_data_long_sparse, Status=="No status"),
                          "spline", hcaes(rec_age, Percent),
                      name = "No status", color="#CED5DE") %>%
            hc_add_series(filter(perc_data_long_sparse, Status=="Under investigation"),
                          "spline", hcaes(rec_age, Percent),
                      name = "Under investigation", color="#D52020") %>%
            hc_add_series(filter(perc_data_long_sparse, Status=="Complete"),
                          "spline", hcaes(rec_age, Percent),
                      name = "Complete", color="#2E933C") %>%
            hc_plotOptions(series=list(marker=list(enabled=F))) %>%
            hc_exporting(enabled = TRUE) %>%
            hc_tooltip(crosshairs = TRUE,
                       shared = T, borderWidth = 1.5,
                       headerFormat="Day {point.x} <br>", valueSuffix="%") %>%
            hc_xAxis(title = list(text = "Recommendation age (days)")) %>%
            hc_xAxis(plotLines = list(list(color = "#CED5DE", width = 1.5,
                                           value = 30, dashStyle="Dash",
                                           label=list(text="Response deadline",
                                                      rotation=0, y=19,
                                                      style = list(
                                                        color = "#9DABBE"))))) %>%
            hc_yAxis(labels=list(format="{value}%")) %>%
            hc_title(text="How quickly does Meta make progress on Oversight Board
                     recommendations?",align="center") %>%
            hc_subtitle(text="Percentage of recommendations in each status,
                        by age",align="center") %>%
            hc_legend(title=list(text="Status"), layout="vertical",
                      align="right", verticalAlign="middle")
    })
    
    #Density plot (figure 4)
    output$hcontainer4 <- renderHighchart ({
            highchart() %>%
            hc_title(text="Density of recommendation age",align="center") %>%
            hc_xAxis(title = list(text = "Recommendation age (days)")) %>%
            hc_yAxis(labels=list(format=" ")) %>%
            hc_add_series(density(as.numeric(data_long$rec_age)), type="area",
                          color="#D52020", name="Frequency")
    })
}