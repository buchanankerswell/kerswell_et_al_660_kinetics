# Shared gutter logging for R scripts (auto-sourced with the other utils).
# Glyphs live in the 4-char gutter only; continuation lines indent 4 spaces.
#   " .. " info step | " -- " detail | " -> " artifact | " !! " warning | " XX " error
# Lines wrap at screen width (cli::console_width, else getOption("width")).

.log_width <- function() {
  w <- tryCatch(suppressWarnings(as.integer(cli::console_width())), error = function(e) NA_integer_)
  if (length(w) != 1L || is.na(w)) w <- getOption("width", 80L)
  max(w, 40L)
}

.log_emit <- function(glyph, ...) {
  msg <- paste0(..., collapse = "")
  width <- max(.log_width() - 4L, 20L)
  lines <- unlist(lapply(strsplit(msg, "\n", fixed = TRUE)[[1]], strwrap, width = width))
  if (!length(lines)) lines <- ""
  first <- paste0(" ", glyph, " ", lines[1L])
  rest <- if (length(lines) > 1L) paste0("    ", lines[-1L]) else NULL
  cat(paste0(c(first, rest), collapse = "\n"), "\n", sep = "")
}

log_info <- function(...) .log_emit("..", ...)
log_detail <- function(...) .log_emit("--", ...)
log_artifact <- function(...) .log_emit("->", ...)
log_warn <- function(...) .log_emit("!!", "Warning: ", ...)
log_error <- function(...) .log_emit("XX", "Error: ", ...)
