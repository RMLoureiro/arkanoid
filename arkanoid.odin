package arkanoid

import rl "vendor:raylib"
import "core:math"
import "core:math/linalg"

SCREEN_SIZE :: 160
PADDLE_WIDTH :: 25
PADDLE_HEIGHT :: 3
PADDLE_POS_Y :: 130
PADDLE_SPEED :: 100
BALL_SPEED :: 130
BALL_RADIUS :: 2
BALL_START_Y :: 80

ball_pos: rl.Vector2
ball_dir: rl.Vector2
paddle_pos_x: f32
started: bool

main :: proc () {
  rl.SetConfigFlags({ .VSYNC_HINT })
  rl.InitWindow(640, 640, "Arkanoid")
  rl.SetTargetFPS(500)

  restart()

  for !rl.WindowShouldClose() {
    paddle_move_velocity: f32
    dt: f32

    if !started {
      ball_pos = {
        SCREEN_SIZE/2 + f32(math.cos(rl.GetTime()) * SCREEN_SIZE/2.5),
        BALL_START_Y,
      }
    
      if rl.IsKeyPressed(.SPACE) {
        paddle_middle := rl.Vector2 { paddle_pos_x + PADDLE_WIDTH/2, PADDLE_POS_Y }
        ball_to_paddle := paddle_middle - ball_pos
        ball_dir = linalg.normalize0(ball_to_paddle)
        started = true
      }
    } else {
      dt = rl.GetFrameTime()
    }

    ball_pos += ball_dir * BALL_SPEED * dt

    if rl.IsKeyDown(.LEFT) {
      paddle_move_velocity -= PADDLE_SPEED
    }

    if rl.IsKeyDown(.RIGHT) {
      paddle_move_velocity += PADDLE_SPEED
    }

    paddle_pos_x += paddle_move_velocity * dt
    paddle_pos_x = clamp(paddle_pos_x, 0, SCREEN_SIZE - PADDLE_WIDTH)

    rl.BeginDrawing()
    rl.ClearBackground({ 150, 190, 220, 255 })

    camera := rl.Camera2D {
      zoom = f32(rl.GetScreenHeight() / SCREEN_SIZE)
    }
    
    rl.BeginMode2D(camera)

    paddle_rect := rl.Rectangle {
      paddle_pos_x,
      PADDLE_POS_Y,
      PADDLE_WIDTH,
      PADDLE_HEIGHT,
    }

    rl.DrawRectangleRec(paddle_rect, { 50, 150, 90, 255 })
    rl.DrawCircleV(ball_pos, BALL_RADIUS, { 200, 90, 20, 255 })
    rl.EndMode2D()
    rl.EndDrawing()
  }

  rl.CloseWindow()
}

restart :: proc() {
  paddle_pos_x = (SCREEN_SIZE/2) - (PADDLE_WIDTH/2)
  ball_pos = { SCREEN_SIZE/2, BALL_START_Y }
  started = false
}
