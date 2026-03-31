import { Application, Graphics } from "pixi.js";
import { createPlayer, updatePlayer, type PlayerState } from "../entities/Player";
import { GAME_WIDTH, GAME_HEIGHT, PLAYER_SIZE } from "../config/constants";

export class GameScene {
  private player: PlayerState;
  private sprite: Graphics;

  constructor(private app: Application) {
    this.player = createPlayer(GAME_WIDTH / 2, GAME_HEIGHT / 2, PLAYER_SIZE);

    this.sprite = new Graphics();
    this.sprite.rect(0, 0, this.player.size, this.player.size);
    this.sprite.fill(0xe94560);
    this.app.stage.addChild(this.sprite);
  }

  start() {
    this.app.ticker.add(() => this.update());
  }

  private update() {
    this.player = updatePlayer(this.player, GAME_WIDTH, GAME_HEIGHT);
    this.sprite.x = this.player.x;
    this.sprite.y = this.player.y;
  }
}
