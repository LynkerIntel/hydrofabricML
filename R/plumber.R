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
        object = readRDS("../data/gbm/roughness.rds")$finalModel,
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
        object = readRDS("../data/gbm/freq.rds")$finalModel,
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
        object = readRDS("../data/gbm/freq-y.rds")$finalModel,
        newdata = newdata
    )

    exp(sim)
}