local uci = require("uci")
local http = require("luci.http")
local util = require("luci.util")
local sys = require("luci.sys")

module("luci.controller.update_podkop", package.seeall)

function index()
    entry({"admin", "services", "update_podkop"}, call("page_index"), _("Update Podkop"), 20).dependent = false
end

function page_index()
    local cursor = uci.cursor()
    
    if http.formvalue("save") then
        local url = http.formvalue("url") or ""
        local token = http.formvalue("token") or ""
        
        cursor:set("update-podkop", "settings", "url", url)
        cursor:set("update-podkop", "settings", "token", token)
        cursor:commit("update-podkop")
    end

    local url = cursor:get("update-podkop", "settings", "url") or ""
    local token = cursor:get("update-podkop", "settings", "token") or ""

    http.prepare_content("text/html")
    http.write(string.format([[
<!DOCTYPE html>
<html>
<head><title>Update Podkop</title></head>
<body>
  <h2>Update Podkop</h2>
  <form method="post">
    <label>URL: <input type="text" name="url" value="%s" size="50"></label><br>
    <label>Token: <input type="password" name="token" value="%s" size="50"></label><br><br>
    <input type="submit" name="save" value="Сохранить">
    <input type="submit" name="run" value="Запустить">
  </form>
]], util.pcdata(url), util.pcdata(token)))

    if http.formvalue("run") then
        local result = sys.exec("update-podkop 2>&1")
        http.write("<h3>Результат:</h3><pre>" .. util.pcdata(result) .. "</pre>")
    end
    
    http.write("</body></html>")
end