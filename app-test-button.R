library(shiny)
library(httr)
library(DT)
library(jsonlite)

# ==== MODULE UI ====
automl_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Analyse AutoML avec PyCaret (Simulée)"),
    selectInput(ns("target"), "Choisissez la variable cible", choices = c("target")),
    actionButton(ns("launch_automl"), "Lancer AutoML"),
    br(), br(),
    h4("Meilleurs modèles proposés par AutoML"),
    uiOutput(ns("download_ui")),
    br(), br(),
    DT::dataTableOutput(ns("automl_results"))
  )
}

# ==== MODULE SERVER ====
automl_server <- function(id, dataset) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    automl_results <- reactiveVal(NULL)
    
    observeEvent(input$launch_automl, {
      req(input$target)
      
      # ⚠️ Simule ici une réponse JSON AutoML (comme si FastAPI répondait)
      # Dans ta vraie app tu utiliseras POST vers FastAPI avec upload_file(tmpfile)
      result_df <- data.frame(
        Model = c("Random Forest", "XGBoost", "Logistic Regression"),
        Accuracy = c(0.92, 0.91, 0.85),
        AUC = c(0.95, 0.94, 0.88)
      )
      automl_results(result_df)
      
      output$automl_results <- DT::renderDataTable({
        DT::datatable(result_df)
      })
    })
    
    # ✅ Affiche bouton download si résultats dispo
    output$download_ui <- renderUI({
      req(automl_results())
      downloadButton(ns("download_automl_results"), "Télécharger les résultats (.csv)")
    })
    
    output$download_automl_results <- downloadHandler(
      filename = function() {
        paste0("AutoML_Results_", Sys.Date(), ".csv")
      },
      content = function(file) {
        write.csv(automl_results(), file, row.names = FALSE)
      }
    )
  })
}

# ==== UI GLOBAL ====
ui <- fluidPage(
  titlePanel("Mini Test AutoML Module"),
  sidebarLayout(
    sidebarPanel(
      helpText("Simulation d’un appel AutoML avec résultats téléchargeables")
    ),
    mainPanel(
      automl_ui("automl_module")
    )
  )
)

# ==== SERVER GLOBAL ====
server <- function(input, output, session) {
  # Dummy dataset pour le test
  dataset <- reactive({
    data.frame(target = c(1, 0, 1), feature1 = c(3.5, 2.1, 4.2))
  })
  
  automl_server("automl_module", dataset)
}

shinyApp(ui, server)
