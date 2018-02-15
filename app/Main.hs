import Application () -- for YesodDispatch instance
import Control.Concurrent.MVar
import Foundation
import Task
import Yesod.Core

main :: IO ()
main = do
  app <- newMVar tasks'
  warp 3000 $ App app
-- main = warp 3000 . app =<< newMVar tasks'

tasks' :: [Task]
tasks' =
  [ Task 0
         (TaskText "Haskell Workshop Day 1" "Haskell Workshop")
         Done
  , Task 1
         (TaskText "Haskell Workshop Day 2" "Haskell Workshop")
         InProgress
  , Task 2
         (TaskText "Haskell Workshop Day 3" "Haskell Workshop")
         TODO
  ]
