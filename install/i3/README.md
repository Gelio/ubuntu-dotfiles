# i3 config

i3 and related desktop tools' configuration depends on the DPI.

For 4k 27 inch monitors that I use at home, using them at normal DPI is not
possible. I am using a laptop. I sometimes need to work with regular DPI
(e.g. when working only using my laptop screen - regular DPI should use less battery).
I need to support both regular DPI (for use outside my home) and HiDPI
configurations (at home) and be able to conveniently switch between them.

i3 is started by me using the command line. I [disabled systemd's
`graphical.target` and use
`multi-user.target`](https://www.cyberciti.biz/faq/switch-boot-target-to-text-gui-in-systemd-linux/)
so I can change the configuration before starting i3.

The process of starting i3 is as follows:

1. Generate the config files using [`generate-config.sh`](./templated-config/generate-config.sh)

   This generates the config files and stows them automatically.

2. Start i3

3. Change the monitor layout

   This can happen automatically using
   [autorandr](https://github.com/phillipberndt/autorandr) or manually via a
   script.
