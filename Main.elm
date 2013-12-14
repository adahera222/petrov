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
    [ rect gameWidth gameHeight |> filled sceneBackground
    , rect (gameWidth - 60) halfHeight |> (filled <| rgb 0 0 0) |> moveY (halfHeight / 2 - 30)
    , polygon (path [(0, 0), (gameWidth - 60, 0), (gameWidth - 45, (-halfHeight / 2)), (-15, (-halfHeight / 2))])
        |> (filled <| rgb 31 31 31) |> move (-halfWidth + 30, -(halfHeight / 2) + 100)
    ]

main = lift2 display Window.dimensions gameState
