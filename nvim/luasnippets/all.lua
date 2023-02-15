---@diagnostic disable: undefined-global

return {
  s({ trig = "ymd", name = "Current date", dscr = "Insert the current date" }, {
    p(os.date, "%Y-%m-%d"),
  }),
}
