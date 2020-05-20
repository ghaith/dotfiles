#Configure scaling settings
#export GDK_DPI_SCALE=1.5

export PATH="$HOME/.cargo/bin:$HOME/.gem/bin:$HOME/.gem/ruby/2.6.0/bin:$PATH"

if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi
