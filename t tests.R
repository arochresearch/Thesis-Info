# T Tests 

library(dplyr)
library(tidyr)
library(rstatix)


df_long <- df %>%
  pivot_longer(cols = c(H_1a, H_1b, H_2a, H_2b),
               names_to = "Construct",
               values_to = "Score")

# Pairwise t-tests by model (per construct)

model_pairwise <- df_long %>%
  group_by(Construct) %>%
  pairwise_t_test(Score ~ Model, p.adjust.method = "bonferroni")

print(model_pairwise)

# Pairwise t-tests by scenario (per construct)

scenario_pairwise <- df_long %>%
  group_by(Construct) %>%
  pairwise_t_test(Score ~ Scenario, p.adjust.method = "bonferroni")

print(scenario_pairwise)

print(scenario_pairwise, n = 24) 

# Visualization of significant differences

ggplot(df_long, aes(x = Model, y = Score, fill = Model)) +
  geom_boxplot() +
  facet_wrap(~ Construct) +
  scale_y_continuous(limits = c(0, 2)) +
  labs(title = "Score Distribution by Model and Construct",
       y = "Human Score (0–2)") +
  theme_minimal()

