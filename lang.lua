local ga = gajosframework
ga.lang = {}; local lang = ga.lang

function lang.getLanguageData()
    for item in io.enumdir(_DIR .. 'app/lang') do
        local name, extension = item:match('([^/]+)%.([^%.]+)$')

        if name and extension == 'txt' then
            local file = io.open(_DIR .. 'app/lang/' .. name .. '.txt')

            local currentlanguage = {}
            local currentsection = 'default'
            local currentline = 1

            for line in file:lines() do
                if not currentlanguage[currentsection] then
                    currentlanguage[currentsection] = {}
                end

                if line ~= '' then
                    if line:sub(1, 1) == ':' then
                        currentsection = line:sub(2)
                        currentline = 1
                    else
                        if line:sub(1, 1) == '.' then
                            local new_str = line:sub(2)
                            local find_dot, last_pos = new_str:find('. ')
                            find_dot, last_pos = find_dot, last_pos + 1
                            local new_currentline = tonumber(line:sub(2, find_dot))

                            currentlanguage[currentsection][new_currentline] = line:sub(last_pos)
                        else
                            currentlanguage[currentsection][currentline] = line
                            currentline = currentline + 1
                        end
                    end
                end
            end

            file:close()

            lang[name] = currentlanguage
        end
    end
end

function lang.lang(user, section, line, ...)
    local _lang = lang[user.current_lang]
    local str = _lang and _lang[section] and _lang[section][line] or false

    if str then
        for index, arg in ipairs({...}) do
            str = str:gsub('$' .. index, arg)
        end
    else
        str = 'Language error(' .. tostring(user.current_lang) .. '), section: ' .. tostring(section) .. ', line: ' .. tostring(line)
        log(str, 'error', 'debug')
    end

    return str
end

-- init --
lang.getLanguageData()
