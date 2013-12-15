module Components.Model where

import Components.Input as Input

data State = StartScreen | Alive | Dead
type Game = { state: State, countDownStart: Time, timer: Int }

defaultGame =
  { state = StartScreen
  , countDownStart = 0
  , timer = 60 }

stepGame : Input.Input -> Game -> Game
stepGame {space, enter, launch, elapsed} ({state, countDownStart, timer} as game) =
  if state == Dead && enter then
    defaultGame

  else
    { game | state <- if | state == StartScreen && space -> Alive
                         | state == Alive && (timer == 0 || launch) -> Dead
                         | otherwise -> state

           , countDownStart <- if | state == Alive && countDownStart == 0 -> elapsed
                                  | otherwise -> countDownStart

           , timer <- if | state == Alive && countDownStart /= 0 -> stepTimer countDownStart elapsed 
                         | otherwise -> timer
    }

stepTimer : Time -> Time -> Int
stepTimer start now =
  60 - (round (inSeconds now) - round (inSeconds start))

gameState = foldp stepGame defaultGame Input.input
