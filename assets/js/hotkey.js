function isEventFiredOnInput(event) {
  const target = event.target;
  const { tagName } = target;
  const isInput = tagName === "INPUT" &&
    ![
      "checkbox",
      "radio",
      "range",
      "button",
      "file",
      "reset",
      "submit",
      "color",
    ].includes(target.type);

  return target.isContentEditable ||
    ((isInput || tagName === "TEXTAREA" || tagName === "SELECT") &&
      !target.readOnly);
}

export function addHotkeyListener(keys, fn) {
  if (!Array.isArray(keys)) keys = [keys];
  document.addEventListener("keydown", (e) => {
    if (isEventFiredOnInput(e)) return;
    if (keys.includes(e.key)) fn();
  });
}
