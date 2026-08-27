<h1 align="center">Zero Yield Command Line</h1>
<p align="center">Zero Yield except it also has a command line</p>

## Script

```luau
local env = function() return ((getgenv and getgenv()) or shared or _G) end
env()._NewPrefix = "'" -- change to the prefix you want
env()._UseBetaRelease = false -- whether to use beta release
loadstring(game:HttpGet("https://cdn.jsdelivr.net/gh/zero-yield/zy-cmdline@refs/heads/main/source.luau"))()
```

### Images

<img src="https://github.com/zero-yield/zy-cmdline/blob/main/images/1.png" alt="Command Line Preview">
<img src="https://github.com/zero-yield/zy-cmdline/blob/main/images/2.png" alt="Command Line Preview">

## Development

### Prerequisites

This project uses [Rokit](https://github.com/rojo-rbx/rokit) for tool management. Install it first, then run:

```sh
rokit install
```

This sets up:

- **[StyLua](https://github.com/JohnnyMorganz/StyLua)** — Lua/Luau formatter
- **[selene](https://github.com/Kampfkarren/selene)** — Lua/Luau linter

### Pre-commit

This project uses [pre-commit](https://pre-commit.com/) to enforce formatting, linting, and conventional commits on every commit. Install the hooks after cloning:

```sh
pre-commit install --install-hooks
```

The hooks run automatically on `git commit`:

- **stylua** — formats Luau files
- **selene** — lints Luau files
- **commitlint** — validates commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)

### Formatting

```sh
stylua source.luau
```

### Linting

```sh
selene source.luau
```
