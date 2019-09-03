#' @title Spatial Block Cross Validation Resampling
#'
#' @format [R6::R6Class] inheriting from [Resampling].
#' @import mlr3
#'
#' @description
#' Spatial Block Cross validation implemented by the `blockCV` package.
#'
#' @section Fields:
#' See [Resampling].
#'
#' @section Methods:
#' See [Resampling].
#'
#' @references
#' Valavi R, Elith J, Lahoz-Monfort JJ, Guillera-Arroita G. blockCV: An r package for generating spatially or environmentally separated folds for k-fold cross-validation of species distribution models. Methods Ecol Evol. 2019; 10:225–232. https://doi.org/10.1111/2041-210X.13107
#'
#' @export
#' @examples
#' \dontrun{
#' library(mlr3)
#' task <- tsk("ecuador")
#'
#' # Instantiate Resampling
#' rcv <- rsmp("spcv-block")
#' rcv$param_set$values <- list(folds = 4)
#' rcv$instantiate(task)
#'
#' # Individual sets:
#' rcv$train_set(1)
#' rcv$test_set(1)
#' intersect(rcv$train_set(1), rcv$test_set(1))
#'
#' # Internal storage:
#' rcv$instance
#' }
ResamplingSpCVBlock <- R6Class("ResamplingSpCVBlock",
  inherit = mlr3::Resampling,
  public = list(
    initialize = function(id = "spcv-block", param_vals = list(folds = 10L)) {
      super$initialize(
        id = id,
        param_set = ParamSet$new(params = list(
          ParamUty$new("stratify", default = NULL),
          ParamInt$new("folds", lower = 1L, tags = "required"),
          ParamInt$new("rows", lower = 1L, default = 2),
          ParamInt$new("cols", lower = 1L, default = 2),
          ParamInt$new("range", lower = 1L),
          ParamFct$new("selection", levels = c("random", "systematic", "checkerboard"), default = "random")

        )),
        param_vals = param_vals
      )
    },
    instantiate = function(task) {

      assert_task(task)

      # Check combination
      if (!is.null(self$param_set$values$range) & (!is.null(self$param_set$values$rows) | !is.null(self$param_set$values$cols))) {
        warning("Cols and rows are ignored. Range is used to generated blocks.")
      }

      # Set values to default if missing
      if (is.null(self$param_set$values$rows) & is.null(self$param_set$values$range)) {
        self$param_set$values$rows = self$param_set$default[["rows"]]
      }
      if (is.null(self$param_set$values$cols) & is.null(self$param_set$values$range)) {
        self$param_set$values$cols = self$param_set$default[["cols"]]
      }
      if (is.null(self$param_set$selection)) {
        self$param_set$values$selection = self$param_set$default[["selection"]]
      }

      groups <- task$groups
      stratify <- self$param_set$values$stratify

      if (length(stratify) == 0L || isFALSE(stratify)) {
        if (is.null(groups)) {
          instance <- private$.sample(task$row_ids, task$coordinates())
        } else {
          stopf("Grouping is not supported for spatial resampling methods.", call. = FALSE)
        }
      } else {
        if (!is.null(groups)) {
          stopf("Grouping is not supported for spatial resampling methods", call. = FALSE)
        }
        stopf("Stratification is not supported for spatial resampling methods.", call. = FALSE)
      }

      self$instance <- instance
      self$task_hash <- task$hash
      invisible(self)
    }
  ),

  active = list(
    iters = function() {
      self$param_set$values$folds
    }
  ),

  private = list(
    .sample = function(ids, coords) {
      points <- sf::st_as_sf(coords, coords = c("x", "y"))

      # Suppress print message, warning crs and package load
      capture.output(inds <- suppressMessages(suppressWarnings(blockCV::spatialBlock(
        speciesData = points,
        theRange = self$param_set$values$range,
        rows = self$param_set$values$rows,
        cols = self$param_set$values$cols,
        k = self$param_set$values$folds,
        selection = self$param_set$values$selection,
        showBlocks = FALSE,
        progress = FALSE))))

      data.table(
        row_id = ids,
        fold = inds$foldID,
        key = "fold"
      )
    },

    .get_train = function(i) {
      self$instance[!list(i), "row_id", on = "fold"][[1L]]
    },

    .get_test = function(i) {
      self$instance[list(i), "row_id", on = "fold"][[1L]]
    },

    .combine = function(instances) {
      rbindlist(instances, use.names = TRUE)
    },

    deep_clone = function(name, value) {
      if (name == "instance") copy(value) else value
    }
  )
)