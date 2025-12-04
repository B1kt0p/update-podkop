module("luci.controller.update_podkop", package.seeall)

function index()
    -- /admin/services/update_podkop
    entry({"admin", "services", "update_podkop"},
        cbi("update_podkop/settings"), "Update Podkop", 20).dependent = false

    -- /admin/services/update_podkop/run
    entry({"admin", "services", "update_podkop", "run"},
        call("action_run"), nil).leaf = true
end

function action_run()
    luci.http.prepare_content("text/plain")
    local out = luci.sys.exec("update-podkop 2>&1")
    luci.http.write(out)
end
