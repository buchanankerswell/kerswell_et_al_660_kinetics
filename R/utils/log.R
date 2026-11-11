# Shared gutter logging for R scripts (auto-sourced with the other utils).
# Glyphs live in the 4-char gutter only; continuation lines indent 4 spaces.
#   " .. " info step | " -- " detail | " -> " artifact | " !! " warning | " XX " error | " xx " deletion
# Lines wrap at screen width (cli::console_width, else getOption("width")).
# Colors (muted gutter, cyan steps, green artifacts, yellow warnings, red
# errors) rely on cli, which strips them when piped or NO_COLOR is set.
# Lines wrap before styling, so widths stay exact either way.

.log_width <- function() {
  cols <- suppressWarnings(as.integer(Sys.getenv("COLUMNS", unset = NA)))
  if (length(cols) == 1L && !is.na(cols) && cols > 0) {
    return(max(cols, 40L))
  }
  # stdout is often piped (e.g. make | tee), so ask the controlling
  # terminal directly for the real screen width (no shell involved).
  tty <- suppressWarnings(tryCatch(
    system2("stty", "size", stdin = "/dev/tty", stdout = TRUE, stderr = FALSE),
    error = function(e) ""
  ))
  if (!length(tty)) tty <- ""
  n <- suppressWarnings(as.integer(strsplit(tty, " ", fixed = TRUE)[[1L]][2L]))
  if (length(n) == 1L && !is.na(n) && n > 0) {
    return(max(n, 40L))
  }
  w <- tryCatch(suppressWarnings(as.integer(cli::console_width())), error = function(e) NA_integer_)
  if (length(w) != 1L || is.na(w)) w <- getOption("width", 80L)
  max(w, 40L)
}

.log_emit <- function(glyph, ..., .glyph_style = cli::col_br_black, .msg_style = identity) {
  msg <- paste0(..., collapse = "")
  width <- max(.log_width() - 4L, 20L)
  lines <- unlist(lapply(strsplit(msg, "\n", fixed = TRUE)[[1]], strwrap, width = width))
  if (!length(lines)) lines <- ""
  first <- paste0(" ", .glyph_style(glyph), " ", .msg_style(lines[1L]))
  rest <- if (length(lines) > 1L) paste0("    ", lines[-1L]) else NULL
  cat(paste0(c(first, rest), collapse = "\n"), "\n", sep = "")
}

.log_relpath <- function(path) {
  root <- Sys.getenv("PROJECT_ROOT", unset = "")
  if (nzchar(root) && startsWith(path, root)) {
    sub(paste0("^", root, "/?"), "", path)
  } else {
    path
  }
}

log_info <- function(...) .log_emit("..", ..., .msg_style = cli::col_cyan)
log_detail <- function(...) .log_emit("--", ...)
log_artifact <- function(...) .log_emit("->", .log_relpath(paste0(..., collapse = "")), .msg_style = cli::col_green)
log_warn <- function(...) .log_emit("!!", "Warning: ", ..., .glyph_style = cli::col_yellow, .msg_style = cli::col_yellow)
log_error <- function(...) .log_emit("XX", "Error: ", ..., .glyph_style = cli::col_red, .msg_style = cli::col_red)
log_delete <- function(...) .log_emit("xx", ...)
