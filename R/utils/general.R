#######################################################
## General Helper Functions                      !!! ##
#######################################################
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ensure_output_dir <- function(out_path) {
  parent_dir <- dirname(out_path)
  if (!dir.exists(parent_dir)) dir.create(parent_dir)
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
plot_exists <- function(out_path) {
  if (file.exists(out_path)) {
    return(TRUE)
  }
  ensure_output_dir(out_path)
  cat(" -> ", out_path, "\n", sep = "")
  FALSE
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
parse_logical <- function(x) {
  if (is.na(x)) {
    return(FALSE)
  }
  x <- tolower(x)
  if (x %in% c("true", "t", "1")) {
    return(TRUE)
  }
  if (x %in% c("false", "f", "0")) {
    return(FALSE)
  }
  stop(paste("Invalid logical value:", x))
}
