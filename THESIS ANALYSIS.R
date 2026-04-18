# Mean human scores by model per construct 

library(dplyr)

df %>%
  group_by(Model) %>%
  summarise(
    mean_1a = mean(H_1a, na.rm = TRUE),
    mean_1b = mean(H_1b, na.rm = TRUE),
    mean_2a = mean(H_2a, na.rm = TRUE),
    mean_2b = mean(H_2b, na.rm = TRUE)
  )

# Mean scores by scenario 

models <- unique(df$Model)

for (m in models) {
  cat("\n---", m, "---\n")
  df %>%
    filter(Model == m) %>%
    group_by(`Scenario ID`) %>%
    summarise(
      mean_1a = mean(H_1a, na.rm = TRUE),
      mean_1b = mean(H_1b, na.rm = TRUE),
      mean_2a = mean(H_2a, na.rm = TRUE),
      mean_2b = mean(H_2b, na.rm = TRUE)
    ) %>%
    print()
}

#collapsed mean by scenario averages 

df %>%
  group_by(Scenario) %>%
  summarise(
    mean_1a = mean(H_1a, na.rm = TRUE),
    mean_1b = mean(H_1b, na.rm = TRUE),
    mean_2a = mean(H_2a, na.rm = TRUE),
    mean_2b = mean(H_2b, na.rm = TRUE)
  )

# Mean by turn number 

for (m in models) {
  cat("\n---", m, "---\n")
  df %>%
    filter(Model == m) %>%
    group_by(`Turn #`) %>%
    summarise(
      mean_1a = mean(H_1a, na.rm = TRUE),
      mean_1b = mean(H_1b, na.rm = TRUE),
      mean_2a = mean(H_2a, na.rm = TRUE),
      mean_2b = mean(H_2b, na.rm = TRUE)
    ) %>%
    print()
}

# Turn 1 vs Turn 3 collapsed across models
df %>%
  filter(`Turn #` %in% c(1, 3)) %>%
  group_by(`Turn #`) %>%
  summarise(
    mean_1a = mean(H_1a, na.rm = TRUE),
    mean_1b = mean(H_1b, na.rm = TRUE),
    mean_2a = mean(H_2a, na.rm = TRUE),
    mean_2b = mean(H_2b, na.rm = TRUE)
  )


# mean by turn number AND scenarios 

for (m in models) {
  cat("\n---", m, "---\n")
  df %>%
    filter(Model == m) %>%
    group_by(`Scenario ID`, `Turn #`) %>%
    summarise(
      mean_1a = mean(H_1a, na.rm = TRUE),
      mean_1b = mean(H_1b, na.rm = TRUE),
      mean_2a = mean(H_2a, na.rm = TRUE),
      mean_2b = mean(H_2b, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    print()
}

# looking at LLM v human scoring 

for (m in models) {
  cat("\n---", m, "---\n")
  df %>%
    filter(Model == m) %>%
    summarise(
      H_1a = mean(H_1a, na.rm = TRUE),
      LLM_1a = mean(LLM_1a, na.rm = TRUE),
      H_1b = mean(H_1b, na.rm = TRUE),
      LLM_1b = mean(LLM_1b, na.rm = TRUE),
      H_2a = mean(H_2a, na.rm = TRUE),
      LLM_2a = mean(LLM_2a, na.rm = TRUE),
      H_2b = mean(H_2b, na.rm = TRUE),
      LLM_2b = mean(LLM_2b, na.rm = TRUE)
    ) %>%
    print()
}