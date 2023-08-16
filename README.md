# GBM-based Roughness Prediction

This repository contains an R package providing programmatic access to the GBM model described in the in-review paper:

> Johnson, J.M., Eyelade D., Clarke K.C, Singh-Mohudpur, J. (2021) *“Characterizing Reach-level Empirical Roughness Along the National Hydrography Network: Developing DEM-based Synthetic Rating Curves.”*

For more information, see: [nhd-roughness](https://github.com/mikejohnson51/nhd-roughness).

## Installation
```R
# One of the below will install the development version

# Using `remotes`:
remotes::install_github("LynkerIntel/roughness-api")

# Or, using `pak`:
pak::pkg_install("LynkerIntel/roughness-api")
```

## Usage

```R
# Attaching the package will load the model into memory
# and prompt the user if the model is not in the local cache
library(hydrofab.roughness)

my_data <- data.frame(
    pathlength = 2611.030, 
    arbolatesu = 284.351, 
    lengthkm =  2.43, 
    areasqkm = 4.3308, 
    slope = 0.00074773
)

# This will also load the model if `library` was not called above.
prediction <- hydrofab.roughness::hr_predict(my_data)
#> Using 40000 trees...

prediction
#>       .pred
#> 1 0.2793853

# Alternatively, we can augment our inital data with the prediction values
hydrofab.roughness::hr_augment(my_data)
#> Using 40000 trees...
#> 
#>   pathlength arbolatesu lengthkm areasqkm      slope     .pred
#> 1    2611.03    284.351     2.43   4.3308 0.00074773 0.2793853
```
