Config.UploadMethod = 'discord' -- discord | fivemanage | custom

-- MAY BE YOU'RE LOOKING FOR THE config/logs/logs.lua FILE AND NOT THIS ONE
-- DON'T EDIT BELOW THIS LINE IF YOU DON'T KNOW WHAT YOU'RE DOING PLEASE

Config.Fields = {
    ['discord'] = 'files[]',
    ['fivemanage'] = 'image',
    ['custom'] = ''
}

function GetCustomUrlFromResponse(resp)
    -- Thats the function that will return the URL of the image when the upload method is set to "custom"
end