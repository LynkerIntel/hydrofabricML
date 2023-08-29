#' Predict roughness values using GBM model.
#' @param newdata (`data.frame`)\cr
#'        Must contain the correct predictor columns, i.e.
#'        "pathlength", "arbolatesu", "lengthkm", "areasqkm", "slope"
#' @return `data.frame` with the column `$.pred` containing the predictions.
#' @importFrom stats predict
#' @importFrom gbm predict.gbm
#' @importFrom caret predict.train
#' @export
hr_predict <- function(newdata, ..., override_path = NULL) {
    ..subset <- .preprocess(newdata)

    .assert_predictors(..subset)
    .assert_valid(..subset)

    if (!.is_model_loaded()) {
        .load_model(override_path)
    }

    data.frame(
        .pred = exp(predict(
            object  = .get_model(),
            newdata = ..subset
        ))
    )
}

#' Augment data with GBM-based roughness predictions.
#' @param newdata (`data.frame`)\cr
#'        Must contain the correct predictor columns, i.e.
#'        "pathlength", "arbolatesu", "lengthkm", "areasqkm", "slope"
#' @return `newdata` with `$.pred` column containing the predictions.
#' @export
hr_augment <- function(newdata, ..., override_path = NULL) {
    cbind(newdata, hr_predict(newdata, ..., override_path = override_path))
}

#' @keywords internal
.preprocess <- function(newdata) {
    # Get only valid columns
    ..subset <- newdata[, which(names(newdata) %in% .predictors)]
    ..subset <- log(..subset)
    ..subset
}
