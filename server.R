server <- function(input, output, session) {
  #http://127.0.0.1:3775/?selected_language=cz&model=Czech this will just take the user to the desired tab, with the desired language
  #127.0.0.1:3775/?model=Czech&soil_water=soil_water_waterlogged&habitus=bush this triggers a modal dialog to download a txt file with the species scores for this particular set of conditions
  reactive_DataSuitability <<- reactiveVal(data.frame(x = numeric(), y = numeric()))
  reactive_plotSuitability <<- reactiveVal(ggplot())
  reactive_Interface <<- reactiveVal(list())
  reactive_AdditionalInfo <<- reactiveVal(data.frame(x = numeric(), y = numeric()))
  reactive_inputs <<- reactiveVal(list())

  # We need to access the data from TabInterface (output$DTSuitability)
  access_DataSuitability <- function() {
    print("Suitability data accessed")
    DataSuitability <- reactive_DataSuitability()
    reactive_DataSuitability()
  }

  # We need to access the plot from TabInterface (output$barplot_suitability)
  access_plotSuitability <- function() {
    print("Suitability plot accessed")
    plotSuitability <- reactive_plotSuitability()
    reactive_plotSuitability()
  }

  # We need to access the interface from global (orderdf)
  access_Interface <- function() {
    print("Interface accessed")
    interface <- reactive_Interface()
    reactive_Interface()
  }

  # We need to access the additional info from TabInterface (output$DTinformations)
  access_AdditionalInfo <- function() {
    print("Additional informations accessed")
    additionalinfo <- reactive_AdditionalInfo()
    reactive_AdditionalInfo()
  }

  access_inputs <- function() {
    print("Inputs accessed")
    inputsdata <- reactive_inputs()
    reactive_inputs()
  }

  # Download handler for svg
  observe({
    output$downloadSVG <- downloadHandler(
      filename = function() {
        paste("AGFTadvice_results_", Sys.Date(), ".zip", sep = "")
      },
      content = function(file) {
        OutputPlots <- CombinePlotsForDownload(
          interface = req(access_Interface()), 
          language = req(language()), 
          DataSuitability = req(access_DataSuitability()), 
          plotSuitability = req(access_plotSuitability()),
          inputsdata = req(access_inputs())
        )

        OutputAdditionalInfo <- create_dataINFO_plot(
          datainfo = req(access_AdditionalInfo()), 
          language = req(language())
          )
        
        tempDir <- tempdir()
        tempSVG1 <- file.path(tempDir, "AGFTadvice_results.svg")
        tempSVG2 <- file.path(tempDir, "AGFTadvice_additionalinfo.svg")

        svg(tempSVG1, height = 19, width = 14)
        print(OutputPlots)
        dev.off()

        svg(tempSVG2, height = 19, width = 14)
        print(OutputAdditionalInfo)
        dev.off()
        
        # Create a ZIP file containing both SVGs
        oldwd <- setwd(tempDir)
        on.exit(setwd(oldwd), add = TRUE)
        zip::zip(file, files = c("AGFTadvice_results.svg", "AGFTadvice_additionalinfo.svg"))

        # Clean up temporary files
        unlink(tempSVG1)
        unlink(tempSVG2)
       }
    )
  })

  # Download handler for pdf
  observe({
    output$downloadPDF <- downloadHandler(
      filename = function() {
        paste("AGFTadvice_results_", Sys.Date(), ".zip", sep = "")
      },
      content = function(file) {
        OutputPlots <- CombinePlotsForDownload(
          interface = req(access_Interface()), 
          language = req(language()), 
          DataSuitability = req(access_DataSuitability()), 
          plotSuitability = req(access_plotSuitability()),
          inputsdata = req(access_inputs())
        )

        OutputAdditionalInfo <- create_dataINFO_plot(
          datainfo = req(access_AdditionalInfo()), 
          language = req(language())
          )

        tempDir <- tempdir()
        tempSVG1 <- file.path(tempDir, "AGFTadvice_results.svg")
        tempSVG2 <- file.path(tempDir, "AGFTadvice_additionalinfo.svg")
        tempPDF1 <- file.path(tempDir, "AGFTadvice_results.pdf")
        tempPDF2 <- file.path(tempDir, "AGFTadvice_additionalinfo.pdf")


        svg(tempSVG1, height = 19, width = 14)
        print(OutputPlots)
        dev.off()
        rsvg_pdf(tempSVG1, tempPDF1,  height = 3508, width = 2480)  # metrics are in pixels - 1 inch = 96 pixels; A4 is 2480 x 3508 pixels

        svg(tempSVG2, height = 19, width = 14)
        print(OutputAdditionalInfo)
        dev.off()
        rsvg_pdf(tempSVG2, tempPDF2,  height = 3508, width = 2480)  # metrics are in pixels - 1 inch = 96 pixels; A4 is 2480 x 3508 pixels
        
        # Create a ZIP file containing both SVGs
        oldwd <- setwd(tempDir)
        on.exit(setwd(oldwd), add = TRUE)
        zip::zip(file, files = c("AGFTadvice_results.pdf", "AGFTadvice_additionalinfo.pdf"))

        # Clean up temporary files
        unlink(tempSVG1)
        unlink(tempSVG2)
        unlink(tempPDF1)
        unlink(tempPDF2)
      }
    )
  })

  # Download handler for csv
  observe({
    output$downloadCSV <- downloadHandler(
      filename = function() {
        paste("AGFTadvice_csv_results_", Sys.Date(), ".csv", sep = "")
      },
    content = function(file) {
      csv_data <- data.frame(req(access_DataSuitability()))
      write.csv(csv_data, file, row.names = FALSE)
      }
    )
  })

  # Download handler for excel
  observe({
    output$downloadExcel <- downloadHandler(
      filename = function() {
        paste("AGFTadvice_excel_results_-", Sys.Date(), ".xlsx", sep = "")
      },
      content = function(file) {
        excel_data <- data.frame(req(access_DataSuitability()))
        write.xlsx(excel_data, file, rowNames = FALSE)
      }
    )
  })
    
  # use shiny.i18n to update the language and translate the app
  observeEvent(input$selected_language, {
    # Print the selected language to the console
    print(paste("The selected language has changed to:", input$selected_language))
    shiny.i18n::update_lang(input$selected_language)
  })
    
  # Reactive expression for the selected language - still needed for some functions
  language <- reactive({
    input$selected_language
  })


  observe({
    query <- parseQueryString(session$clientData$url_search)
    
    if (!is.null(query[['selected_language']])) {
      updateRadioButtons(session, "selected_language", selected = query[['selected_language']])
    }
    
    desiredmodel <- query$model 
    if(is.null(input$sidemenu) || !is.null(desiredmodel) && desiredmodel != input$sidemenu){
      freezeReactiveValue(input, "sidemenu")
      updateTabItems(session, "sidemenu", selected = "tool")
      freezeReactiveValue(input, "toolsTabset")
      # print(desiredmodel)
      updateTabsetPanel(session, "toolsTabset", selected = desiredmodel)
    }
    
    allotherparameters<-setdiff(names(query), c("selected_language", "model"))
    if(length(allotherparameters)>0){ #we passed parameters by URL = we want to get the results as csv
      queryinputs<-unlist(query[allotherparameters]) #icicicic todo : check that all necessary inputs are provided before sending to the suitability function
      print(paste("computing suitability of model", desiredmodel))
      resultdf<-do.call(paste("compute_suitability_", desiredmodel, sep=""), list(
        inputsdata=queryinputs,
        database=get(paste("data", desiredmodel, sep="")), 
        interface=get(paste("interface", desiredmodel, sep="")))
      )
      #print(str(resultCSV))
      # Define a function to generate and return the CSV content
      generatetxtContent <- function(df) {
        m <- as.matrix(df)
        # add column headers
        m <- rbind(dimnames(m)[[2]], m)
        m<-apply(m, 1, paste, collapse="\t")
        return(m)
      }
      
      preview_table <- head(resultdf, n = 5)
      
      # Display data preview in the modal
      output$dataPreview <- renderUI({
        tableOutput("previewTable")
      })
      output$previewTable <- renderTable({
        preview_table
      })
      
      # Handle the download button within the modal
      output$modalDownload <- downloadHandler(
        filename = function() {
          "computed_data.csv"
        },
        content = function(file) {
          txt_content <- generatetxtContent(resultdf)
          writeLines(txt_content, file)
        }
      )

      
      
    }
    
  }) #end managing URL queries
  
  
  
  
  # For the database page ----
  
  
  # Prepare the map data
  map_data <- reactive({
    data <- prepare_map_data(toolsdata)
    # Filter data based on selected projects
    if (!is.null(input$project_select)) {
      data <- data[data$project %in% input$project_select,]
    }
    return(data)
  })
  
  # Create the map with colored countries (non-interactive, fit to world)
  output$map <- renderLeaflet({
    data <- map_data()
    world <- maps::map("world", fill = TRUE, plot = FALSE)
    world_sf <- sf::st_as_sf(world)
    country_colors <- setNames(data$color, data$country)
    world_sf$fillColor <- country_colors[as.character(world_sf$ID)]
    world_sf$fillColor[is.na(world_sf$fillColor)] <- "#CCCCCC"

    # Combine countries by tool (project) for the legend
    legend_data <- unique(data[, c("country", "color", "project")])
    legend_data <- legend_data[order(legend_data$project, legend_data$country), ]
    # For each project, get all countries
    legend_by_project <- aggregate(country ~ project + color, legend_data, function(x) paste(sort(x), collapse = ", "))
    legend_html <- "<div style='padding: 8px; background-color: white; border-radius: 4px; border: 1px solid #ccc; max-height: 350px; overflow-y: auto;'>"
    legend_html <- paste0(legend_html, "<div style='font-weight: bold; margin-bottom: 5px;'>Tool &rarr; Country(ies)</div>")
    for (i in seq_len(nrow(legend_by_project))) {
      color <- legend_by_project$color[i]
      project <- legend_by_project$project[i]
      countries <- legend_by_project$country[i]
      legend_html <- paste0(
        legend_html,
        "<div style='margin: 3px 0;'><span style='background-color: ",
        color,
        "; width: 14px; height: 14px; border-radius: 3px; display: inline-block; margin-right: 6px; border: 1px solid #888;'></span>",
        "<b>", project, "</b>: ", countries,
        "</div>"
      )
    }
    legend_html <- paste0(legend_html, "</div>")

    leaflet(world_sf, options = leafletOptions(
      zoomControl = TRUE, dragging = TRUE, doubleClickZoom = TRUE,
      scrollWheelZoom = FALSE, boxZoom = FALSE, keyboard = FALSE,
      minZoom = 2, maxZoom = 4
    )) %>%
      addTiles() %>%
      addPolygons(
        fillColor = ~fillColor,
        fillOpacity = 0.6,
        color = "#444444",
        weight = 1,
        popup = NULL,
        highlightOptions = NULL
      ) %>%
      addControl(
        html = legend_html,
        position = "bottomright"
      )
})

  # Update map polygons and add a custom legend when selection changes (keep non-interactive)
  observe({
    data <- map_data()
    world <- maps::map("world", fill = TRUE, plot = FALSE)
    world_sf <- sf::st_as_sf(world)
    country_colors <- setNames(data$color, data$country)
    world_sf$fillColor <- country_colors[as.character(world_sf$ID)]
    world_sf$fillColor[is.na(world_sf$fillColor)] <- "#CCCCCC"

    # Combine countries by tool (project) for the legend
    legend_data <- unique(data[, c("country", "color", "project")])
    legend_data <- legend_data[order(legend_data$project, legend_data$country), ]
    legend_by_project <- aggregate(country ~ project + color, legend_data, function(x) paste(sort(x), collapse = ", "))
    legend_html <- "<div style='padding: 8px; background-color: white; border-radius: 4px; border: 1px solid #ccc; max-height: 350px; overflow-y: auto;'>"
    legend_html <- paste0(legend_html, "<div style='font-weight: bold; margin-bottom: 5px;'>Tool &rarr; Country(ies)</div>")
    for (i in seq_len(nrow(legend_by_project))) {
      color <- legend_by_project$color[i]
      project <- legend_by_project$project[i]
      countries <- legend_by_project$country[i]
      legend_html <- paste0(
        legend_html,
        "<div style='margin: 3px 0;'><span style='background-color: ",
        color,
        "; width: 14px; height: 14px; border-radius: 3px; display: inline-block; margin-right: 6px; border: 1px solid #888;'></span>",
        "<b>", project, "</b>: ", countries,
        "</div>"
      )
    }
    legend_html <- paste0(legend_html, "</div>")

    leafletProxy("map", data = world_sf) %>%
      clearShapes() %>%
      addPolygons(
        fillColor = ~fillColor,
        fillOpacity = 0.6,
        color = "#444444",
        weight = 1,
        popup = NULL,
        highlightOptions = NULL
      ) %>%
      clearControls() %>%
      addControl(
        html = legend_html,
        position = "bottomright"
      )
  })

  # Show project table
  output$DTToolComparison <- renderDT({
    selected_data <- toolsdata[toolsdata$project %in% input$project_select,]

    # Replace link_reference and Link_standalone with clickable icons if present
    icon_link <- function(url) {
      if (!is.na(url) && url != "") {
        # Use fa-link icon (FontAwesome 4, more widely available)
        return(paste0("<a href='", url, "' target='_blank'><i class='fa fa-link'></i></a>"))
      } else {
        return("")
      }
    }
    selected_data$link_reference <- vapply(selected_data$link_reference, icon_link, character(1))
    selected_data$Link_standalone <- vapply(selected_data$Link_standalone, icon_link, character(1))

    # Get color for each project from map_data
    mapdata <- map_data()
    project_colors <- unique(mapdata[, c("project", "color")])
    color_vec <- setNames(project_colors$color, project_colors$project)
    color_col <- color_vec[selected_data$project]
    color_col[is.na(color_col)] <- "#FFFFFF"
    
    # Add a new column as the first column for color
    selected_data$.__ <- color_col
    selected_data <- selected_data[, c(ncol(selected_data), 1:(ncol(selected_data)-1))]
    
    datatable(
      selected_data,
      escape = FALSE,
      rownames = FALSE,
      options = list(
        dom = 't',
        paging = FALSE,
        columnDefs = list(
          list(width = '10px', targets = 0), # narrow color column
          list(orderable = FALSE, targets = 0)
        )
      ),
      selection = 'none',
      callback = JS(
        "table.on('draw', function(){",
        "  table.columns(0).nodes().flatten().to$().each(function(i, el){",
        "    var color = $(el).text();",
        "    $(el).css({'background-color': color, 'color': color, 'padding': 0, 'width':'20px'});",
        "    $(el).text('');",
        "  });",
        "});"
      )
    ) %>%
      formatStyle(
        columns = 1,
        backgroundColor = styleEqual(color_col, color_col)
      )
  })
  
  
  # Czech tree advice ----
  moduleTabInterface_Server(id = "Czech",
                            language= language,
                            data=dataCzech, interface=interfaceCzech, functionSuitability=compute_suitability_Czech, compactobjectives=FALSE)
  
  
  # Flanders tree advice ----
  moduleTabInterface_Server(id = "DENTRO",
                            language= language,
                            data = dataDENTRO, interface= interfaceDENTRO, functionSuitability=compute_suitability_DENTRO, compactobjectives=TRUE)
  
  # Shade tree advice ----
  moduleTabInterface_Server(id = "STA",
                            language= language,
                            data=dataSTA, interface=interfaceSTA, functionSuitability=compute_suitability_STA, compactobjectives=FALSE)
  
  
  # Deciduous ----
  moduleTabInterface_Server(id = "DECIDUOUS",
                            language= language,
                            data=dataDECIDUOUS, interface=interfaceDECIDUOUS, functionSuitability=compute_suitability_DECIDUOUS, compactobjectives=FALSE)
  
  # Species Climate Suitability Model ----
  moduleTabInterface_Server(id = "SCSM",
                            language= language,
                            data=dataSCSM, interface=interfaceSCSM, functionSuitability=compute_suitability_SCSM, compactobjectives=FALSE)
  
  # Juiste Boom op de Juiste Plek ----
  
  moduleTabInterface_Server(id = "JBOJP",
                            language= language,
                            data=dataJBOJP, interface=interfaceJBOJP, functionSuitability=compute_suitability_JBOJP, compactobjectives=FALSE)
  
  
  # German Hedgerow manager ----
  moduleTabInterface_Server(id = "DEHM",
                            language= language,
                            data=dataDEHM, interface=interfaceDEHM, functionSuitability=compute_suitability_DEHM, compactobjectives=FALSE)
  
  
  # Finnish tree suitability ----
  moduleTabInterface_Server(id = "SUOMI",
                            language= language,
                            data=dataSUOMI, interface=interfaceSUOMI, functionSuitability=compute_suitability_SUOMI, compactobjectives=FALSE)
  
  # UK Guide of agroforestry trees  ----
  moduleTabInterface_Server(id = "UKguide",
                            language= language,
                            data=dataUKguide, interface=interfaceUKguide, functionSuitability=compute_suitability_UKguide, compactobjectives=FALSE)
  
  
  
}

