{-#LANGUAGE OverloadedStrings #-}
import Application () -- for YesodDispatch instance
import Control.Concurrent.MVar
import Control.Monad.Logger (runStderrLoggingT)
import Control.Monad.Trans.Resource (runResourceT)
import Database.Persist.Sqlite
import Foundation
import Task
import Yesod.Core


main :: IO ()
main = do
  nextIndexMVar <- newMVar 0
  runStderrLoggingT $
    withSqlitePool "todo-list.db3" 42 $ \pool -> liftIO $ do
      runResourceT $ flip runSqlPool pool $ runMigration migrateAll
      warp 3000 $ App pool nextIndexMVar
