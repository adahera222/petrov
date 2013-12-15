module Components.Display where

import Components.Input (launchButtonElement)

import Components.Model as Model

(gameWidth, gameHeight) = (720, 480)
(halfWidth, halfHeight) = (360, 240)

styleText : Color -> number -> String -> Form
styleText fg h v = toText v |> toForm . text . Text.color fg . Text.height h . monospace

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
      welcomeText = styleText (rgb 160 0 0) 42 "Petrov's Decision" |> moveY (halfHeight - 50)

      startText : Form
      startText = styleText (rgb 220 220 220) 16 "Press [SPACE] to man your post" |> moveY (-halfHeight + 24)

  in [welcomeText, startText]

renderGame : Int -> [Form]
renderGame timer =
  let
      alarm : Form
      alarm = oval 40 20 |> (filled <| if timer `mod` 2 == 0 then (rgb 98 2 2) else (rgb 196 4 4)) |> moveY halfHeight

      worldMap : Form
      worldMap = [ rect 490 266 |> (filled <| rgb 0 0 0)
                 , image 490 266 "/assets/map.png" |> toForm
                 ] |> group |> moveY (((gameHeight - 306) / 2) - 25)

      controlPanel : Form
      controlPanel =
        let background : Form
            background = polygon (path [(0, 0), (gameWidth - 100, 0), (gameWidth - 60, (-halfHeight / 2)), (-30, (-halfHeight / 2))])
                           |> (filled <| rgb 31 31 31) |> move (-halfWidth + 45, -(halfHeight / 2) + 20)

            countDown : Form
            countDown = [rect 30 20 |> (filled <| rgb 0 0 0), styleText (rgb 0 255 0) 14 (show timer)]
                          |> group |> move (-gameWidth / 2 + 100, -gameHeight / 3)

        in [background, countDown] |> group
  in [alarm, worldMap, controlPanel]

renderGameOver : [Form]
renderGameOver =
  let
    gameOverMessage : Form
    gameOverMessage = styleText (rgb 160 0 0) 40 "Game Over" |> moveY(halfHeight / 4)

    replayMessage : Form
    replayMessage = styleText (rgb 220 220 200) 16 "Press [ENTER] to relive that day" |> moveY (-halfHeight / 2)

  in [gameOverMessage, replayMessage]
