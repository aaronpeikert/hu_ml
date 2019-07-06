gen_data_grid <- function(rset, recipes, ...){
  dots <- list(...)
  is_recipe_list <- all(map_lgl(recipes, ~"recipe" %in% class(.x)))
  if(!is_recipe_list){
    if("recipe" %in% class(recipes))recipes <- list(recipes)
    else stop("recipes is not a recipe or a list of recipes!")
  }
  if(is.null(names(recipes)))names(recipes) <- seq_along(recipes)
  data_grid <- crossing(rset, id_recipe = names(recipes))
  prep_ <- function(split, recipe, dots){
    training <- analysis(split)
    args <- list(x = recipe, training = training)
    args <- c(args, dots)
    do.call(prep, args)
  }
  data_grid <- mutate(data_grid,
                      recipes = map(id_recipe, ~recipes[[.x]]),
                      recipes = map2(splits, recipes, prep_, dots))
  data_grid
}

gen_model_grid <- function(models, grids){
  is_model_list <- all(map_lgl(models, ~"model_spec" %in% class(.x)))
  if(!is_model_list){
    if("model_spec" %in% class(models))models <- list(models)
    else stop("models is not a model or a list of models!")
  }
  is_grid_list <- all(map_lgl(grids, ~"param_grid" %in% class(.x)))
  if(!is_grid_list){
    if("param_grid" %in% class(grids))grids <- list(grids)
    else stop("grids is not a grid or a list of grids!")
  }
  if(is.null(names(models)))names(models) <- seq_along(models)
  stopifnot(length(grids) == length(models))
  models <- map2(models, grids, merge)
  split_rows <- function(x)map(seq_len(nrow(x)), ~x[.x, ])
  grids <- map(grids, split_rows)
  pmap_dfr(list(id_model = names(models),
            models = models,
            grids = grids), tibble)
}

get_args <- function(model){
  args <- map(model$args, rlang::eval_tidy)
  non_null_args <- args[!vapply(args, is.null, TRUE)]
  as_tibble(non_null_args)
}

fit_param <- function(model, recipe){
  analysis <- juice(recipe)
  formula <- as.formula(recipe)
  fit(model, formula, data = analysis)
}

assess_pred <- function(fit, split, recipe, pred_type = NULL){
  assessment <- bake(recipe, new_data = assessment(split))
  if(missingArg(pred_type)) estimate <- predict(fit, new_data = assessment)
  else estimate <- predict(fit, new_data = assessment, type = pred_type)
  formula <- as.formula(recipe)
  truth <- pull(assessment, as.character(formula)[2])
  estimate <- mutate(estimate, truth)
  estimate
}

fit_n_pred <- function(models, splits, recipes, pred_type = NULL, ...){
  model <- models
  split <- splits
  recipe <- recipes
  fit <- fit_param(model, recipe)
  predictions <- assess_pred(fit, split, recipe, pred_type)
  predictions
}

fit_params <- function(params){
  mutate(params, predictions = pmap(params, fit_n_pred))
}
