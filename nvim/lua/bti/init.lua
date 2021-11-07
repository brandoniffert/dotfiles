local autoload = require'bti.autoload'

local bti = autoload('bti')

-- Using a real global here to make sure anything stashed in here (and in `bti.g`) survives even after the last reference to it goes away.
_G.bti = bti

return bti
