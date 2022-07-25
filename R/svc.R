#' Make a Seats-Votes Curve
#'
#' @param plans redist_plans object
#' @param dvs <[`tidy-select`][dplyr::dplyr_tidy_select]> column in `plans`
#' @param swing function to swing voteshares with
#'
#' @return ggplot2 object
#' @export
#'
#' @examples
#' library(redist)
#' data(iowa)
#' ia <- redist_map(iowa, existing_plan = cd_2010, pop_tol = 0.01)
#' plans <- redist_smc(ia, 100, silent = TRUE)
#' plans <- plans %>% dplyr::mutate(dvs = group_frac(ia, dem_08, dem_08 + rep_08))
#' svc(plans, dvs)
#'
svc <- function(plans, dvs, swing = svc_unif) {
  dvs <- rlang::enquo(dvs)

  sv <- swing(plans, !!dvs)

  ref <- plans %>%
    redist::subset_ref() %>%
    dplyr::pull(.data$draw) %>%
    unique()

  sv %>%
    dplyr::filter(!.data$draw %in% ref) %>%
    ggplot2::ggplot(ggplot2::aes(x = .data$votes, y = .data$seats, group = .data$draw)) +
    ggplot2::geom_line(alpha = 0.05) +
    ggplot2::geom_line(data = dplyr::filter(sv, .data$draw %in% ref),
                       ggplot2::aes(color = .data$draw)) +
    ggplot2::theme_bw()
}
