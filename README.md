# ASCII-mate
A CLI tool with mouse support for drawing ascii art and animations

## Prerequisites
- /bin/stty (exists in pretty much all posix systems)
- /bin/sleep (exists in pretty much all posix systems)
- luajit or lua

## Usage
```bash
git clone git@github.com:InDieTasten/ASCII-mate.git
cd ASCII-mate
luajit main.lua
```

## Planned features
- [x] Canvas
- [x] Pencil tool
- [ ] Saving and loading ascii art
- [ ] Character palette
- [ ] Eraser tool
- [ ] Line tool
- [ ] Rectangle tool
- [ ] Circle tool
- [ ] Text tool
- [ ] Selection
- [ ] Copy and paste
- [ ] Move selection
- [ ] Fill tool
- [ ] Animation sequencer
- [ ] Animation playback

## Resources and references used to create this project
- https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
- https://www.xfree86.org/current/ctlseqs.html
