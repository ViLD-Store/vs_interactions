Citizen.CreateThread(function()
    local resourceName = GetCurrentResourceName()
    
    local function printVILDHeader()
        print([[
            
██╗   ██╗██╗██╗     ██████╗ 
██║   ██║██║██║     ██╔══██╗
██║   ██║██║██║     ██║  ██║
╚██╗ ██╔╝██║██║     ██║  ██║
 ╚████╔╝ ██║███████╗██████╔╝
  ╚═══╝  ╚═╝╚══════╝╚═════╝]])
    end

    -- Function to check version
    local function checkVersion()
        PerformHttpRequest("https://api.vildstore.com/api/getversion/"..GetCurrentResourceName(), function(err, responseText, headers)

            -- Parse the JSON response
            local responseData = json.decode(responseText)

            if not responseData then
                print("Error: Unable to parse version information.")
                return
            end

            local curVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

            if not curVersion then
                print("Error: 'version' file not found in the resource root.")
                return
            end

            -- Display the version information
            printVILDHeader()

            -- Check and compare versions
            if curVersion ~= responseData.version and curVersion < responseData.version then
                print(GetCurrentResourceName() .. " is outdated!")
                print("Latest version: " .. responseData.version)
                print("Current version: " .. curVersion)
                print("Update notes: " .. responseData.update)
            else
                print(GetCurrentResourceName() .. " is up to date. Have fun!")
            end
        end, "GET")
    end

    -- Call the checkVersion function to start the process
    checkVersion()
end)