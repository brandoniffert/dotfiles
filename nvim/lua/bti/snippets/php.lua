---@diagnostic disable: undefined-global

return {
  s({ trig = "dv", dscr = "die var dump" }, fmt("die(var_dump(${}));", { i(1, "value") })),
}
