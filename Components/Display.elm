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
      Model.IntroScreen -> renderIntroScreen
      Model.Alive -> renderGame timer
      Model.Dead -> renderGameOver

  in collage gameWidth gameHeight (background :: forms) |> container windowWidth windowHeight middle

renderStartScreen : [Form]
renderStartScreen =
  let
      welcomeText : Form
      welcomeText = styleText (rgb 160 0 0) 42 "Петро́в" |> moveY (halfHeight - 50)

      startText : Form
      startText = styleText (rgb 220 220 220) 16 "Press [SPACE] to man your post" |> moveY (-halfHeight + 24)

  in [welcomeText, startText]

renderIntroScreen : [Form]
renderIntroScreen =
  let
    setting : Form
    setting  = styleText (rgb 220 220 220) 20 "Серпухов-15" |> moveY 100

    salutation : Form
    salutation = styleText (rgb 160 0 0) 20 "Good morning, Comrade Станисла́в" |> moveY -100

  in [setting, salutation]

renderGame : Int -> [Form]
renderGame timer =
  let
      alarm : Form
      alarm =
        let modulus : Int
            modulus = timer `mod` 2

        in [ oval 40 20 |> (filled <| if modulus == 0 then (rgb 98 2 2) else (rgb 196 4 4)) |> moveY halfHeight
           , collage gameWidth gameHeight [rect gameWidth gameHeight |> filled (rgb 196 4 4)]
               |> opacity (0.2 * toFloat modulus) |> toForm
           ] |> group

      worldMap : Form
      worldMap = [ rect 492 268 |> (filled <| rgb 127 127 127)
                 , rect 490 266 |> (filled <| rgb 0 0 0)
                 , image 490 266 "/assets/map.png" |> toForm
                 ] |> group |> moveY (((gameHeight - 306) / 2) - 25)

      controlPanel : Form
      controlPanel =
        let background : Form
            background = polygon (path [(0, 0), (gameWidth - 100, 0), (gameWidth - 60, (-halfHeight / 2)), (-30, (-halfHeight / 2))])
                           |> (filled <| rgb 31 31 31) |> move (-halfWidth + 45, -(halfHeight / 2) + 20)

            countDown : Form
            countDown = [rect 30 20 |> (filled <| rgb 0 0 0), styleText (rgb 0 255 0) 14 (show timer)]
                          |> group |> move (-gameWidth / 2 + (3 * halfWidth / 5), -gameHeight / 3)

        in [background, countDown] |> group

      launchButton : Form
      launchButton = launchButtonElement |> toForm |> move (gameWidth / 2 - (3 * halfWidth / 5), -gameHeight / 3)

  in [worldMap, controlPanel, alarm, launchButton]

renderGameOver : [Form]
renderGameOver =
  let
    gameOverMessage : Form
    gameOverMessage = styleText (rgb 160 0 0) 40 "Game Over" |> moveY(halfHeight / 4)

    replayMessage : Form
    replayMessage = styleText (rgb 220 220 200) 16 "Press [ENTER] to relive that day" |> moveY (-halfHeight / 2)

  in [gameOverMessage, replayMessage]
