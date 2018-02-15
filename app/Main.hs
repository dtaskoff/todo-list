import Application () -- for YesodDispatch instance
import Foundation
import Types
import Yesod.Core


main :: IO ()
main = warp 3000 $ App tasks'

tasks' :: [Task]
tasks' =
  [ Task 0 "Haskell Workshop Day 1" "Haskell Workshop" Done
  , Task 1 "Haskell Workshop Day 2" "Haskell Workshop" TODO
  ]
