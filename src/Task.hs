module Task where

import Control.Concurrent.MVar
import Data.List (find)
import Foundation
import Types
import Yesod.Core


getTasksYesod :: Handler [Task]
-- getTasksYesod = liftIO . readMVar =<< getsYesod tasks
getTasksYesod = do
  tasksMVar <- getsYesod tasks
  liftIO $ readMVar tasksMVar

getTaskR :: Handler Value
-- getTaskR = returnJson =<< getTasksYesod
getTaskR = do
  tasks' <- getTasksYesod
  returnJson tasks'

getTaskIDR :: Int -> Handler Value
-- getTaskIDR i = maybe notFound returnJson . find ((== i) . tid) =<< getTasksYesod
getTaskIDR i = do
  tasks' <- getTasksYesod
  let mtask = find ((== i) . tid) tasks'
  maybe notFound returnJson mtask
--  let mtask = find ((== i) . tid) tasks'
--  case mtask of
--    Just task -> returnJson task
--    Nothing   -> notFound

-- | A simple handler, that just outputs in the console the JSON body of the POST request
-- Note: requireJsonBody succeeds only if the passed JSON is correct, e.g. matches the
-- FromJSON instance for Task
postTaskR :: Handler ()
postTaskR = do
  task <- requireJsonBody
  liftIO $ print (task :: Task)
