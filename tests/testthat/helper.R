# Create 6x6 point grid with 1m distance between points
test_make_sp = function() {
  coordinates = expand.grid(315172:315177, 5690670:5690675)
  names(coordinates) = c("x", "y")
  coordinates
}

# Create regression task
test_make_regr = function(coords_as_features = FALSE) {
  data = test_make_sp()
  data$p_1 = c(rep("A", 18), rep("B", 18))
  data$response = rnorm(36)

  TaskRegrST$new(
    id = "sp_regression",
    backend = data,
    coordinate_names = c("x", "y"),
    crs = "+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs",
    target = "response",
    coords_as_features = coords_as_features)
}

# Create twoclass task
test_make_twoclass = function(group = FALSE, coords_as_features = FALSE, features = "numeric") {

  data = test_make_sp()
  if ("numeric" %in% features) {
    data$p_1 = c(rnorm(18, 0), rnorm(18, 10))
  }
  if ("factor" %in% features) {
    data$p_2 = as.factor(c(rep("lvl_1", 18), rep("lvl_2", 18)))
  }
  data$response = as.factor(c(rep("A", 18), rep("B", 18)))

  if (group) {
    data$group = rep_len(letters[1:10], 36)
  }

  task = TaskClassifST$new(
    id = "sp_twoclass",
    backend = data,
    coordinate_names = c("x", "y"),
    crs = "+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs",
    target = "response",
    positive = "A",
    coords_as_features = coords_as_features)

  if (group) {
    task$col_roles$group = "group"
  }
  task
}

# Create multiclass task
test_make_multiclass = function() {
  data = test_make_sp()
  data$p_1 = rnorm(36)
  data$response = as.factor(c(rep("A", 9), rep("B", 9), rep("C", 9), rep("D", 9)))

  TaskClassifST$new(
    id = "sp_multiclass",
    backend = data,
    coordinate_names = c("x", "y"),
    crs = "+proj=utm +zone=33 +datum=WGS84 +units=m +no_defs",
    target = "response",
    coords_as_features = FALSE)
}
