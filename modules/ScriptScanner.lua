print("Script started")

local ScriptScanner = {}

-- Mock LocalScript object for testing
local LocalScript = {}
LocalScript.new = function(script)
    local instance = {}
    instance.script = script
    return instance
end

-- Mocking getGc function to return a table of functions
local function getGc()
    return {
        function() return { script = game:GetService("Workspace").Script1 } end,
        function() return { script = game:GetService("Workspace").Script2 } end
        -- Add more mock functions here if needed
    }
end

-- Mocking isXClosure function
local function isXClosure(func)
    -- Simulate returning false for all functions
    return false
end

-- Mocking getScriptClosure function
local function getScriptClosure(script)
    -- Simulate always returning true
    return true
end

-- Function to scan for LocalScripts
local function scan(query)
    print("Starting scan with query:", query)
    local scripts = {}
    query = query or ""

    local gcResult = getGc()
    if not gcResult then
        print("Error: getGc returned nil")
        return scripts
    end

    for _, v in pairs(gcResult) do
        if type(v) == "function" and not isXClosure(v) then
            local env = getfenv(v)
            if env then
                local script = env.script
                if script and typeof(script) == "Instance" and script:IsA("LocalScript") and
                   script.Name:lower():find(query) and getScriptClosure(script) then
                    scripts[script] = LocalScript.new(script)
                    print("Added script to results:", script.Name)
                end
            end
        end
    end

    print("Finished scan with scripts found:", #scripts)
    return scripts
end

-- Define requiredMethods table
local requiredMethods = {
    ["getGc"] = true,
    ["getSenv"] = true,  -- Mock or define getSenv if needed
    ["getProtos"] = true,  -- Mock or define getProtos if needed
    ["getConstants"] = true,  -- Mock or define getConstants if needed
    ["getScriptClosure"] = true,
    ["isXClosure"] = true
}

-- Assign methods to ScriptScanner
ScriptScanner.RequiredMethods = requiredMethods
ScriptScanner.Scan = scan

print("Script completed")

return ScriptScanner
