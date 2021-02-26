#!/usr/bin/env node

const { execSync } = require("child_process");

const MEDIA_KEYS_PATH = "org.gnome.settings-daemon.plugins.media-keys";

console.log(
  "Make sure to install screen-focus-changer (./screen-focus-changer.sh)"
);
const SCREEN_FOCUS_CHANGER_PATH = `~/.local/share/screen-focus-changer/focus_changer.py`;

const KEYBINDINGS = [
  {
    name: "focus-terminal",
    command: "wmctrl -a Alacritty",
    binding: "<Super>grave",
  },
  {
    name: "focus-chrome",
    command: 'wmctrl -a "Google Chrome"',
    binding: "<Super>1",
  },
  {
    name: "focus-franz",
    command: "wmctrl -a Franz",
    binding: "<Super>2",
  },
  {
    name: "focus-vscode",
    command: 'wmctrl -a "Visual Studio Code"',
    binding: "<Super>3",
  },
  {
    name: "focus-left",
    command: `python3 ${SCREEN_FOCUS_CHANGER_PATH} left`,
    binding: "<Super><Shift>h",
  },
  {
    name: "focus-right",
    command: `python3 ${SCREEN_FOCUS_CHANGER_PATH} right`,
    binding: "<Super><Shift>l",
  },
  {
    name: "rofi-change-window",
    command: "rofi -show window",
    binding: "<Super>d",
  },
].map((keybinding) => ({
  ...keybinding,
  path: getKeybindingPath(keybinding.name),
}));

const existingCustomKeybindings = JSON.parse(
  execSync(`gsettings get ${MEDIA_KEYS_PATH} custom-keybindings`, {
    encoding: "utf-8",
  }).replace(/'/g, '"')
);

const customKeybindingPaths = new Set(existingCustomKeybindings);

const keybindingsToAdd = KEYBINDINGS.filter(
  (keybinding) => !customKeybindingPaths.has(keybinding.path)
);

if (keybindingsToAdd.length === 0) {
  console.log("All keybindings are already set. Exiting");
  process.exit(0);
}

keybindingsToAdd.forEach((keybinding) => {
  customKeybindingPaths.add(keybinding.path);
  const setKeybindingPropertyCommand = `gsettings set ${MEDIA_KEYS_PATH}.custom-keybinding:${keybinding.path}`;
  execSync(`${setKeybindingPropertyCommand} name '${keybinding.name}'`);
  execSync(`${setKeybindingPropertyCommand} command '${keybinding.command}'`);
  execSync(`${setKeybindingPropertyCommand} binding '${keybinding.binding}'`);
});

execSync(
  `gsettings set ${MEDIA_KEYS_PATH} custom-keybindings "${JSON.stringify(
    Array.from(customKeybindingPaths)
  ).replace(/"/g, "'")}"`
);

console.log("Added keybindings", keybindingsToAdd);

console.log("Disabling default Gnome hot-keys (Super + [0-9])");
execSync(
  "gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false"
);
Array.from({ length: 9 }).forEach((_, i) => {
  execSync(
    `gsettings set org.gnome.shell.keybindings switch-to-application-${
      i + 1
    } []`
  );
});
console.log('Done. Restart Gnome now (Alt + F2, and type "r")');

function getKeybindingPath(name) {
  return `/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-${name}/`;
}
