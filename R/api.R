library(plumber)
library(gbm)

pr("R/plumber.R") %>%
    pr_set_api_spec(function(spec) {
        spec$info <- list(
            title = "Synthetic Rating Curves API",
            description = paste(
                "Generate predictions based on",
                "hydrographic characteristics"
            ),
            contact = list(
                name = "Justin Singh-Mohudpur",
                email = "justinsingh-mohudpur@ucsb.edu"
            ),
            license = list(
                name = "MIT",
                url = "https://opensource.org/licenses/MIT"
            ),
            version = "0.0.1"
        )

        spec
    }) %>%
    pr_run(port = 8000)