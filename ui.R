#Only UI files and R packages should be included
#source("ui/automl_ui.R")
#tabPanel("AutoML", automl_ui("automl_module"))
#Load R packages
source(paste0(getwd(), "/ui/load_r_packages.R"))
#Load Headertag
source(paste0(getwd(), "/ui/headertag.R"))
#Load App Theme
source(paste0(getwd(), "/ui/appTheme.R"))
#Load Header
source(paste0(getwd(), "/ui/header.R"))
#Load Footer
source(paste0(getwd(), "/ui/footer.R"))

#Sidebar
aphrcSiderbar <- dashboardSidebar(
  width = "20%",
  menuItemOutput("dynamic_meinu_aphrc")
  )

#Body
source("ui/dashboard_body.R")

fluidPage(
  header,
  aphrcHeader <- dashboardHeader(disable = TRUE),
  
  dashboardPage(aphrcHeader, aphrcSiderbar, aphrcBody,skin = "green"),
  footer
)