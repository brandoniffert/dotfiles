---@diagnostic disable: undefined-global

return {
  s({ trig = "cl", dscr = "console.log" }, fmt("console.log({})", { i(1, "value") })),
}
