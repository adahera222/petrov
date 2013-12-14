module Components.Model where

import Keyboard

type Input = { space: Bool, delta: Time }

data State = StartScreen | Alive
type Game = { state:State }

(gameWidth,gameHeight) = (720,480)
(halfWidth,halfHeight) = (360,240)

delta = inSeconds <~ fps 35
input = sampleOn delta (Input <~ Keyboard.space
                               ~ delta)
defaultGame =
  { state = StartScreen }

stepGame : Input -> Game -> Game
stepGame {space, delta} ({state} as game) =
  { game | state <- if state == StartScreen && space then Alive else state }

gameState = foldp stepGame defaultGame input
