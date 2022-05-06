
d %>% 
  ggplot(
    aes(
      x = date_created
    )
  ) + 
  geom_density()

new_names

d %>% 
  filter(grade %in% c(6:8)) %>% 
  mutate(
    timing = factor(
      ntile(date_created, 2), 
      levels = 1:2, 
      labels = c('pre', 'post')
      )
  ) %>% 
  select(timing, date_created,  grade, kindness_regular_school) %>% 
  mutate(
    across(
      .cols = contains('kind'),
      .fns = 
        ~factor(.x,
          levels = c(
            "Disagree a lot",
            "Disagree a little",
            "Don't agree or disagree",
            "Agree a little",
            "Agree a lot"
          )
        )
    )
  ) %>% 
  drop_na() %>% 
  ggplot(
    aes(
      y = kindness_regular_school, 
      fill = timing
    )
  ) + 
  geom_histogram(
    alpha = 0.2, 
    color = 'black',
    stat = 'count', 
    position = position_dodge(width = -1)
    ) + 
  facet_wrap(vars(grade), ncol = 1)
  
  
