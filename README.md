# hammerspoon-config

個人用の [Hammerspoon](https://www.hammerspoon.org/) 設定。ウィンドウ操作向け。

## 入れる

1. Hammerspoon を入れる
2. Spoon を置く:

```bash
mkdir -p ~/.hammerspoon/Spoons
# WindowHalfsAndThirds
# https://www.hammerspoon.org/Spoons/WindowHalfsAndThirds.html
```

3. このリポの Lua を置く:

```bash
cp init.lua split_screen.lua ~/.hammerspoon/
```

4. Reload Config する

## 含まれるもの

- `init.lua` — Option+Tab で同一アプリのウィンドウ巡回など
- `split_screen.lua` — WindowHalfsAndThirds 連携の分割ショートカット
