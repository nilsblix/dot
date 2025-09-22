{ lib ? null }:

let
  # Describe each command once. PUA codes are auto-assigned sequentially
  # starting at U+E001 based on the order of this list.
  spec = [
    { key = "Key1"; mods = "Command"; tmux = "select-window -t 1"; }
    { key = "Key2"; mods = "Command"; tmux = "select-window -t 2"; }
    { key = "Key3"; mods = "Command"; tmux = "select-window -t 3"; }
    { key = "Key4"; mods = "Command"; tmux = "select-window -t 4"; }
    { key = "Key5"; mods = "Command"; tmux = "select-window -t 5"; }
    { key = "Key6"; mods = "Command"; tmux = "select-window -t 6"; }
    { key = "Key7"; mods = "Command"; tmux = "select-window -t 7"; }
    { key = "Key8"; mods = "Command"; tmux = "select-window -t 8"; }
    { key = "Key9"; mods = "Command"; tmux = "select-window -t 9"; }

    { key = "w";          mods = "Command"; tmux = "kill-window"; }
    { key = "t";          mods = "Command"; tmux = "new-window -c \"#{pane_current_path}\""; }
    { key = "h";          mods = "Command"; tmux = "select-pane -L"; }
    { key = "j";          mods = "Command"; tmux = "select-pane -D"; }
    { key = "k";          mods = "Command"; tmux = "select-pane -U"; }
    { key = "l";          mods = "Command"; tmux = "select-pane -R"; }
  ];

  # Compute PUA codepoint for each entry: U+E000 + index, starting at E001.
  toUpper = s: builtins.replaceStrings ["a" "b" "c" "d" "e" "f"] ["A" "B" "C" "D" "E" "F"] s;
  pad4 = s: let n = builtins.stringLength s; in builtins.substring 0 (4 - n) "0000" + s;
  mkCode = i: let hex = toUpper (lib.toHexString (57344 + i)); in pad4 hex; # 0xE000 == 57344

  mappings = lib.imap1 (i: m: m // { code = mkCode i; }) spec;

  # Derived Alacritty key bindings and tmux lines.
  alacrittyBindings = map (m: {
    key = m.key;
    mods = m.mods;
    chars = "\\u" + m.code;
  }) mappings;

  tmuxLines = map (m: ''bind -n "\u${m.code}" ${m.tmux}'') mappings;
  tmuxExtra = (builtins.concatStringsSep "\n" tmuxLines) + "\n";
in {
  inherit mappings alacrittyBindings tmuxExtra;
}
