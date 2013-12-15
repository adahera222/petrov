module Components.Model where

import Keyboard

type Input = { space: Bool, enter: Bool, elapsed: Time }

data State = StartScreen | Alive | Dead
type Game = { state: State, countDownStart: Time, timer: Int }

delta = inSeconds <~ fps 35
input = sampleOn delta (Input <~ Keyboard.space
                               ~ Keyboard.enter
                               ~ every second)
defaultGame =
  { state = StartScreen
  , countDownStart = 0
  , timer = 60 }

stepGame : Input -> Game -> Game
stepGame {space, enter, elapsed} ({state, countDownStart, timer} as game) =
  if state == Dead && enter then
    defaultGame

  else
    { game | state <- if | state == StartScreen && space -> Alive
                         | state == Alive && timer == 0 -> Dead
                         | otherwise -> state

           , countDownStart <- if | state == Alive && countDownStart == 0 -> elapsed
                                  | otherwise -> countDownStart

           , timer <- if | state == Alive && countDownStart /= 0 -> stepTimer countDownStart elapsed 
                         | otherwise -> timer
    }

stepTimer : Time -> Time -> Int
stepTimer start now =
  60 - (round (inSeconds now) - round (inSeconds start))

gameState = foldp stepGame defaultGame input
