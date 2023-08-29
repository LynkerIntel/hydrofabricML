#' Package-wide environment for model
#'
#' @details
#' This environment contains the following elements:
#' - `$model`: the `caret`-trained GBM model
#' - `$disable_assert`: Boolean representing whether assertions should run
#'
#' @keywords internal
..env <- new.env()

#' Load model into memory
#' @keywords internal
.load_model <- function(override_path = NULL) {
    path <- if (!is.null(override_path)) override_path else .get_model_path()
    assign("model", readRDS(path), envir = ..env)
}

#' Unload model from memory
#' @keywords internal
.unload_model <- function() {
    rm("model", envir = ..env)
}

#' Get model from internal environment
#' @returns gbm model
#' @keywords internal
.get_model <- function() {
    get("model", envir = ..env)
}

#' @keywords internal
.is_model_loaded <- function() {
    "model" %in% ls(..env)
}
