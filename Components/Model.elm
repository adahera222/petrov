module Components.Model where

import Components.Input as Input

data State = StartScreen | IntroScreen | Alive | Done
data Done = NotYet | Win | AtFault | Fail | GoodJob

type Game =
  { state: State
  , done : Done
  , startTime: Int
  , realLaunch: Bool
  , countDownStart: Time
  , timer: Int
  }

defaultGame =
  { state = StartScreen
  , done = NotYet
  , startTime = -1
  , realLaunch = False
  , countDownStart = 0
  , timer = 60
  }

stepGame : Input.Input -> Game -> Game
stepGame {space, enter, launch, elapsed} ({state, done, startTime, realLaunch, countDownStart, timer} as game) =
  if state == Done && enter then
    defaultGame

  else
    { game | state <- if | state == StartScreen && space -> IntroScreen
                         | state == IntroScreen && round (inSeconds elapsed) - startTime >= 5 -> Alive
                         | state == Alive && (timer == 0 || launch) -> Done
                         | otherwise -> state

           , done <- if | state == Alive && (timer == 0 || launch) -> calculateDoneCondition realLaunch (timer /= 0 && launch)
                        | otherwise -> NotYet

           , realLaunch <- if | state /= Alive -> round elapsed `mod` 10 == 1
                              | otherwise -> realLaunch

           , startTime <- if | state == StartScreen -> round (inSeconds elapsed)
                             | otherwise -> startTime

           , countDownStart <- if | state == Alive && countDownStart == 0 -> elapsed
                                  | otherwise -> countDownStart

           , timer <- if | state == Alive && countDownStart /= 0 -> stepTimer countDownStart elapsed 
                         | otherwise -> timer
    }

stepTimer : Time -> Time -> Int
stepTimer start now =
  60 - (round (inSeconds now) - round (inSeconds start))

calculateDoneCondition : Bool -> Bool -> Done
calculateDoneCondition realLaunch didLaunch =
  if | not realLaunch && not didLaunch -> Win
     | not realLaunch && didLaunch -> AtFault
     | realLaunch && not didLaunch -> Fail
     | realLaunch && didLaunch -> GoodJob

gameState = foldp stepGame defaultGame Input.input
