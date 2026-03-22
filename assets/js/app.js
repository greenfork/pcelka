import { addHotkeyListener } from "./hotkey.js";

function toggleScrollToBottomCheckbox() {
  const checkbox = document.getElementById("scroll-to-bottom-checkbox");
  if (!checkbox) return;
  checkbox.click();
}

addHotkeyListener(["s", "ы"], toggleScrollToBottomCheckbox);
