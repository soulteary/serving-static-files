local exec = require'resty.exec'
local prog = exec.new('/tmp/exec.sock')

local res, err = prog('env')

-- res = { stdout = "Linux\n", stderr = nil, exitcode = 0, termsig = nil }
-- err = nil

ngx.print(res.stdout)

