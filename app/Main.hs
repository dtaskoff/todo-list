{-#LANGUAGE OverloadedStrings #-}
import Application () -- for YesodDispatch instance
import Control.Concurrent.MVar
import Control.Monad.Logger (runStderrLoggingT)
import Control.Monad.Trans.Resource (runResourceT)
import Database.Persist.Sqlite
import Foundation
import Status
import Task
import Yesod.Core


main :: IO ()
main = do
  tasksMVar <- newMVar tasks'
  nextIndexMVar <- newMVar 3
  runStderrLoggingT $
    withSqlitePool "todo-list.db3" 42 $ \pool -> liftIO $ do
      runResourceT $ flip runSqlPool pool $ runMigration migrateAll
      warp 3000 $ App pool nextIndexMVar tasksMVar

tasks' :: Tasks
tasks' =
  [ Task 0 "Haskell Workshop Day 1" "Haskell Workshop" Done
  , Task 1 "Haskell Workshop Day 2" "Haskell Workshop" Done
  , Task 2 "Haskell Workshop Day 3" "Haskell Workshop" TODO
  ]
