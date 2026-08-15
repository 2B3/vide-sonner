local process = require("@lune/process")
local task = require("@lune/task")

task.spawn(process.exec, "rojo", {
	"sourcemap",
	"./default.project.json",
	"-o",
	"sourcemap.json",
	"--watch",
}, {
	stdio = "inherit",
})

task.spawn(process.exec, "rojo", {
	"serve",
}, {
	stdio = "inherit",
})
