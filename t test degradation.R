turn_paired <- df %>%
  filter(`Turn #` %in% c(1, 3)) %>%
  rename(Turn = `Turn #`) %>%
  pivot_longer(cols = c(H_1a, H_1b, H_2a, H_2b),
               names_to = "Construct",
               values_to = "Score")

turn_ttest <- turn_paired %>%
  group_by(Construct) %>%
  pairwise_t_test(Score ~ Turn, paired = TRUE, p.adjust.method = "bonferroni")

print(turn_ttest)

# average 
df %>%
  filter(`Turn #` %in% c(1, 3)) %>%
  group_by(`Turn #`) %>%
  summarise(
    mean_1a = mean(H_1a, na.rm = TRUE),
    mean_1b = mean(H_1b, na.rm = TRUE),
    mean_2a = mean(H_2a, na.rm = TRUE),
    mean_2b = mean(H_2b, na.rm = TRUE)
  )

#visual 

turn_summary <- df %>%
  filter(`Turn #` %in% c(1, 3)) %>%
  group_by(Model, `Turn #`) %>%
  summarise(
    mean_1a = mean(H_1a, na.rm = TRUE),
    mean_1b = mean(H_1b, na.rm = TRUE),
    mean_2a = mean(H_2a, na.rm = TRUE),
    mean_2b = mean(H_2b, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  pivot_longer(cols = starts_with("mean_"),
               names_to = "Construct",
               values_to = "Mean Score") %>%
  mutate(Construct = recode(Construct,
                            "mean_1a" = "1a Dependence Framing",
                            "mean_1b" = "1b Boundary Setting",
                            "mean_2a" = "2a Resource Diversity",
                            "mean_2b" = "2b Secrecy vs Transparency"
  ))

ggplot(turn_summary, aes(x = factor(`Turn #`), y = `Mean Score`, 
                         group = Model, color = Model)) +
  geom_line() +
  geom_point(size = 3) +
  facet_wrap(~ Construct) +
  scale_y_continuous(limits = c(0, 2)) +
  labs(title = "Score Degradation: Turn 1 vs Turn 3",
       x = "Turn", y = "Mean Human Score (0–2)") +
  theme_minimal()