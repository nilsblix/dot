{ pkgs, ... }: let
    status-pos = if pkgs.stdenv.isDarwin then "top" else "bottom";
in {
    programs.tmux = {
        enable = true;
        keyMode = "vi";
        extraConfig = ''
            set -g default-terminal "xterm-256color"
            set -as terminal-overrides ",xterm-256color:Tc"

            unbind r
            bind r source-file ~/.config/tmux/tmux.conf\; display-message "Config reloaded..."

            unbind t
            bind t run-shell "tmux neww ~/.local/bin/sessionizer.sh"

            unbind C-Space
            set -g prefix C-Space
            bind C-Space send-prefix

            unbind E
            bind E kill-window

            unbind p
            bind p switchc -l

            unbind v
            bind v copy-mode

            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R

            bind -T copy-mode-vi Escape send-keys -X cancel
            bind -T copy-mode Escape send-keys -X cancel

            set -g mouse on
            set -sg escape-time 0
            set -g base-index 1
            set -g detach-on-destroy off
            set-option -g status-interval 1

            set-option -g status-left-length 100
            set-option -g status-right-length 60

            set -g status-justify absolute-centre
            set-option -g status-position ${status-pos}

            # colors
            set -g message-style "bg=color88,fg=white"
            set -g mode-style "bg=color88,fg=white"

            set -g pane-border-style "fg=#063540"
            set -g pane-active-border-style "fg=#268bd3"

            set -g @FG_COLOR "#707575"
            set -g @BG_COLOR "#343434"

            set-option -g status-style 'bg=#{@BG_COLOR},fg=#{@FG_COLOR}'
            set -g window-status-current-style 'fg=#ab4242'

            set -g status-left ' #S '
            set -g status-right ' #h '
        '';
    };
}
