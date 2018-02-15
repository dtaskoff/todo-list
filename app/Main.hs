import Application () -- for YesodDispatch instance
import Control.Concurrent.MVar
import Foundation
import Task
import Yesod.Core


main :: IO ()
-- main = warp 3000 . App =<< newMVar tasks'
main = do
  tasksMVar <- newMVar tasks'
  nextIndexMVar <- newMVar 2
  warp 3000 $ App nextIndexMVar tasksMVar

tasks' :: Tasks
tasks' =
  [ Task 0 "Haskell Workshop Day 1" "Haskell Workshop" Done
  , Task 1 "Haskell Workshop Day 2" "Haskell Workshop" TODO
  ]
