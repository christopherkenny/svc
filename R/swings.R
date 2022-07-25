svc_unif <- function(plans, dvs) {
  dvs <- rlang::enquo(dvs)
  #dvs <- if (rlang::is_quosure(dvs)) dvs else rlang::enquo(dvs)
  plans %>%
    dplyr::as_tibble() %>%
    dplyr::group_by(.data$draw) %>%
    dplyr::group_modify(~.x %>% dplyr::pull(!!dvs) %>% swing_unif())
}


# swing helpers ----

swing_unif <- function(dvs) {
  swings <- seq(-1, 1, by = 0.0025)
  votes <- vapply(swings, function(x){
    mean(dvs - x)
  }, 0)
  seats <- vapply(swings, function(x){
    mean(dvs - x > 0.5)
  }, 0)
  seats <- seats[votes >=0 & votes <= 1]
  votes <- votes[votes >=0 & votes <= 1]
  tibble::tibble(seats = seats, votes = votes)
}
