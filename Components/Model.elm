module Components.Model where

type Input = { delta: Time }

data State = StartScreen | Alive
type Game = { state:State }

(gameWidth,gameHeight) = (720,480)
(halfWidth,halfHeight) = (360,240)

delta = inSeconds <~ fps 35
input = sampleOn delta (Input <~ delta)

defaultGame =
  { state = StartScreen }

stepGame : Input -> Game -> Game
stepGame {delta} ({state} as game) = game

gameState = foldp stepGame defaultGame input
