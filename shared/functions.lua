Locales = {}

function debug(s)
    if Config.debug then 
        print(string.format("^0[^5DEBUG^0] %s", s))
    end
end

function info(s)
    print(string.format("^0[^3INFO^0] %s", s))
end

function error(s)
    print(string.format("^0[^1ERROR^0] ^1%s^0", s))
end

-- lang
function _(str, ...)
	if Locales[Config.lang] ~= nil then
		if Locales[Config.lang][str] ~= nil then
			return string.format(Locales[Config.lang][str], ...)
		else
			return 'Translation [' .. Config.lang .. '][' .. str .. '] does not exist'
		end
	else
		return 'Locale [' .. Config.lang .. '] does not exist'
	end
end

function _U(str, ...) 
	return tostring(_(str, ...):gsub("^%l", string.upper))
end

-- utilities
function printTable(t)
    local printTable_cache = {}
    local function sub_printTable( t, indent )
        if ( printTable_cache[tostring(t)] ) then
            print( indent .. "*" .. tostring(t) )
        else
            printTable_cache[tostring(t)] = true
            if ( type( t ) == "table" ) then
                for pos,val in pairs( t ) do
                    if ( type(val) == "table" ) then
                        print( indent .. "[" .. pos .. "] => " .. tostring( t ).. " {" )
                        sub_printTable( val, indent .. string.rep( " ", string.len(pos)+8 ) )
                        print( indent .. string.rep( " ", string.len(pos)+6 ) .. "}" )
                    elseif ( type(val) == "string" ) then
                        print( indent .. "[" .. pos .. '] => "' .. val .. '"' )
                    else
                        print( indent .. "[" .. pos .. "] => " .. tostring(val) )
                    end
                end
            else
                print( indent..tostring(t) )
            end
        end
    end
 
    if ( type(t) == "table" ) then
        print( tostring(t) .. " {" )
        sub_printTable( t, "  " )
        print( "}" )
    else
        sub_printTable( t, "  " )
    end
end