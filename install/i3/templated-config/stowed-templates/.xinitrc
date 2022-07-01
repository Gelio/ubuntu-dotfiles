xrdb -merge ~/.Xresources
export GDK_SCALE={{ (ds "config").dpi }}
export GDK_DPI_SCALE={{ math.Div 1 (ds "config").dpi }}
exec i3
