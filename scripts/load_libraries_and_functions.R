#' #################################
#' load libraries and set seed
#' #################################
library(tidyverse)
library(readxl)
#
library(tidybayes)
library(cmdstanr)
library(brms)
library(loo)
# library(projpred)
# library(tensorflow)
# tensorflow::set_random_seed(seed = 16)
# library(keras)
# keras::k_backend()
#
library(gt)
library(gtExtras)
#
library(ggtext)
library(ggokabeito)
library(ggh4x)
library(ggrepel)
library(gghalves)
library(patchwork)
#
library(MMWRweek)
library(EpiEstim)
library(incidence)
#
set.seed(16)


#' #################################
#' functions and formatting
#' #################################
theme_pub <- function() {
  theme_bw(base_family = "Roboto") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_line(color = "grey79", size = 0.5),
          panel.border = element_rect(color = "black", size = 1),
          axis.ticks = element_blank(),
          strip.background = element_blank(),
          strip.text = ggtext::element_markdown(color = "black"),
          axis.text.x = ggtext::element_markdown(color = "black"),
          axis.text.y = ggtext::element_markdown(color = "black"),
          axis.title.x = ggtext::element_markdown(color = "black"),
          axis.title.y = ggtext::element_markdown(color = "black"),
          legend.title = ggtext::element_markdown(color = "black"),
          legend.position = "bottom",
          legend.margin = margin(t = 2, r = 2, b = 2, l = 2, unit = "pt"),
          plot.title = ggtext::element_markdown(color = "black"),
          plot.title.position = "plot",
          plot.caption = ggtext::element_textbox_simple(size = 9,
                                                        margin = unit(x = c(10,5,5,5), units = "pt"),
                                                        padding = unit(x = c(3,2,2,3), units = "pt"),
                                                        #box.colour = "black",
                                                        #linetype = 1,
                                                        #vjust = 0,
                                                        fill = "white"
          ),
          plot.caption.position = "plot",
          plot.background = element_rect(fill = "white", color = NA, size = 1)) # make color 'black' to frame
}


theme_pub_fine <- function() {
  theme_bw(base_family = "Roboto") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.minor = element_line(color = "grey79", size = 0.25),
          panel.grid.major = element_line(color = "grey79", size = 0.75),
          panel.border = element_rect(color = "black", size = 1),
          axis.ticks = element_blank(),
          strip.background = element_blank(),
          strip.text = ggtext::element_markdown(color = "black"),
          axis.text.x = ggtext::element_markdown(color = "black"),
          axis.text.y = ggtext::element_markdown(color = "black"),
          axis.title.x = ggtext::element_markdown(color = "black"),
          axis.title.y = ggtext::element_markdown(color = "black"),
          legend.title = ggtext::element_markdown(color = "black"),
          legend.position = "bottom",
          legend.margin = margin(t = 2, r = 2, b = 2, l = 2, unit = "pt"),
          plot.title = ggtext::element_markdown(color = "black"),
          plot.title.position = "plot",
          plot.caption = ggtext::element_textbox_simple(size = 9,
                                                        margin = unit(x = c(10,5,5,5), units = "pt"),
                                                        padding = unit(x = c(3,2,2,3), units = "pt"),
                                                        #box.colour = "black",
                                                        #linetype = 1,
                                                        #vjust = 0,
                                                        fill = "white"
          ),
          plot.caption.position = "plot",
          plot.background = element_rect(fill = "white", color = NA, size = 1)) # make color 'black' to frame
}



theme_grant <- function() {
  theme_bw(base_family = "Roboto") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_line(color = "grey79", size = 0.5),
          panel.border = element_rect(color = "black", size = 1),
          axis.ticks = element_blank(),
          strip.background = element_blank(),
          strip.text = ggtext::element_markdown(color = "black"),
          axis.text.x = ggtext::element_markdown(color = "black"),
          axis.text.y = ggtext::element_markdown(color = "black"),
          axis.title.x = ggtext::element_markdown(color = "black"),
          axis.title.y = ggtext::element_markdown(color = "black"),
          legend.title = ggtext::element_markdown(color = "black"),
          legend.position = "bottom",
          legend.margin = margin(t = 2, r = 2, b = 2, l = 2, unit = "pt"),
          plot.title = ggtext::element_markdown(color = "black"),
          plot.title.position = "plot",
          plot.caption = ggtext::element_textbox_simple(size = 9,
                                                        margin = unit(x = c(10,5,5,5), units = "pt"),
                                                        padding = unit(x = c(3,2,2,3), units = "pt"),
                                                        box.colour = "black",
                                                        linetype = 1,
                                                        #vjust = 0,
                                                        fill = "white"
          ),
          plot.caption.position = "plot",
          plot.background = element_rect(fill = "white", color = "black", size = 1)) # make color 'black' to frame
}



# make labels use Roboto by default
update_geom_defaults("label_repel", 
                     list(family = "Roboto",
                          fontface = "plain"))
update_geom_defaults("label", 
                     list(family = "Roboto",
                          fontface = "plain"))

# nested_settings <- strip_nested(
#   text_x = list(element_text(family = "Roboto", 
#                              face = "plain"), NULL),
#   background_x = list(element_rect(fill = "grey92"), NULL),
#   by_layer_x = TRUE)



#' relaxed handwritten theme
theme_hand <- function() {
  theme_bw(base_family = "Homemade Apple") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_line(color = "grey79", size = 0.5),
          panel.border = element_rect(color = "black", size = 1),
          axis.ticks = element_blank(),
          strip.background = element_blank(),
          strip.text = ggtext::element_markdown(color = "black"),
          axis.text.x = ggtext::element_markdown(color = "black", size = rel(1.4)),
          axis.text.y = ggtext::element_markdown(color = "black", vjust = 0.6, size = rel(1.4)),
          axis.title.x = ggtext::element_markdown(color = "black"),
          #axis.title.y = ggtext::element_markdown(color = "black"),
          axis.title.y = ggtext::element_textbox_simple(color = "black",
                                                        orientation = "upright",
                                                        vjust = 1,
                                                        hjust = 0.5,
                                                        halign = 0,
                                                        margin = margin(t = 0, r = 0, b = 0, l = 0, unit = "pt"),
                                                        padding = margin(t = 0, r = 0, b = 0, l = -10, unit = "pt"),
                                                        width = 0.1,
          ),
          legend.title = ggtext::element_markdown(color = "black"),
          legend.position = "bottom",
          legend.margin = margin(t = 2, r = 2, b = 2, l = 2, unit = "pt"),
          plot.title = ggtext::element_markdown(color = "black"),
          plot.title.position = "plot",
          plot.caption = ggtext::element_textbox_simple(size = 9,
                                                        margin = unit(x = c(10,5,5,5), units = "pt"),
                                                        padding = unit(x = c(3,2,2,3), units = "pt"),
                                                        #box.colour = "black",
                                                        #linetype = 1,
                                                        #vjust = 0,
                                                        fill = "white"
          ),
          plot.caption.position = "plot",
          plot.background = element_rect(fill = "white", color = NA, size = 1)) # make color 'black' to frame
}


theme_freehand <- function() {
  theme_bw(base_family = "Freehand") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_line(color = "grey79", size = 0.5),
          panel.border = element_rect(color = "black", size = 1),
          axis.ticks = element_blank(),
          strip.background = element_blank(),
          strip.text = ggtext::element_markdown(color = "black"),
          axis.text.x = ggtext::element_markdown(color = "black"),
          axis.text.y = ggtext::element_markdown(color = "black", vjust = 0.6),
          axis.title.x = ggtext::element_markdown(color = "black"),
          axis.title.y = ggtext::element_markdown(color = "black"),
          legend.title = ggtext::element_markdown(color = "black"),
          legend.position = "bottom",
          legend.margin = margin(t = 2, r = 2, b = 2, l = 2, unit = "pt"),
          plot.title = ggtext::element_markdown(color = "black"),
          plot.title.position = "plot",
          plot.caption = ggtext::element_textbox_simple(size = 9,
                                                        margin = unit(x = c(10,5,5,5), units = "pt"),
                                                        padding = unit(x = c(3,2,2,3), units = "pt"),
                                                        #box.colour = "black",
                                                        #linetype = 1,
                                                        #vjust = 0,
                                                        fill = "white"
          ),
          plot.caption.position = "plot",
          plot.background = element_rect(fill = "white", color = NA, size = 1)) # make color 'black' to frame
}


theme_fasthand <- function() {
  theme_bw(base_family = "Fasthand") +
    theme(panel.background = element_rect(fill = "white"),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_line(color = "grey79", size = 0.5),
          panel.border = element_rect(color = "black", size = 1),
          axis.ticks = element_blank(),
          strip.background = element_blank(),
          strip.text = ggtext::element_markdown(color = "black"),
          axis.text.x = ggtext::element_markdown(color = "black"),
          axis.text.y = ggtext::element_markdown(color = "black", vjust = 0.6),
          axis.title.x = ggtext::element_markdown(color = "black"),
          axis.title.y = ggtext::element_markdown(color = "black"),
          legend.title = ggtext::element_markdown(color = "black"),
          legend.position = "bottom",
          legend.margin = margin(t = 2, r = 2, b = 2, l = 2, unit = "pt"),
          plot.title = ggtext::element_markdown(color = "black"),
          plot.title.position = "plot",
          plot.caption = ggtext::element_textbox_simple(size = 9,
                                                        margin = unit(x = c(10,5,5,5), units = "pt"),
                                                        padding = unit(x = c(3,2,2,3), units = "pt"),
                                                        #box.colour = "black",
                                                        #linetype = 1,
                                                        #vjust = 0,
                                                        fill = "white"
          ),
          plot.caption.position = "plot",
          plot.background = element_rect(fill = "white", color = NA, size = 1)) # make color 'black' to frame
}


#' save plots
ggsave_hand <- function(handplot, dir = "./figs/") {
  plotname = deparse(substitute(handplot))
  plotname = stringr::str_split(string = plotname, pattern = " ", simplify = TRUE)[1]
  fn = paste0(dir,plotname)
  ggsave(filename = paste0(fn,"_th.pdf"), plot = handplot, height = 6, width = 8, units = "in", device = cairo_pdf)
  ggsave(filename = paste0(fn,"_th.png"), plot = handplot, height = 6, width = 8, units = "in")
  ggsave(filename = paste0(fn,"_th.svg"), plot = handplot, height = 6, width = 8, units = "in")
  #return(plotname)
}

ggsave_pub <- function(pubplot, dir = "./figs/") {
  plotname = deparse(substitute(pubplot))
  plotname = stringr::str_split(string = plotname, pattern = " ", simplify = TRUE)[1]
  fn = paste0(dir,plotname)
  ggsave(filename = paste0(fn,"_tp.pdf"), plot = pubplot, height = 6, width = 8, units = "in", device = cairo_pdf)
  ggsave(filename = paste0(fn,"_tp.png"), plot = pubplot, height = 6, width = 8, units = "in")
  ggsave(filename = paste0(fn,"_tp.svg"), plot = pubplot, height = 6, width = 8, units = "in")
  #return(plotname)
}

ggsave_grant <- function(grantplot, dir = "./figs/") {
  plotname = deparse(substitute(grantplot))
  plotname = stringr::str_split(string = plotname, pattern = " ", simplify = TRUE)[1]
  fn = paste0(dir,plotname)
  ggsave(filename = paste0(fn,"_tg.pdf"), plot = grantplot, height = 6, width = 8, units = "in", device = cairo_pdf)
  ggsave(filename = paste0(fn,"_tg.png"), plot = grantplot, height = 6, width = 8, units = "in")
  ggsave(filename = paste0(fn,"_tg.svg"), plot = grantplot, height = 6, width = 8, units = "in")
  #return(plotname)
}





