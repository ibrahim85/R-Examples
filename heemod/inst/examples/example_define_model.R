mat <- define_matrix(
  state_names = c("s1", "s2"),
  1 / c, 1 - 1/ c,
  0, 1
)

s1 <- define_state(
  cost = 234,
  utility = 1
  )
s2 <- define_state(
  cost = 421,
  utility = .5
  )

define_model(
  transition_matrix = mat,
  s1 = s1,
  s2 = s2
)
