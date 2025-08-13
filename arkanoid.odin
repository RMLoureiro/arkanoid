package arkanoid

import rl "vendor:raylib"

PADDLE_WIDTH :: 50
PADDLE_HEIGHT :: 6
PADDLE_POS_Y :: 260

paddle_pos_x: f32

main :: proc () {
  rl.SetConfigFlags({ .VSYNC_HINT })
  rl.InitWindow(1280, 1280, "Arkanoid")
  rl.SetTargetFPS(500)

  for !rl.WindowShouldClose() {
    rl.BeginDrawing()
    rl.ClearBackground({ 150, 190, 220, 255 })

    paddle_rect := rl.Rectangle {
      paddle_pos_x,
      PADDLE_POS_Y,
      PADDLE_WIDTH,
      PADDLE_HEIGHT,
    }

    rl.EndDrawing()
  }

  rl.CloseWindow()
}
