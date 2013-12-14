module Components.Model where

import Keyboard

type Input = { space: Bool, elapsed: Time }

data State = StartScreen | Alive
type Game = { state: State, countDownStart: Time, timer: Int }

(gameWidth,gameHeight) = (720,480)
(halfWidth,halfHeight) = (360,240)

delta = inSeconds <~ fps 35
input = sampleOn delta (Input <~ Keyboard.space
                               ~ every second)
defaultGame =
  { state = StartScreen
  , countDownStart = 0
  , timer = 60 }

stepGame : Input -> Game -> Game
stepGame {space, elapsed} ({state, countDownStart, timer} as game) =
  { game | state <- if state == StartScreen && space then Alive else state
         , countDownStart <- if state == Alive && countDownStart == 0 then elapsed else countDownStart
         , timer <- if state == Alive && countDownStart /= 0 then stepTimer countDownStart elapsed else 60
  }

stepTimer : Time -> Time -> Int
stepTimer start now =
  60 - (round (inSeconds now) - round (inSeconds start))

gameState = foldp stepGame defaultGame input
