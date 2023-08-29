#' Retrieve the last error from the predictions
#' @export
last_error <- function() {
    if (! "last_error" %in% ls(..env)) {
        return(NA)
    }

    get("last_error", envir = ..env)
}

#' @keywords internal
.set_error <- function(message, ...) {
    assign(
        x = "last_error",
        value = structure(.Data = message, ...),
        envir = ..env
    )
}
