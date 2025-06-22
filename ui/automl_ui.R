automl_ui <- function(id) {
  ns <- NS(id)
  tagList(
    h3("Analyse AutoML avec PyCaret"),
    uiOutput(ns("target_selector")),
    actionButton(ns("launch_automl"), "Lancer AutoML"),
    br(), br(),
    h4("Meilleurs modèles proposés par AutoML"),
    br(), br(),
    
    ## Ajout d'un container dynamique qui affiche le bouton SEULEMENT s'il y a un tableau
    uiOutput(ns("download_ui")),
    br(), br(),

    DT::dataTableOutput(ns("automl_results"))
  )
}
