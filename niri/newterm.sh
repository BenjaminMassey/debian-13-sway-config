alacritty --working-directory . &
sleep 0.2
niri msg action focus-column-left
niri msg action consume-window-into-column
niri msg action set-column-display tabbed
