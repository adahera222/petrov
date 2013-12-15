module Components.Display where

import Components.Model as Model

(gameWidth, gameHeight) = (720, 480)
(halfWidth, halfHeight) = (360, 240)

styleText : Color -> number -> String -> Element
styleText fg h v = toText v |> text . Text.color fg . Text.height h . monospace

render : (Int, Int) -> Model.Game -> Element
render (windowWidth, windowHeight) {state, timer} =
  let
    background : Form
    background = rect gameWidth gameHeight |> filled (rgb 15 15 15)

    forms = case state of
      Model.StartScreen -> renderStartScreen
      Model.Alive -> renderGame timer
      Model.Dead -> renderGameOver

  in collage gameWidth gameHeight (background :: forms) |> container windowWidth windowHeight middle

renderStartScreen : [Form]
renderStartScreen =
  let
      welcomeText : Form
      welcomeText = styleText (rgb 160 0 0) 42 "Petrov's Decision" |> toForm |> moveY (halfHeight - 50)

      startText : Form
      startText = styleText (rgb 220 220 220) 16 "Press [SPACE] to man your post" |> toForm |> moveY (-halfHeight + 24)

  in [welcomeText, startText]

renderGame : Int -> [Form]
renderGame timer =
  let
      alarm : Form
      alarm = oval 40 20 |> (filled <| rgb 98 2 2) |> moveY halfHeight

      worldMap : Form
      worldMap = rect (gameWidth - 60) halfHeight |> (filled <| rgb 0 0 0) |> moveY (halfHeight / 2 - 30)

      controlPanel : Form
      controlPanel = [ polygon (path [(0, 0), (gameWidth - 60, 0), (gameWidth - 45, (-halfHeight / 2)), (-15, (-halfHeight / 2))])
                         |> (filled <| rgb 31 31 31) |> move (-halfWidth + 30, -(halfHeight / 2) + 100)
                     , rect 30 20 |> (filled <| rgb 0 0 0) |> move (-gameWidth / 4, -gameHeight / 4)
                     , styleText (rgb 0 255 0) 14 (show timer) |> toForm |> move (-gameWidth / 4, -gameHeight / 4)
                     ] |> group

  in [alarm, worldMap, controlPanel]

renderGameOver : [Form]
renderGameOver =
  let
    gameOverMessage : Form
    gameOverMessage = styleText (rgb 160 0 0) 40 "Game Over" |> toForm |> moveY(halfHeight / 4)

    replayMessage : Form
    replayMessage = styleText (rgb 220 220 200) 16 "Press [ENTER] to relive that day" |> toForm |> moveY (-halfHeight / 2)

  in [gameOverMessage, replayMessage]
