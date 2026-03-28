import Phaser from "phaser";
import { nextColor, getColor } from "../game-logic";

export class BootScene extends Phaser.Scene {
  private square!: Phaser.GameObjects.Rectangle;
  private colorIndex = 0;

  constructor() {
    super({ key: "BootScene" });
  }

  create() {
    this.square = this.add.rectangle(400, 300, 80, 80, getColor(this.colorIndex));

    this.add
      .text(400, 50, "Click to change color!", {
        fontSize: "24px",
        color: "#ffffff",
      })
      .setOrigin(0.5);

    this.input.on("pointerdown", () => {
      this.colorIndex = nextColor(this.colorIndex);
      this.square.setFillStyle(getColor(this.colorIndex));
    });

    this.tweens.add({
      targets: this.square,
      y: 400,
      duration: 1000,
      ease: "Bounce.easeOut",
      yoyo: true,
      repeat: -1,
    });
  }
}
