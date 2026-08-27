<h1 align="center">Zero Yield Command Line</h2>
<p align="center">Zero Yield except it also has a command line</p>

## Script

```luau
local env = function() return ((getgenv and getgenv()) or shared or _G) end
env()._NewPrefix = "'" -- change to the prefix you want
env()._UseBetaRelease = false -- whetever to use beta release
loadstring(game:HttpGet("https://cdn.jsdelivr.net/gh/zero-yield/zy-cmdline@refs/heads/main/source.luau"))()
```

### Images

<img src="https://github.com/Toon-arch/iy-cmdline/blob/main/images/1.png" alt="Command Line Preview">
<img src="https://github.com/Toon-arch/iy-cmdline/blob/main/images/2.png" alt="Command Line Preview">
