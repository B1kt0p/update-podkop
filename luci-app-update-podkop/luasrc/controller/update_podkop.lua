module("luci.controller.update_podkop", package.seeall)

function index()
    entry({"admin","services","update_podkop"}, call("page_index"), "Update Podkop", 20).dependent=false
end

function page_index()
    local uci = require("uci").cursor()
    local lhttp = require("luci.http")

    if lhttp.formvalue("save") then
        local url = lhttp.formvalue("url") or ""
        local token = lhttp.formvalue("token") or ""
        uci:set("update-podkop","settings","url",url)
        uci:set("update-podkop","settings","token",token)
        uci:commit("update-podkop")
    end

    local url = uci:get("update-podkop","settings","url") or ""
    local token = uci:get("update-podkop","settings","token") or ""

    lhttp.prepare_content("text/html")
    lhttp.write([[
      <h2>Update Podkop</h2>
      <form method="post">
        URL: <input type="text" name="url" value="]]..url..[["><br>
        Token: <input type="password" name="token" value="]]..token..[["><br>
        <input type="submit" name="save" value="Сохранить"><br><br>
        <input type="submit" name="run" value="Запустить update-podkop">
      </form>
    ]])

    if lhttp.formvalue("run") then
        local out = io.popen("update-podkop 2>&1"):read("*a")
        lhttp.write("<pre>"..out.."</pre>")
    end
end