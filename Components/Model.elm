module Components.Model where

(gameWidth,gameHeight) = (720,480)
(halfWidth,halfHeight) = (360,240)

data State = Play | NoPlay

type Game = { state:State }

defaultGame =
  { state = Play }
