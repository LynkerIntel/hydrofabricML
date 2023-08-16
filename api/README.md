# SRC API

This repository contains the [`plumber`](https://www.rplumber.io) code for
roughness prediction and SRC generation based on the GBM model from the
in-review paper:

> Johnson, J.M., Eyelade D., Clarke K.C, Singh-Mohudpur, J. (2021) *“Characterizing Reach-level Empirical Roughness Along the National Hydrography Network: Developing DEM-based Synthetic Rating Curves.”*

For more information, see: [nhd-roughness](https://github.com/mikejohnson51/nhd-roughness).

### Documentation

Documentation for this REST API service can be found [here](https://src-api.justinsingh.me/__docs__/)

### Example

Calling the API to generate a roughness value using `curl`:

```bash
curl --data "pathlength=2611.030&arbolatesu=284.351&lengthkm=2.434&areasqkm=4.3308&slope=0.00074773" "https://src-api.justinsingh.me/roughness"
#> [0.2772]%
```

Calling the API using `httr` in R:

```r
httr::content(httr::POST( 
    url = "https://src-api.justinsingh.me/roughness", 
    query = list(pathlength = 2611.030, 
                 arbolatesu = 284.351, 
                 lengthkm =  2.43, 
                 areasqkm = 4.3308, 
                 slope = 0.00074773)
))
#> [1] 0.2794
```
