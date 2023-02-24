---@diagnostic disable: undefined-global

return {
  s({ trig = "log", dscr = "console.log" }, fmt("console.log({})", { i(1, "value") })),
}
