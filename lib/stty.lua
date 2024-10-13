Stty = {}

function Stty.enableRawMode()
    os.execute("/bin/stty raw")
end

function Stty.disableRawMode()
    os.execute("/bin/stty sane")
end

function Stty.disableEcho()
    os.execute("/bin/stty -echo")
end

function Stty.enableEcho()
    os.execute("/bin/stty echo")
end

return Stty
