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
lua main.lua
```

### Editing files

Creating or editing a file called `cat.ascii`:
```bash
lua main.lua cat.ascii
```

## Controls
- `Q` to quit
- `Ctrl` + `S` to save


## Demo
![Demo](docs/media/demo-v1.gif)

## Resources and references used to create this project
- https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
- https://www.xfree86.org/current/ctlseqs.html

## GitHub Codespaces Development

You can use GitHub Codespaces to develop this project. The dev container configuration includes the following preinstalled tools:

- lua
- luajit
- luarocks
- busted

To get started, simply open the repository in a GitHub Codespace.
