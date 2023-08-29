#' Predict roughness values using GBM model.
#' @param newdata (`data.frame`)\cr
#'        Must contain the correct predictor columns, i.e.
#'        "pathlength", "arbolatesu", "lengthkm", "areasqkm", "slope"
#' @return `data.frame` with the column `$.pred` containing the predictions.
#' @importFrom stats predict
#' @importFrom gbm predict.gbm
#' @importFrom caret predict.train
#' @export
hr_predict <- function(newdata, ..., global = 0.05, override_path = NULL) {
    ..subset <- .preprocess(newdata)

    ..invalid <- which(is.infinite(..subset$areasqkm))
    ..subset$areasqkm[..invalid] <- 1

    .assert_predictors(..subset)
    .assert_valid(..subset)

    if (!.is_model_loaded()) {
        .load_model(override_path)
    }

    roughness <- predict(object = .get_model(), newdata = ..subset)
    roughness <- exp(roughness)
    roughness[..invalid] <- global

    if (length(..invalid) > 0) {
        .set_error(
            cli::cli_warn(c(
                "!" = "{length(..invalid)} row{?s} cannot be predicted on.",
                "i" = "Setting them to a global value of {global}.",
                "i" = "Use hydrofab.roughness::last_error()$indices to get invalid indices."
            )),
            indices = ..invalid
        )
    }

    data.frame(roughness = round(roughness, 3))
}

#' Augment data with GBM-based roughness predictions.
#' @param newdata (`data.frame`)\cr
#'        Must contain the correct predictor columns, i.e.
#'        "pathlength", "arbolatesu", "lengthkm", "areasqkm", "slope"
#' @return `newdata` with `$.pred` column containing the predictions.
#' @export
hr_augment <- function(newdata, ..., global = 0.05, override_path = NULL) {
    cbind(newdata, hr_predict(
        newdata,
        ...,
        global = global,
        override_path = override_path
    ))
}

#' @keywords internal
.preprocess <- function(newdata) {
    if ("sf" %in% class(newdata) && requireNamespace("sf", quietly = TRUE)) {
        newdata <- sf::st_drop_geometry(newdata)
    }

    # Get only valid columns
    ..subset <- newdata[, which(names(newdata) %in% .predictors)]
    ..subset <- log(..subset)

    # If any pathlengths are 0, then we sub in the lengthkm
    ..pathlength_inf <- is.infinite(..subset$pathlength)
    ..subset$pathlength[..pathlength_inf] <- ..subset$lengthkm[..pathlength_inf]

    ..subset
}
