import { Application, Graphics } from "pixi.js";
import { createGameState, update } from "./game";

const WIDTH = 800;
const HEIGHT = 600;

async function main() {
  const app = new Application();
  await app.init({
    width: WIDTH,
    height: HEIGHT,
    background: "#1a1a2e",
  });

  const container = document.getElementById("game");
  if (!container) throw new Error("Missing #game element");
  container.appendChild(app.canvas);

  let state = createGameState(WIDTH, HEIGHT, 50);

  const square = new Graphics();
  square.rect(0, 0, state.size, state.size);
  square.fill(0xe94560);
  app.stage.addChild(square);

  app.ticker.add(() => {
    state = update(state, WIDTH, HEIGHT);
    square.x = state.x;
    square.y = state.y;
  });
}

main();
