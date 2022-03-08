#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shinydashboard)
require(shiny)
require(highcharter)
#layout of the dashboard

dashboardPage(
    #defines header
    skin = "red",
    dashboardHeader(
        title="Meta Oversight"
    ),
    
    #defines sidebar
    dashboardSidebar(
        sidebarMenu(
            menuItem("Analysis", tabName = "analysis",
                     icon = icon("dashboard")),
            menuItem("Methodology", tabName = "methodology", icon = icon("th")),
            menuItem("Site Code", tabName = "code", icon = icon("code"))
        )
    ),
    
    #defines bodies
    dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css",
                      href = "custom.css")
        ),
        tabItems(
            #First TAB Menu-Analysis  
          tabItem(tabName = "analysis",
                    column(12,
                           h2("Crunching the numbers: is Meta’s oversight
                              structure working?",style="text-align:center"),
                    br(),
                    p(style="font-size:17px", "With over 100,000 content
                    moderation decision appeals per year on Facebook and
                    Instagram,¹ an efficient and responsive oversight system is
                    crucial for the protection of free speech and safety of
                    present and future Meta users.",
                      a("The Oversight Board",
                        href="https://oversightboard.com/"),
                    "is an independent group formed in 2019 to",
                    em("“promote free expression by making principled,
                    independent decisions regarding content on Facebook and
                    Instagram and by issuing recommendations on the relevant
                    Meta company content policy.”"), "For example, if a user
                    appeals Meta’s decision to remove their Facebook post, the
                    Oversight Board may decide to weigh in, uphold or reverse
                    Meta’s decision, then make a policy recommendation to the
                    company."),
                    column(12, box(p(style="font-size:15px", "Example
                                     recommendation (2021-013-IG-UA-3):"),
                        p(style="font-size:15px", em("“The Board recommends
                        that Meta modify the Instagram Community Guidelines and
                        Facebook Regulated Goods Community Standard to allow
                        positive discussion of traditional and religious uses of
                        non-medical drugs where there is historic evidence of
                        such use. The Board also recommends that Meta make
                        public all allowances, including existing
                        allowances.”")), align="center", width="13")),
                    p(style="font-size:17px", "However, while the Oversight
                    Board’s case decisions are binding, their policy
                    recommendations are not. Instead, Meta is given 30 days to",
                    em("“fully consider and respond to these
                    recommendations.”"), "Thus the question arises: "),
                    p(style="font-size:17px", strong("How fully and efficiently
                    is Meta implementing policy recommendations from the
                    Oversight Board?")),
                    p(style="font-size:17px", "For the purposes of this project,
                    I split this question in three parts: 1) What
                    recommendations does the Oversight Board make to Meta?
                    2) What action does Meta say it will take in response to
                    each Oversight Board recommendation? and 3) How quickly does
                    Meta make progress on these actions?"),
                    p(style="font-size:17px", "I answer these questions by
                    exploring Meta’s public", 
                    a("Oversight Board recommendations",
                    href="https://transparency.fb.com/oversight/
                    oversight-board-recommendations/"),
                    "page, which contains information on content, timing, Meta’s
                    response, and current status for each recommendation."),
                    ),
                  fluidRow(
                        #box for plotting the time series plot
                        column(12,
                               box(
                                 p("What kinds of recommendations does the
                                   Oversight Board make to Meta?",
                                   style="font-size:20px"),
                                 tableOutput('table'),
                                 width="5"),
                               box(
                                 highchartOutput("hcontainer2"),
                                 width="6")
                               , align="center")
                        ),
                  column(12,
                                    p(style="font-size:17px", "We can see that
                                    the overwhelming majority of Oversight Board
                                    recommendations involve improving
                                    transparency, changing policy, clarifying
                                    standards (specifically, content moderation
                                    standards), or some combination of the
                                    three."),
                                    p(style="font-size:17px", "In response, Meta
                                    most often stated they would fully implement
                                    the recommendation. However, for nearly 30%
                                    of recommendations, Meta’s made no
                                    commitment to implementation; instead,
                                    taking no action or simply “assessing
                                    feasibility.”²"),
                                    p(style="font-size:17px", "After Meta assigns
                                    an action to each recommendation, they report
                                    their progress on that action by updating a
                                    'status' foreach recommendation. By
                                    standardizing the  recommendations by their
                                    age, then tracing the proportion of
                                    recommendations under each
                                    status as they age, we can examine the
                                    efficiency with which Meta
                                    is processing the recommendations."),
                               box(
                                   highchartOutput("hcontainer3"),
                                   width="13"),
                        ),
                      column(12, p(style="font-size: 17px", "Examining the graph,
                                   a number of details emerge: "),
                                 p(style="font-size:17px",
                                   strong("   • Over 50% of recommendations are
                                          still 'Under investigation' after 160
                                          days.")),
                                 p(style="font-size:17px",
                                   strong("   • Meta misses the Oversight Board's
                                          30-day response deadline for 17% of
                                          recommendations.")),
                                 p(style="font-size:17px",
                                   strong("   • 35% of recommendations are still
                                          'In progress' after a full year."))),
                      br(),
                      p(style="font-size: 17px", "Clearly, the question of whether
                      Meta is implementing Oversight Board policy recommendations
                      fully and efficiently enough is a subjective one (full and
                      efficient implementation relative to what? How fast is fast
                      enough?)."),
                      p(style="font-size:17px", "Nevertheless, based on Meta’s
                      record of missing the 30-day response deadline, and taking
                      months to over a year to investigate and complete their
                      stated action, one could reasonably conclude that ",
                      strong("Meta’s oversight system is inefficient and in need
                             of improvement.")),
                      p(style="font-size:17px","This
                      analysis is limited, however, and further investigation
                      is needed: I did not examine factors such as what types
                      of recommendations Meta was more likely to implement, or
                      implement quickly; whether Meta’s implementation is
                      accelerating or slowing down over time; or accounts from
                      persons involved that might lend further insight to the
                      oversight process. In order to hold Meta accountable to 
                      its stated values of free expression and safety, investigation
                      into the relationship between Meta and the Oversight
                      Board must be critical and ongoing."),
                      br(),
                      br(),
                      br(),
                      p("1. Source: presentation by Oversight Board staff to 
                        Stanford University course, 02/22"),
                      p("2. Meta’s explanation of their “assessing feasibility”
                        action states: “We are assessing the feasibility and
                        impact of the recommendation and will provide further
                        updates in the future.”"),
                      p(em("All data current as of 02/28/22"),
                        style="text-align:center")

            ),
            #second tab menu- Methodology
            tabItem(tabName="methodology",
                    h2("Methodology"),
                    p(style="font-size:17px", "All raw data from this analysis
                      come from ", a("https://transparency.fb.com/oversight/
                                     -board-recommendations/",
                                     href="https://transparency.fb.com/oversight/
                                     oversight-board-recommendations/"),
                      ", and can be found (along with processing code) on INSERT GITHUB LINK."),
                    p(style="font-size:17px", strong("What recommendations does
                                                     the Oversight Board make to
                                                     Meta?")),
                    p(style="font-size:17px", "I created the categories for this
                    table by qualitatively grouping the recommendations based
                      on their description (the categories don't reflect any
                      official categories created by the Oversight Board or Meta."),
                    p(style="font-size:17px",strong("How quickly does Meta make
                    progress on Oversight Board
                       recommendations?")),
                    p(style="font-size:17px", "In order to gather time series
                      data on statuses of recommendations, I used ~12 historical
                      snapshots of the site from ", a("The Wayback Machine",
                      href="https://archive.org/web/"),
                      "beginning in June 2021. In order to create daily
                      resolution from this time series, I interpolated statuses
                      in between snapshots. In cases where the status changed
                      between snapshots, I referred to the “Updated” date listed
                      to assign a date at which point to switch the recommendation
                      status. Otherwise, when the status did not change between
                      snapshots, I assumed that no recommendation’s status value
                      “waffled” by flipping back and forth from a different value.
                      For days between the posting of the recommendation by the
                      Oversight Board (age=0) and Meta's declaration of an action
                      and initial status for the recommendation, I assigned
                      the status 'No status'."),
                    p(style="font-size:17px", "For visual clarity in the plot,
                      I filtered the dataset to every 5th day and smoothed using
                      a linear spline."),
                    p(style="font-size:17px", "Plotted below is the frequency of
                      data points for each recommendation age. As of 2/28/22,
                      the age distribution of recommendations is: mean=236.8,
                      standard deviation=95."),
                    fluidRow(column(12,
                    box(
                      highchartOutput("hcontainer4"), width=12
                    )
                    )
                    )
            ),
            tabItem(tabName="code",
                    box(p(style="font-size:17px", "All site data and code are
                    included at "),
                    a("", href="Insert Git link here"),
                    p(),
                    p(style="font-size:17px", "This site was created using
                    the R package Shiny, inspired by the work of ",
                    a("Anish Singh Walia.", href="https://github.com/anishsingh20"),
                    "Learn how to make a Shiny web app at",
                    a("shiny.rstudio.com", href="https://shiny.rstudio.com/"))
            , width=12))
        )#end tabitems
        
        
    )#end body
    
)#end dashboard
