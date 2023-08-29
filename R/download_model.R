#' Download the GBM roughness model
#'
#' @description
#' If the model does not exist in the cache directory,
#' this function invokes the internal download model function
#' to pull it from a CDN. If the model does exist, then this
#' function performs no operation.
#'
#' @export
download_model <- function() {
    if (!.model_exists()) {
        .download_model()
    }
}

#' Get the model URL
#' @keywords internal
.get_model_url <- function() {
    paste0(
        "https://cdn.jsdelivr.net/gh/LynkerIntel/",
        "roughness-api/models/gbm/roughness-pruned.rds"
    )
}

#' Download model from a URL
#' @importFrom utils download.file
#' @keywords internal
.download_model <- function() {
    if (!dir.exists(.get_model_dir())) {
        dir.create(.get_model_dir())
    }

    download.file(.get_model_url(), .get_model_path())
}

#' Get the model cache directory
#' @keywords internal
.get_model_dir <- function() {
    rappdirs::user_cache_dir("roughness")
}

#' Get the path to the cached model
#' @keywords internal
.get_model_path <- function() {
    file.path(.get_model_dir(), "roughness.rds")
}

#' Check if the model exists in the cache directory
#' @keywords internal
.model_exists <- function() {
    file.exists(.get_model_path())
}
