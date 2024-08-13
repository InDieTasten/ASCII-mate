term = {}
function term.enterRawMode()
    os.execute("/bin/stty raw")
    os.execute("/bin/stty -echo")
    os.execute("/bin/tput smcup")
end
function term.leaveRawMode()
    os.execute("/bin/tput rmcup")
    os.execute("/bin/stty echo")
    os.execute("/bin/stty sane")
end

return term
