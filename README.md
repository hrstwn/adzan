```
⚠️ Still a work in progress. Doesn't have basic functionality yet. 
Location is still hard coded.
```

![](data/screenshots/applet.png)
![](data/screenshots/expanded.png)

# adzan
Adzan is a prayer times app that shows you when to do your shalat.

## Dependencies
```bash
gtk+-3.0
libsoup-2.4
json-glib-1.0
libnotify
granite
glib-2.0
meson
vala
```

to install libsoup use
```
sudo apt install libsoup2.4-dev
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
