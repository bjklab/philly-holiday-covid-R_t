source("./scripts/load_libraries_and_functions.R")

#' #################################################################################################
#' from EpiEstim package demo: https://cran.r-project.org/web/packages/EpiEstim/vignettes/demo.html
#' #################################################################################################
data(Flu2009)
head(Flu2009$incidence)
head(Flu2009$si_data)
plot(as.incidence(Flu2009$incidence$I, dates = Flu2009$incidence$dates))

# parametric SI to estimate R
res_parametric_si <- estimate_R(Flu2009$incidence, 
                                method="parametric_si",
                                config = make_config(list(
                                  mean_si = 2.6, 
                                  std_si = 1.5))
)

plot(res_parametric_si, legend = FALSE)

# non-parametric SI distribution to estimate R
res_non_parametric_si <- estimate_R(Flu2009$incidence, 
                                    method="non_parametric_si",
                                    config = make_config(list(
                                      si_distr = Flu2009$si_distr))
)

plot(res_non_parametric_si, legend = FALSE)




#' #################################################################################################
#' application to PDPH data: https://github.com/ambientpointcorp/covid19-philadelphia/tree/master/cases_by_date
#'  - compare data available 2021-12-22 to data available 2021-01-03
#' #################################################################################################

# read and format incidence data
old_data <- read_csv("./data/PHL/covid_cases_by_date_2021-12-22.csv.gz")
new_data <- read_csv("./data/PHL/covid_cases_by_date_2022-01-03.csv.gz")

old_data %>%
  rename(dates = collection_date, I = positive) %>%
  select(dates, I) %>%
  arrange(dates) %>%
  filter(!is.na(I)) %>%
  identity() -> old_I
old_I


new_data %>%
  rename(dates = collection_date, I = positive) %>%
  select(dates, I) %>%
  arrange(dates) %>%
  filter(!is.na(I)) %>%
  identity() -> new_I
new_I


# compare estimated R with old vs new incidence data, parametric (pre-omicron serial interval: SI mean 5.2, SD 0.8)
# pre-omicron serial interval: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7448781/
# default weekly sliding interval

old_res_par_si <- estimate_R(filter(old_I, dates >= as.Date("2021-12-01")),
                             method="parametric_si",
                             config = make_config(list(
                               mean_si = 5.2, 
                               std_si = 0.8))
)

plot(old_res_par_si, legend = FALSE)


new_res_par_si <- estimate_R(filter(new_I, dates >= as.Date("2021-12-01")),
                             method="parametric_si",
                             config = make_config(list(
                               mean_si = 5.2, 
                               std_si = 0.8))
)

plot(new_res_par_si, legend = FALSE)



# compare estimated R with old vs new incidence data, parametric (rough omicron serial interval: SI mean 2.2, SD 0.8)
# rough omicron serial interval: https://www.medrxiv.org/content/10.1101/2021.12.25.21268301v1
# default weekly sliding interval

omi_old_res_par_si <- estimate_R(filter(old_I, dates >= as.Date("2021-12-01")),
                             method="parametric_si",
                             config = make_config(list(
                               mean_si = 2.2, 
                               std_si = 0.8))
)

plot(omi_old_res_par_si, legend = FALSE)


omi_new_res_par_si <- estimate_R(filter(new_I, dates >= as.Date("2021-12-01")),
                             method="parametric_si",
                             config = make_config(list(
                               mean_si = 2.2, 
                               std_si = 0.8))
)

plot(omi_new_res_par_si, legend = FALSE)


# combine plots
omi_old_res_par_si$R %>%
  as_tibble() %>%
  janitor::clean_names() %>%
  mutate(date = omi_old_res_par_si$dates[t_end]) %>%
  mutate(incid = omi_old_res_par_si$I[t_end]) %>%
  select(date, incid, median_r, quantile_0_975_r, quantile_0_025_r) %>%
  mutate(data_source = "Data Available 2021-12-22") %>%
  identity() -> omi_old_R_est
omi_old_R_est


omi_new_res_par_si$R %>%
  as_tibble() %>%
  janitor::clean_names() %>%
  mutate(date = omi_new_res_par_si$dates[t_end]) %>%
  mutate(incid = omi_new_res_par_si$I[t_end]) %>%
  select(date, incid, median_r, quantile_0_975_r, quantile_0_025_r) %>%
  mutate(data_source = "Data Available 2022-01-03") %>%
  identity() -> omi_new_R_est
omi_new_R_est


bind_rows(omi_old_R_est, omi_new_R_est) %>%
  identity() %>%
  ggplot(data = .) +
  geom_rect(xmax = as.Date("2021-12-21"), xmin = as.Date("2021-12-14"), ymin = 0.5, ymax = 2, color = NA, fill = "grey90", alpha = 0.1) +
  geom_rect(xmax = as.Date("2022-01-03"), xmin = as.Date("2021-12-27"), ymin = 0.5, ymax = 2, color = NA, fill = "grey90", alpha = 0.1) +
  geom_hline(yintercept = 1, color = "black", linetype = 2) +
  annotate(geom = "text", x = as.Date("2021-12-18"), y = 1.5, color = "#E69F00", label = "Backfill Period", hjust = 0.6) +
  annotate(geom = "text", x = as.Date("2022-01-01"), y = 1.5, color = "#56B4E9", label = "Backfill Period", hjust = 0.6) +
  geom_line(aes(x = date, y = median_r, color = data_source, group = data_source)) +
  geom_ribbon(aes(x = date, ymin = quantile_0_025_r, ymax = quantile_0_975_r, fill = data_source, group = data_source), alpha = 0.6) +
  #geom_lineribbon(aes(x = date, y = median_r, ymin = quantile_0_025_r, ymax = quantile_0_975_r, color = data_source, group = data_source, fill = data_source), alpha = 0.6) +
  scale_x_date(date_labels = "%d %b<br>%Y", expand = c(0,0)) +
  scale_color_okabe_ito() +
  scale_fill_okabe_ito() + 
  labs(y = "Estimated R<sub>t</sub>",
       x = "",
       caption = "Incidence data from github.com/ambientpointcorp/covid19-philadelphia | R<sub>t</sub> via EpiEstim package <br> Analysis by @bjk_lab | Code available at github.com/bjklab/philly-holiday-covid-R_t",
       title = "COVID-19 in Philadelphia, Pennsylvania",
       fill = "",
       color = "") +
  theme_pub() +
  theme(axis.text.x = ggtext::element_markdown(hjust = 1)) -> p_R_est_comparison
p_R_est_comparison



bind_rows(omi_old_R_est, omi_new_R_est) %>%
  identity() %>%
  ggplot(data = .) +
  geom_rect(xmax = as.Date("2021-12-21"), xmin = as.Date("2021-12-14"), ymin = 0, ymax = 10000, color = NA, fill = "grey90", alpha = 0.1) +
  geom_rect(xmax = as.Date("2022-01-03"), xmin = as.Date("2021-12-27"), ymin = 0, ymax = 10000, color = NA, fill = "grey90", alpha = 0.1) +
  annotate(geom = "text", x = as.Date("2021-12-18"), y = 4000, color = "#E69F00", label = "Backfill Period", hjust = 0.6) +
  annotate(geom = "text", x = as.Date("2022-01-01"), y = 4000, color = "#56B4E9", label = "Backfill Period", hjust = 0.6) +
  geom_line(aes(x = date, y = incid, color = data_source, group = data_source), size = 2, alpha = 0.8) +
  scale_x_date(date_labels = "%d %b<br>%Y", expand = c(0,0)) +
  scale_color_okabe_ito() +
  scale_fill_okabe_ito() + 
  labs(y = "Daily Case Incidence<br>(observed cases/day)",
       x = "",
       title = "COVID-19 in Philadelphia, Pennsylvania",
       caption = "Incidence data from github.com/ambientpointcorp/covid19-philadelphia | R<sub>t</sub> via EpiEstim package <br> Analysis by @bjk_lab | Code available at github.com/bjklab/philly-holiday-covid-R_t",
       fill = "",
       color = "") +
  theme_pub() +
  theme(axis.text.x = ggtext::element_markdown(hjust = 1)) -> p_incid_comparison
p_incid_comparison



(p_incid_comparison + theme(legend.position = "none") + labs(caption = "")) /
  (p_R_est_comparison + labs(title = "")) -> p_combined
p_combined


ggsave_pub(pubplot = p_combined)

  


