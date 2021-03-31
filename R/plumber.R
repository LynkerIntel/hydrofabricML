gbm_dir <- "/app/src-api/data/gbm/"

#* Return roughness prediction
#* @param pathlength:[dbl]
#* @param arbolatesu:[dbl]
#* @param lengthkm:[dbl]
#* @param areasqkm:[dbl]
#* @param slope:[dbl]
#* @response default roughness value prediction
#* @post /roughness
function(pathlength, arbolatesu, lengthkm, areasqkm, slope) {
    newdata <- tibble::tibble(
        pathlength = log(as.numeric(pathlength)),
        arbolatesu = log(as.numeric(arbolatesu)),
        lengthkm   = log(as.numeric(lengthkm)),
        areasqkm   = log(as.numeric(areasqkm)),
        slope      = log(as.numeric(slope))
    )

    sim <- gbm::predict.gbm(
        object = readRDS(paste0(gbm_dir, "roughness.rds"))$finalModel,
        newdata = newdata
    )

    exp(sim)
}

#* Return freq-based prediction
#* @param pathlength:[dbl]
#* @param arbolatesu:[dbl]
#* @param lengthkm:[dbl]
#* @param areasqkm:[dbl]
#* @param slope:[dbl]
#* @response default freq coefficient prediction
#* @post /freq
function(pathlength, arbolatesu, lengthkm, areasqkm, slope) {
    newdata <- tibble::tibble(
        pathlength = log(as.numeric(pathlength)),
        arbolatesu = log(as.numeric(arbolatesu)),
        lengthkm   = log(as.numeric(lengthkm)),
        areasqkm   = log(as.numeric(areasqkm)),
        slope      = log(as.numeric(slope))
    )

    sim <- gbm::predict.gbm(
        object = readRDS(paste0(gbm_dir, "freq.rds"))$finalModel,
        newdata = newdata
    )

    exp(sim)
}

#* Return freq(y)-based prediction
#* @param pathlength:[dbl]
#* @param arbolatesu:[dbl]
#* @param lengthkm:[dbl]
#* @param areasqkm:[dbl]
#* @param slope:[dbl]
#* @response default freq(y) coefficient prediction
#* @post /freq-y
function(pathlength, arbolatesu, lengthkm, areasqkm, slope) {
    newdata <- tibble::tibble(
        pathlength = log(as.numeric(pathlength)),
        arbolatesu = log(as.numeric(arbolatesu)),
        lengthkm   = log(as.numeric(lengthkm)),
        areasqkm   = log(as.numeric(areasqkm)),
        slope      = log(as.numeric(slope))
    )

    sim <- gbm::predict.gbm(
        object = readRDS(paste0(gbm_dir, "freq-y.rds"))$finalModel,
        newdata = newdata
    )

    exp(sim)
}

#* Generate Synthetic Rating Curve for a given bounding box
#* @param xmin:[chr] West longitude for bounding box.
#* @param xmax:[chr] East longitude for bounding box.
#* @param ymin:[chr] South latitude for bounding box.
#* @param ymax:[chr] North latitude for bounding box.
#* @param stages:[dbl] stages used to generate SRC.
#* @param slope_scale:[dbl] Ratio of vertical units to horizonal.
#*        See [gdaldem](https://gdal.org/programs/gdaldem.html).
#* @post /src
function(xmin, xmax, ymin, ymax, stages = 0:20, slope_scale = 111120) {
    # From bbox around CONUS
    if (!all(xmin > -124.72584,
             xmax < -66.94989,
             ymax < 49.38436,
             ymin > 24.49813)) {

        rlang::abort("Service implemented only for CONUS.")

    }

    res <- matrix(
        c(ymax, xmin,
          ymax, xmax,
          ymin, xmax,
          ymin, xmin,
          ymax, xmin),
        ncol = 2,
        byrow = TRUE
    )

    aoi    <- sf::st_polygon(list(res))
    comids <- FloodMapping::find_comids(aoi)

    if (length(comids) > 25) {
        rlang::abort(paste0(
            "Area is too big, contains > 25 COMIDs.\n",
            "Please subset your COMIDs and perform batch calls"
        ))
    }

    FloodMapping::get_src(
        comids = comids,
        stage = stages,
        slope_scale = slope_scale,
        progress = FALSE)
}