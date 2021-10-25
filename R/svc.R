#' Make a Seats-Votes Curve
#'
#' @param plans redist_plans object
#' @param dvs
#' @param swing
#'
#' @return ggplot2 object
#' @export
#'
#' @examples
#' library(redist)
#' data(iowa)
#' ia <- redist_map(iowa, existing_plan = cd_2010, pop_tol = 0.01)
#' plans <- redist_smc(ia, 100, silent = TRUE)
#' plans <- plans %>% mutate(dvs = group_frac(ia, dem_08, dem_08 + rep_08))
#' svc(plans, dvs)
#'
svc <- function(plans, dvs, swing = svc_unif) {
  dvs <- rlang::enquo(dvs)

  sv <- swing(plans, !!dvs)

  ref <- plans %>%
    redist::subset_ref() %>%
    pull(draw) %>%
    unique()

  sv %>%
    filter(!draw %in% ref) %>%
    ggplot(aes(x = votes, y = seats, group = draw)) +
    geom_line(alpha = 0.05) +
    theme_bw() +
    geom_line(data = sv %>% filter(draw %in% ref), aes(color = draw))

}
