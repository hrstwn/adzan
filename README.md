# adzan
Adzan is a prayer times list app that shows you when to do your shalat.

## Dependencies
```bash
gtk+-3.0
libsoup-2.4
json-glib-1.0
meson
vala
```


## Building
```bash
meson build && cd build
meson configure -Dprefix=/usr
sudo ninja install
```

## Running
```bash
./src/com.github.hrstwn.adzan
```
