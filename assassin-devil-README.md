# DEVIL HUB / +1 Assassin Leveling presentation

Live status: the user reported that this adapter did not change the observed
Ouroboros v0.2 UI. It is not a confirmed working branding release. See
[post-auth capture](assassin-capture-README.md) for the next source-analysis step.

Run in +1 Assassin Leveling:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Razahaider51216/devil-scripthub/main/assassin-devil.lua"))()
```

The adapter detects an already open Ouroboros/OuroFlow game UI, changes visible
hub titles/invite text, and replaces recognized logos with `assets/devil-logo.png`.
The community invite is https://discord.gg/ZY7PRcVJe2, as used by Devil Hub.
The adapter panel also has its own Discord copy action.

Identified Discord/copy/open-invite buttons receive a transparent child button
whose action copies Devil Hub's invite. Other controls keep their original
callbacks. Only identified branded ScreenGuis are adapted; authentication
panels and ordinary game UI are excluded. A small observer handles new controls
inside identified windows. Window discovery stops after about 100 seconds.

If the original UI is not open, press **Run original** once and complete its
normal authentication. If the panel reports that it cannot identify the UI,
a screenshot/UI structure is needed to add exact selectors. No second launch
occurs when an existing branded window is detected.

**X** removes the adapter, disconnects its listeners, removes its action overlays
and restores properties it still owns. It does not unload the upstream script.
Logo rendering requires `writefile` and `getcustomasset`/`getsynasset`.

This is presentation applied to live Instances, not source devirtualization.
Protected callbacks, hidden URL strings and internally cached branding cannot
be guaranteed rewritten by this adapter. No HTTP/namecall/compiler/clipboard
hooks are installed, and original authorization is unchanged.

Original gameplay/loader: [Ouroboros](https://github.com/joustingmatch/Ouroboros).
Known logo selectors were checked against the existing
[OuroFlow source revision](https://raw.githubusercontent.com/joustingmatch/OuroFlow/c8251f76f74d9942114ebccb0564aa0ac196320a/Source.luau).

Compiled with Luau and passed 20 checks using mocked UI fixtures, covering UI
isolation, original gameplay callbacks, invite actions, webhook settings,
dynamic controls, logo loading and cleanup. Live branding behavior
still needs an in-game run; upstream gameplay itself was reported working by
the user.
