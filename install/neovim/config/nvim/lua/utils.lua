local M = {}

---Returns a callback that executes the function discarding the parameters.
---Useful for discarding user command arguments.
function M.execute_function_without_args(fn)
	return function()
		return fn()
	end
end

return M
