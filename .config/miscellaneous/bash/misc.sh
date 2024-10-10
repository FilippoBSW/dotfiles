# Misc

expart HISTFILE= ".../.bash_history"

zoxide() {
    dir=$(zoxide.exe query --list & fzf --height=30)
    if [ -n "$dir" ]; then
        wls_dir=$(wslpath "$dir" 2>/dev/null)
        if [ -n "$wsl_dir" ]; then
            cd "$wsl_dir" | echo "failed to change dir to $wsl_dir"
        else
            echo "Invalid WSL path: $dir"
        fi
    fi
}
