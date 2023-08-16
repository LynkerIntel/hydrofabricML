.onAttach <- function(libname, pkgname) {
    # Check for model existence and prompt user to download if needed
    if (.check_model_on_load(pkgname)) {
        # Load model into runtime
        .load_model()
    }
}

#' @keywords internal
.check_interactive <- function() {
    if (!interactive()) {
        cli::cli_abort(
            "User input required, but session is not interactive."
        )
    }
}

#' @importFrom utils menu
#' @keywords internal
.model_menu_response <- function(pkgname) {
    cli::cli_inform(
        c(
            "{.pkg {pkgname}} requires an external model.",
            "i" = cli::col_grey("Model URL: {.url {(.get_model_url())}}"),
            "i" = cli::col_grey("Cache Path: {.file {(.get_model_dir())}}"),
            "i" = cli::col_grey("Model Size: ~20 MB"),
            ""
        )
    )

    utils::menu(
        choices = c("Yes", "No"),
        title = "Would you like to download it now?"
    )
}

#' @keywords internal
.model_not_loaded_warning <- function(pkgname) {
    cli::cli_warn(
        c(
            "{.pkg {pkgname}} will not load model into runtime.",
            "!" = "Call {.code {pkgname}::download_model()} to get model."
        )
    )
}

#' @keywords internal
.check_model_on_load <- function(pkgname) {
    if (.model_exists()) {
        # Model already exists
        return(TRUE)
    }

    if (!interactive()) {
        # User cannot provide input
        return(FALSE)
    }


    # Get user response and fail if user declines
    if (.model_menu_response(pkgname) != 1) {
        .model_not_loaded_warning(pkgname)
        return(FALSE)
    }

    # User accepted
    download_model()
    return(TRUE)
}
