# i3 config

i3 and related desktop tools' configuration depends on the DPI.

For 4k 27 inch monitors that I use at home, using them at normal DPI is not
possible. The font is too small. Them are suited to be used at a resolution of
1440p or 4k scaled up to an equivalent of 1440p.

I am using a laptop. I sometimes need to work with regular DPI (e.g. when
working only using my laptop screen - regular DPI should use less battery). I
need to support both regular DPI (for use outside my home) and HiDPI
configurations (at home) and be able to conveniently switch between them.

This all leads to having to modify X server settings before it is started. The
configuration depends on what type of setup I am using (HiDPI or regular DPI).
Using GDM is not convenient, because I would first open i3 with the old
settings, run some commands to change the configuration, and have to restart i3.

A better way is to start i3 from the command line. I
[disabled systemd's `graphical.target` and use `multi-user.target`](https://www.cyberciti.biz/faq/switch-boot-target-to-text-gui-in-systemd-linux/)
so I can change the configuration before starting i3. This has the added benefit
of not running GDM in the background (`nvidia-smi` showed 2 Xorg processes when
I used GDM to start i3).

The process of starting i3 is as follows:

1. Generate [the config files](./templated-config/stowed-templates/) using
   [`generate-config.sh`](./templated-config/generate-config.sh)

   This generates the config files (using
   [gomplate](https://github.com/hairyhenderson/gomplate)) and
   [stows](https://www.gnu.org/software/stow/) them automatically.

2. Start X server and i3 (using `startx` which runs
   [`.xinitrc`](./templated-config/stowed-templates/.xinitrc)).

3. Change the monitor layout (if necessary)

   This can happen automatically using
   [autorandr](https://github.com/phillipberndt/autorandr) or manually via a
   script (like [this one](./stowed/.screenlayout/home-4k/init-layout.sh)).

For convenience, steps 1 and 2 are combined into `start.sh` scripts. See
[.screenlayout/](./stowed/.screenlayout/) for more information.

## Installation

```sh
./install.sh
```

This should install most applications required for i3 to work. You will have to
do a few more steps on top of that:

- configure the theme using
  [`lxappearance`](https://github.com/lxde/lxappearance)
- configure the wallpaper using [`feh`](https://feh.finalrewind.org/)
- configure the lockscreen using
  [`betterlockscreen`](https://github.com/betterlockscreen/betterlockscreen)

It is recommended to disable `graphical.target` and start i3 manually from the
command line:

```sh
./disable-graphical-target.sh
```

## Starting i3

After logging in to text-mode, generate the required DPI-specific configuration
and start the X server:

```sh
./templated-config/generate-config.sh ./templated-config/configs/regular-dpi.json
startx
```

This should start i3.

## Configuring displays

Use `xrandr` to configure the monitors. You can also use
[`arandr`](https://christian.amsuess.com/tools/arandr/) to do that in a visual
way.

Use [`autorandr`](https://github.com/phillipberndt/autorandr) to automatically
switch layouts.
