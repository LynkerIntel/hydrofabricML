FROM rstudio/plumber
MAINTAINER Justin Singh-Mohudpur <justinsingh-mohudpur@ucsb.edu>
COPY . /app/src-api
RUN R -e "install.packages('gbm', dependencies = TRUE)"
CMD ["/app/src-api/R/plumber.R"]