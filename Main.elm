import Window

-- Inputs

type Input = { delta: Time }

delta = inSeconds <~ fps 35

input = sampleOn delta (Input <~ delta)

-- Model

(gameWidth,gameHeight) = (720,480)
(halfWidth,halfHeight) = (360,240)

data State = Alive | Dead

type Game = { state:State }

defaultGame =
  { state = Alive }

-- Updates

stepGame : Input -> Game -> Game
stepGame {delta} ({state} as game) = game

gameState = foldp stepGame defaultGame input

-- Display

sceneBackground = rgb 15 15 15

display : (Int, Int) -> Game -> Element
display (w, h) {state} =
  container w h middle <| collage gameWidth gameHeight
    [ rect gameWidth gameHeight |> filled sceneBackground ]

main = lift2 display Window.dimensions gameState
