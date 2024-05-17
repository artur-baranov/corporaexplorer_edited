
# Function files ----------------------------------------------------------
source("./global/function_display_document.R", local = TRUE)
source("./global/function_display_document_info.R", local = TRUE)
source("./global/function_filter_corpus.R", local = TRUE)
source("./global/function_find_row_in_df.R", local = TRUE)
source("./global/function_format_date.R", local = TRUE)
source("./global/function_insert_doc_links.R", local = TRUE)
source("./global/function_plot_size.R", local = TRUE)
source("./global/function_visualise_corpus.R", local = TRUE)
source("./global/function_visualise_document.R", local = TRUE)
source("./global/functions_info.R", local = TRUE)
source("./global/functions_main_search_engine.R", local = TRUE)

# Setting up data and config ----------------------------------------------
if (!is.null(getOption("shiny.testmode"))) {
  if (getOption("shiny.testmode") == TRUE) {
    source("./config/config_tests.R", local = TRUE)
  }
} else {
  source("./config/config.R", local = TRUE)
}

#=============================================================================#
####================================  UI  =================================####
#=============================================================================#

ui <- function(request) {
  
  
  
  shinydashboard::dashboardPage(
    title = if (CORPUS_TITLE == "Corpus map") "Manifesto Explorer" else CORPUS_TITLE,
    
    # Header --------------------------------------------------------------
    source("./ui/ui_header.R", local = TRUE)$value,

    # Sidebar -------------------------------------------------------------
    source("./ui/ui_sidebar.R", local = TRUE)$value,

    # Body ----------------------------------------------------------------

    shinydashboard::dashboardBody(
      wellPanel(    markdown("

     The [Manifesto Explorer Dashboard](https://irishpoliticsdata.shinyapps.io/manifestoexplorer) provides an overview of party manifestos for local and European Parliament elections in Ireland since 1999. The dashboard allows users to explore the content of manifestos, compare parties, and track changes over time. After loading the dashboard, you can click on a party manifesto to read the content. You can also look up specific terms and check how often and in which context these words appear in the manifestos.
     Simply add _Additional terms for text highlighting_ to the search box and click _Search_. The dashboard will highlight the terms in the text and show the frequency of the terms in the manifestos.
     
     We converted manifestos from PDFs to text files and manually cleaned the text to ensure the best possible quality. 
     
     Most of the [raw PDF files](http://www.michaelpidgeon.com/manifestos/) were provided by [Michael Pidgeon](https://pidgeon.ie). We thank [Artur Baranov](https://artur-baranov.github.io) for technical support.
    
     You are free to use data and results from the Manifesto Explorer in your research or in news articles if you cite: 
     
     Stefan Müller and Paula Montano. 2024. _Manifesto Explorer for Irish Local and European Parliament Elections. URL: https://irishpoliticsdata.shinyapps.io/manifestoexplorer/

     Please contact [Stefan Müller](https://muellerstefan.net) if you have any questions or suggestions.

    ")),
      # CSS and JS files --------------------------------------------------
      source("./ui/css_js_import.R", local = TRUE)$value,
      source("./ui/css_from_arguments.R", local = TRUE)$value,

      # Fluid row ---------------------------------------------------------

      shiny::fluidRow(
        
               # Corpus map/corpus info box -------------------------------
               source("./ui/ui_corpus_box.R", local = TRUE)$value,

               # A day in the corpus box (for data_365) -------------------
               source("./ui/ui_day_in_corpus_box.R", local = TRUE)$value,

               # Document box ---------------------------------------------
               source("./ui/ui_document_box.R", local = TRUE)$value

               # Fluid row ends
               ),
      
      wellPanel(    markdown("

    The project received financial support from the 2021 Strategic Funding Scheme of the [UCD College of Social Sciences and Law](https://www.ucd.ie/socscilaw/).
    
    This website is based on the [corporaexplorer](https://kgjerde.github.io/corporaexplorer/index.html) R package. 
    
    To explore more dataset and text corpora related to Irish politics, please visit [irishpoliticsdata.com](https://irispoliticsdata.com).
    ")),

               # shinyjs
               
               shinyjs::useShinyjs(),
               shinyWidgets::useSweetAlert()

               # Body ends
      ),
      # Page ends
    )
  
}

#=============================================================================#
####================================SERVER=================================####
#=============================================================================#

server <- function(input, output, session) {

# Session scope function files --------------------------------------------
source("./server/functions_collect_input_terms.R", local = TRUE)
source("./server/functions_checking_input.R", local = TRUE)
source("./server/functions_ui_management.R", local = TRUE)
source("./server/function_collect_edited_info_plot_legend_keys.R", local = TRUE)

# Conditional and customised sidebar UI elements --------------------------
source("./ui/render_ui_sidebar_checkbox_filtering.R", local = TRUE)
source("./ui/render_ui_sidebar_date_filtering.R", local = TRUE)
source("./ui/hide_ui_sidebar_plot_mode.R", local = TRUE)
source("./ui/set_colours_in_search_fields.R", local = TRUE)

# Session variables -------------------------------------------------------
source("./server/session_variables.R", local = TRUE)

# For use with potential "extra" plugins ----------------------------------
if (INCLUDE_EXTRA == TRUE) {
  source("./extra/extra_render_ui_sidebar_magic_filtering.R", local = TRUE)
  source("./extra/extra_tab_content.R", local = TRUE)
  source("./extra/extra_ui_management_functions.R", local = TRUE)
  source("./extra/extra_session_variables.R", local = TRUE)
}

# Corpus info tab ---------------------------------------------------------
source("./server/corpus_info_tab.R", local = TRUE)

# 1. Startup actions ------------------------------------------------------
source("./server/1_startup_actions.R", local = TRUE)

# 2. Event: search button -------------------------------------------------
source("./server/2_event_search_button.R", local = TRUE)

# 3. Event: click in corpus map -------------------------------------------
source("./server/3_event_corpus_map_click.R", local = TRUE)

# 4. Event: click in day map ----------------------------------------------
source("./server/4_event_day_map_click.R", local = TRUE)

# 5. Event: click in document visualisation -------------------------------
source("./server/5_event_document_visualisation_click.R", local = TRUE)

# 6. Event: hovering in corpus map ----------------------------------------
source("./server/6_event_hover_corpus_map.R", local = TRUE)

# 7. Event: update plot size ----------------------------------------------
source("./server/7_event_plot_size_button.R", local = TRUE)

# Cleaning up the session -------------------------------------------------
shiny::onSessionEnded(function() {
  shiny::shinyOptions("corporaexplorer_data" = NULL)
  shiny::shinyOptions("corporaexplorer_search_options" = NULL)
  shiny::shinyOptions("corporaexplorer_ui_options" = NULL)
  shiny::shinyOptions("corporaexplorer_input_arguments" = NULL)
  shiny::shinyOptions("corporaexplorer_plot_options" = NULL)
  shiny::shinyOptions("corporaexplorer_extra" = NULL)
})
}

# Run app -----------------------------------------------------------------
shiny::shinyApp(ui, server)
