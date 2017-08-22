-- init sockproc by api invoke
-- @soulteary

function exists(name)
    if type(name) ~= "string" then
        return false
    end
    return os.rename(name, name) and true or false
end

function isFile(name)
    if type(name) ~= "string" then
        return false
    end
    if not exists(name) then
        return false
    end
    local f = io.open(name)
    if f then
        f:close()
        return true
    end
    return false
end

if isFile("/tmp/sock-init.lock") then
    ngx.say("already inited.")
else
    os.execute("/bin/sockexec /tmp/exec.sock &")
    os.execute("chmod +x /tmp/exec.sock")
    os.execute("chmod 777 /tmp/exec.sock")
    os.execute("touch /tmp/sock-init.lock")
    ngx.say("inited.")
end
