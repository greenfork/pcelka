import { addHotkeyListener } from "./hotkey.js";

window.$ = (s) => document.querySelector(s);

function clickIdIfPresent(id) {
  const elem = document.getElementById(id);
  if (!elem) return;
  elem.click();
}

function focusSearch(e) {
  const elem = document.getElementById("search-logs");
  if (!elem) return;
  elem.focus();
  e.preventDefault();
}

addHotkeyListener(
  ["s", "ы"],
  () => clickIdIfPresent("scroll-to-bottom-checkbox"),
);
addHotkeyListener(["u", "г"], () => clickIdIfPresent("nav-up"));
addHotkeyListener(["d", "в"], () => clickIdIfPresent("nav-down"));
addHotkeyListener(["/", "."], focusSearch);
