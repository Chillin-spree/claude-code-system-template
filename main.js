// Entry point for App Name — replace with your app logic.
const button = document.querySelector("#action");
const output = document.querySelector("#output");

let count = 0;
button.addEventListener("click", () => {
  count += 1;
  output.textContent = `Clicked ${count} time${count === 1 ? "" : "s"}.`;
});

console.log("App Name loaded.");
