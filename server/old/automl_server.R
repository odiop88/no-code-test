library(httr)

automl_server <- function(id, rv_current) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    output$target_selector <- renderUI({
      req(rv_current$working_df)
      selectInput(ns("target"),
                  "Choisissez la variable cible",
                  choices = names(rv_current$working_df))
    })
    
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
        output$automl_results <- DT::renderDataTable({
          DT::datatable(result_df)
        })
      } else {
        showNotification("Erreur lors de l’appel à l’API AutoML", type = "error")
      }
    })
  })
}
