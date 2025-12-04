local map = Map("update-podkop", "Update Podkop Settings")

local s = map:section(TypedSection, "repo", "Repository Settings")
s.addremove = false
s.anonymous = false

local url = s:option(Value, "url", "URL")
url.datatype = "string"

local token = s:option(Value, "token", "Token")
token.password = true

local run = s:option(Button, "_run", "Запустить update-podkop")
run.inputstyle = "apply"
run.write = function()
    luci.http.redirect(luci.dispatcher.build_url("admin/services/update_podkop/run"))
end

return map
