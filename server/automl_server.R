library(httr)

automl_server <- function(id, rv_current) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Réactive value pour stocker les résultats AutoML
    automl_results <- reactiveVal(NULL)
    
    # Sélecteur de variable cible
    output$target_selector <- renderUI({
      req(rv_current$working_df)
      selectInput(ns("target"),
                  "Choisissez la variable cible",
                  choices = names(rv_current$working_df))
    })
    
    # Lancer AutoML via API
    observeEvent(input$launch_automl, {
      req(rv_current$working_df, input$target)
      
      tmpfile <- tempfile(fileext = ".csv")
      write.csv(rv_current$working_df, tmpfile, row.names = FALSE)
      
      res <- httr::POST(
        url = "http://127.0.0.1:8000/automl",
        body = list(
          target = input$target,
          file = upload_file(tmpfile)
        ),
        encode = "multipart"
      )
      
      if (res$status_code == 200) {
        result_df <- jsonlite::fromJSON(httr::content(res, as = "text"), flatten = TRUE)
        
    #Mise à jour du résultat
        automl_results(result_df)
        
      } else {
        showNotification("Erreur lors de l’appel à l’API AutoML", type = "error")
      }
    })
    
    #Affichage du tableau AutoML
    output$automl_results <- DT::renderDataTable({
      req(automl_results())
      DT::datatable(automl_results())
    })
    
    
    # Crée dynamiquement le bouton uniquement si des résultats existent
    output$download_ui <- renderUI({
      req(automl_results())
      downloadButton(ns("download_automl_results"), "Télécharger les résultats (.csv)")
    })
    
    # Handler de téléchargement
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
