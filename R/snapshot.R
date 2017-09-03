#' @importFrom magrittr %>%
#' @importFrom glue glue
#' @importFrom rvest html_node html_text html_attr
selection <- function(selector, fun = identity){
  function(x){
    html_node(x, selector) %>%
      html_attr("content") %>%
      fun
  }
}

meta_property <- function(property, fun = identity ){
  selection( glue( 'head meta[property="{property}"]' ), fun )
}

meta_twitter <- function(property, fun = identity ){
  selection( glue( 'head meta[name="twitter:{property}"]' ), fun )
}


meta_title <- meta_property("og:title")
meta_description <- meta_property("og:description")
meta_site_name <- meta_property("og:site_name")
meta_published <- meta_property("article:published_time", lubridate::ymd_hms)
meta_keywords <- selection( 'head meta[names="keywords"]' )

meta_twitter_handle <- meta_twitter("site")

#' Transforme un url en un article pour rfrance
#'
#' - extraction de quelques informations (titre, description, ...)
#' - webshot
#' - creation
#'
#' @importFrom xml2 read_html
#' @importFrom webshot webshot
#' @importFrom rlang %||%
#' @importFrom lubridate now
#' @importFrom stringr str_to_lower str_replace_all
#' @export
snapshot <- function(
  url,
  site = ".",
  title = NULL, description = NULL, site_name = NULL, published = NULL, twitter = NULL, keywords = NULL
  ){
  html <- read_html(url)

  # extract meta information from posts
  title <- title %||% meta_title(html)
  description <- description %||% meta_description(html)
  site_name <- site_name %||% meta_site_name(html)
  published <- published %||% meta_published(html)
  if(is.na(published)){
    published <- now()
  }
  twitter <- twitter %||% meta_twitter_handle(html)

  keywords <- keywords %||% meta_keywords(html)
  if( is.na(keywords) ){
    keywords <- "[]"
  } else {
    keywords <- paste0( '[' , paste( '"', keywords, '"', collapse = ",") , ']')
  }

  date <- format( published, "%Y-%m-%d" )
  slug <- str_to_lower(title) %>%
    str_replace_all( "[^a-zA-Z0-9]", "-" ) %>%
    str_replace_all( "-+", "-")

  filename <- glue("{date}-{slug}")

  # take webshot
  png <- file.path( normalizePath(site), "static", "images", glue("{filename}.png") )
  if( !file.exists(png) ){
    message( glue("snapshot dans {png}") )
    webshot(url, file = png )
  }

  template <- paste(readLines( system.file("template", "article.md", package = "rfrance") ), collapse = "\n" )
  txt <- glue(template)
  md  <- file.path( normalizePath(site), "content", "post", glue("{filename}.md") )
  if( file.exists(md)) unlink(md)
  message( glue("generation de l'article dans {md}") )
  writeLines(txt, md)

  invisible(NULL)
}
