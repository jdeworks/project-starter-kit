/**
 * Mock pixi.js for Node/CI environments where no canvas is available.
 * Import at the top of any test that touches pixi types:
 *   import "./helpers/mock-pixi"
 */
import { vi } from "vitest";

vi.mock("pixi.js", () => {
  class Container {
    children: unknown[] = [];
    x = 0;
    y = 0;
    visible = true;
    alpha = 1;
    scale = { x: 1, y: 1 };
    addChild(...children: unknown[]) {
      this.children.push(...children);
      return children[0];
    }
    removeChild(child: unknown) {
      const idx = this.children.indexOf(child);
      if (idx >= 0) this.children.splice(idx, 1);
      return child;
    }
    destroy() {
      this.children = [];
    }
  }

  class Graphics {
    x = 0;
    y = 0;
    visible = true;
    alpha = 1;
    clear() { return this; }
    beginFill(_color?: number, _alpha?: number) { return this; }
    endFill() { return this; }
    drawRect(_x: number, _y: number, _w: number, _h: number) { return this; }
    drawCircle(_x: number, _y: number, _r: number) { return this; }
    drawRoundedRect(_x: number, _y: number, _w: number, _h: number, _r: number) { return this; }
    lineStyle(_width?: number, _color?: number, _alpha?: number) { return this; }
    moveTo(_x: number, _y: number) { return this; }
    lineTo(_x: number, _y: number) { return this; }
    destroy() {}
  }

  class TextStyle {
    constructor(_style?: Record<string, unknown>) {}
  }

  class Text {
    text: string;
    style: TextStyle;
    x = 0;
    y = 0;
    visible = true;
    alpha = 1;
    anchor = { set: (_x: number, _y?: number) => {} };
    constructor(text = "", style?: TextStyle) {
      this.text = text;
      this.style = style ?? new TextStyle();
    }
    destroy() {}
  }

  class Application {
    stage = new Container();
    renderer = { width: 800, height: 600 };
    ticker = {
      add: (_fn: unknown) => {},
      remove: (_fn: unknown) => {},
      deltaTime: 1,
    };
    screen = { width: 800, height: 600 };
    destroy() {}
  }

  return {
    Container,
    Graphics,
    Text,
    TextStyle,
    Application,
  };
});
