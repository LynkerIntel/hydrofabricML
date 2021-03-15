# Modified rstudio/plumber Dockerfile for Geospatial libraries :)
FROM rocker/geospatial:latest
LABEL maintainer="justin@justinsingh.me"

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  git-core \
  libssl-dev \
  libcurl4-gnutls-dev \
  curl \
  libsodium-dev \
  libxml2-dev

# Install remotes and gbm packages
RUN install2.r remotes gbm

# Install plumber and setup image to use
RUN Rscript -e "remotes::install_github('rstudio/plumber@master')"
EXPOSE 8000
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(rev(commandArgs())[1]); args <- list(host = '0.0.0.0', port = 8000); if (packageVersion('plumber') >= '1.0.0') { pr$setDocs(TRUE) } else { args$swagger <- TRUE }; do.call(pr$run, args)"]

# Install additional dependencies
RUN Rscript -e "remotes::install_github('mikejohnson51/nhdplusTools')"
#! Above needs to be changed to 'usgs-r/nhdplusTools' once pull request is merged.
RUN Rscript -e "remotes::install_github('mikejohnson51/AOI')"
RUN Rscript -e "remotes::install_github('mikejohnson51/FloodMapping')"

# Download VAA
RUN Rscript -e "nhdplusTools::download_vaa()"

# Copy SRC API Code to /app/
COPY . /app/src-api
CMD ["/app/src-api/R/api.R"]