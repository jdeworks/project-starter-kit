import { greet, formatDate } from "@repo/shared";

const app = document.getElementById("app");

if (app) {
  const heading = document.createElement("h1");
  heading.textContent = greet("Turborepo");

  const datePara = document.createElement("p");
  datePara.textContent = `Today is ${formatDate(new Date())}`;

  app.appendChild(heading);
  app.appendChild(datePara);
}
