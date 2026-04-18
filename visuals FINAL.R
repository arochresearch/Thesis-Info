library(ggplot2)
library(dplyr)
library(tidyr)

# ── Color palettes ───────────────────────────────────────────────
model_colors <- c("Claude" = "#4A7CC7", "Gemini" = "#9B8EC4", "GPT-4o" = "#7A6652")
construct_colors <- c(
  "Dependence Framing"       = "#4A7CC7",
  "Boundary Setting"         = "#9B8EC4",
  "Resource Diversity"       = "#8C8C8C",
  "Secrecy vs. Transparency" = "#7A6652"
)
construct_order <- names(construct_colors)

# ── Helpers ──────────────────────────────────────────────────────
clean_models <- function(df) {
  df %>% mutate(Model = recode(Model,
                               "claude-sonnet-4-6"       = "Claude",
                               "gemini/gemini-2.5-flash" = "Gemini",
                               "gpt-4o"                  = "GPT-4o"
  ))
}

clean_constructs <- function(df, col = "Construct") {
  df %>% mutate(!!col := factor(recode(.data[[col]],
                                       "1a Dependence Framing"      = "Dependence Framing",
                                       "1b Boundary Setting"        = "Boundary Setting",
                                       "2a Resource Diversity"      = "Resource Diversity",
                                       "2b Secrecy vs Transparency" = "Secrecy vs. Transparency"
  ), levels = construct_order))
}

base_theme <- theme_minimal(base_size = 12) +
  theme(
    plot.title       = element_blank(),
    legend.position  = "bottom",
    strip.text       = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

# ── 1. LINE CHARTS: Turn 1 vs Turn 3, faceted by construct ───────
turn_data <- df %>%
  filter(`Turn #` %in% c(1, 3)) %>%
  clean_models() %>%
  group_by(Model, `Turn #`) %>%
  summarise(
    `Dependence Framing`       = mean(H_1a, na.rm = TRUE),
    `Boundary Setting`         = mean(H_1b, na.rm = TRUE),
    `Resource Diversity`       = mean(H_2a, na.rm = TRUE),
    `Secrecy vs. Transparency` = mean(H_2b, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  pivot_longer(cols = all_of(construct_order), names_to = "Construct", values_to = "Mean Score") %>%
  mutate(Construct = factor(Construct, levels = construct_order))

ggplot(turn_data, aes(x = factor(`Turn #`), y = `Mean Score`, group = Model, color = Model)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 3) +
  facet_wrap(~ Construct, nrow = 2) +
  scale_y_continuous(limits = c(0, 2), breaks = c(0, 0.5, 1, 1.5, 2)) +
  scale_x_discrete(labels = c("1" = "Turn 1", "3" = "Turn 3")) +
  scale_color_manual(values = model_colors) +
  labs(x = NULL, y = "Mean Human Score (0–2)", color = NULL) +
  base_theme

ggsave("~/Desktop/fig_line_turn_degradation.png", width = 7, height = 5, dpi = 300)

# ── 2. HEATMAP: model × construct ────────────────────────────────
heat_data <- df %>%
  clean_models() %>%
  group_by(Model) %>%
  summarise(
    `Dependence Framing`       = mean(H_1a, na.rm = TRUE),
    `Boundary Setting`         = mean(H_1b, na.rm = TRUE),
    `Resource Diversity`       = mean(H_2a, na.rm = TRUE),
    `Secrecy vs. Transparency` = mean(H_2b, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  pivot_longer(cols = all_of(construct_order), names_to = "Construct", values_to = "Mean Score") %>%
  mutate(Construct = factor(Construct, levels = construct_order))

ggplot(heat_data, aes(x = Construct, y = Model, fill = `Mean Score`)) +
  geom_tile(color = "white", linewidth = 0.5) +
  geom_text(aes(label = round(`Mean Score`, 2)), color = "white", size = 4, fontface = "bold") +
  scale_fill_gradient(low = "#9B8EC4", high = "#4A7CC7", limits = c(0, 2)) +
  labs(x = NULL, y = NULL, fill = "Mean Score") +
  theme_minimal(base_size = 12) +
  theme(
    plot.title       = element_blank(),
    panel.grid       = element_blank(),
    axis.text.x      = element_text(angle = 20, hjust = 1)
  )

ggsave("~/Desktop/fig_heatmap_model_construct.png", width = 6, height = 3, dpi = 300)

# ── 3. BAR CHART: scenario × construct, faceted by model ─────────
scenario_data <- df %>%
  clean_models() %>%
  group_by(Model, `Scenario ID`) %>%
  summarise(
    `Dependence Framing`       = mean(H_1a, na.rm = TRUE),
    `Boundary Setting`         = mean(H_1b, na.rm = TRUE),
    `Resource Diversity`       = mean(H_2a, na.rm = TRUE),
    `Secrecy vs. Transparency` = mean(H_2b, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  pivot_longer(cols = all_of(construct_order), names_to = "Construct", values_to = "Mean Score") %>%
  mutate(Construct = factor(Construct, levels = construct_order))

ggplot(scenario_data, aes(x = `Scenario ID`, y = `Mean Score`, fill = Construct)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ Model, nrow = 1) +
  scale_y_continuous(limits = c(0, 2), breaks = c(0, 0.5, 1, 1.5, 2)) +
  scale_fill_manual(values = construct_colors) +
  labs(x = "Scenario", y = "Mean Human Score (0–2)", fill = NULL) +
  base_theme +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

ggsave("~/Desktop/fig_bar_scenario_model.png", width = 9, height = 5, dpi = 300)

# ── 4. MODEL MEANS BAR CHART: mean score by model and construct ──
model_means <- df %>%
  clean_models() %>%
  group_by(Model) %>%
  summarise(
    `Dependence Framing`       = mean(H_1a, na.rm = TRUE),
    `Boundary Setting`         = mean(H_1b, na.rm = TRUE),
    `Resource Diversity`       = mean(H_2a, na.rm = TRUE),
    `Secrecy vs. Transparency` = mean(H_2b, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  pivot_longer(cols = all_of(construct_order), names_to = "Construct", values_to = "Mean Score") %>%
  mutate(Construct = factor(Construct, levels = construct_order))

ggplot(model_means, aes(x = Construct, y = `Mean Score`, fill = Model)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_y_continuous(limits = c(0, 2), breaks = c(0, 0.5, 1, 1.5, 2)) +
  scale_fill_manual(values = model_colors) +
  labs(x = NULL, y = "Mean Human Score (0–2)", fill = NULL) +
  base_theme +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

ggsave("~/Desktop/fig_bar_model_means.png", width = 7, height = 5, dpi = 300)

# ── Colors for construct line chart ──────────────────────────────
construct_colors_alt <- c(
  "Dependence Framing"       = "#DA7756",
  "Boundary Setting"         = "#4A90D9",
  "Resource Diversity"       = "#5BAD6F",
  "Secrecy vs. Transparency" = "#E8A838"
)

# ── LINE CHART: Turn-level by model, construct as color ──────────
turn_data <- df %>%
  clean_models() %>%
  group_by(Model, `Turn #`) %>%
  summarise(
    `Dependence Framing`       = mean(H_1a, na.rm = TRUE),
    `Boundary Setting`         = mean(H_1b, na.rm = TRUE),
    `Resource Diversity`       = mean(H_2a, na.rm = TRUE),
    `Secrecy vs. Transparency` = mean(H_2b, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  pivot_longer(cols = all_of(construct_order), names_to = "Construct", values_to = "Mean Score") %>%
  mutate(Construct = factor(Construct, levels = construct_order))

ggplot(turn_data, aes(x = `Turn #`, y = `Mean Score`, color = Construct, group = Construct)) +
  geom_line(linewidth = 0.9) +
  geom_point(size = 3) +
  facet_wrap(~ Model, nrow = 1) +
  scale_y_continuous(limits = c(0, 2), breaks = c(0, 0.5, 1, 1.5, 2)) +
  scale_x_continuous(breaks = c(1, 2, 3)) +
  scale_color_manual(values = construct_colors_alt) +
  labs(x = "Turn", y = "Mean Human Score (0–2)", color = NULL) +
  base_theme

ggsave("/Users/YOURUSERNAME/Desktop/fig_line_turn_by_model.png", width = 10, height = 4, dpi = 150, bg = "white")