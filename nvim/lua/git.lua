-- Whick key config

local wk = require("which-key")

wk.register({
				h = {
								name = "Git Hunks",
								p = "Preview",
								s = "Stage",
								u = "Undo",
				},
}, {prefix= "<leader>"}) 
