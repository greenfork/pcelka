import { addHotkeyListener } from "./hotkey.js";

function clickIdIfPresent(id) {
  const elem = document.getElementById(id);
  if (!elem) return;
  elem.click();
}

addHotkeyListener(
  ["s", "ы"],
  () => clickIdIfPresent("scroll-to-bottom-checkbox"),
);
addHotkeyListener(["u", "г"], () => clickIdIfPresent("nav-up"));
addHotkeyListener(["d", "в"], () => clickIdIfPresent("nav-down"));

window.$ = (s) => document.querySelector(s);
