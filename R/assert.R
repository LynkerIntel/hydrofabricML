#' Enable assertions
#' @rdname assert
#' @export
enable_assertions <- function() {
    assign("disable_assert", FALSE, envir = ..env)
}

#' Disable assertions
#' @rdname assert
#' @export
disable_assertions <- function() {
    assign("disable_assert", TRUE, envir = ..env)
}

#' Expected predictors
#' @keywords internal
.predictors <- c(
    "pathlength",
    "arbolatesu",
    "lengthkm",
    "areasqkm",
    "slope"
)

#' Checks if assertions are disabled. If `disable_assert`, or `..env`
#' cannot be found, then it defaults to FALSE.
#' @keywords internal
.is_assert_disabled <- function() {
    if (! "disable_assert" %in% ls(..env)) {
        return(FALSE)
    }

    get("disable_assert", envir = ..env)
}

#' This assertion checks that the `.predictors` columns
#' are all contained within `newdata`
#' @keywords internal
.assert_predictors <- function(newdata) {
    if (.is_assert_disabled()) return(invisible(NULL))

    found_predictors <- .predictors %in% names(newdata)
    if (!all(found_predictors)) {
        .set_error(cli::cli_abort(
            paste(
                "`newdata` cannot be used for predictions,",
                "missing {sum(!found_predictors)} predictor{?s}:",
                "{(.predictors[!found_predictors])}"
            )
        ))
    }
}

#' This assertion checks that the columns of `newdata`
#' do not contain any of: NaNs, NAs, Infinities
#' @importFrom stats setNames
#' @importFrom stats na.omit
#' @keywords internal
.assert_valid <- function(newdata) {
    if (.is_assert_disabled()) return(invisible(NULL))

    columns <- names(newdata)
    contains_invalid <- sapply(X = columns, FUN = function(column) {
        if (any(is.nan(newdata[[column]]))) {
            "contains NaNs"
        } else if (any(is.na(newdata[[column]]))) {
            "contains NAs"
        } else if (any(is.infinite(newdata[[column]]))) {
            "contains Infinities"
        } else {
            NA_character_
        }
    })

    contains_invalid <- na.omit(contains_invalid)
    if (length(contains_invalid) > 0) {
        .set_error(cli::cli_abort(
            c(
                "`newdata` cannot be used for predictions:",
                setNames(
                    paste0(names(contains_invalid), ": ", contains_invalid),
                    rep("x", times = length(contains_invalid))
                )
            )
        ))
    }
}
