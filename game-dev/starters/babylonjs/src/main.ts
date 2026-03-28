import { Engine, Scene, ArcRotateCamera, Vector3 } from "@babylonjs/core";
import { setupScene } from "./scene-setup";
import { createBounceState, applyBounce } from "./physics";

const canvas = document.getElementById("renderCanvas") as HTMLCanvasElement;
const engine = new Engine(canvas, true);
const scene = new Scene(engine);

const camera = new ArcRotateCamera(
  "camera",
  Math.PI / 4,
  Math.PI / 3,
  8,
  Vector3.Zero(),
  scene,
);
camera.attachControl(canvas, true);

const { sphere } = setupScene(scene);

let bounceState = createBounceState(3);

scene.registerBeforeRender(() => {
  bounceState = applyBounce(bounceState, -0.005, 0.5, 0.85);
  sphere.position.y = bounceState.y;
});

engine.runRenderLoop(() => {
  scene.render();
});

window.addEventListener("resize", () => {
  engine.resize();
});
