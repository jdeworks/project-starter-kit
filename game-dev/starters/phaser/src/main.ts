import Phaser from "phaser";
import { BootScene } from "./scenes/boot";

const config: Phaser.Types.Core.GameConfig = {
  type: Phaser.AUTO,
  width: 800,
  height: 600,
  backgroundColor: "#1a1a2e",
  scene: [BootScene],
};

new Phaser.Game(config);
