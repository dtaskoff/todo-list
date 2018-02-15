module TaskHandlers where

import Control.Concurrent.MVar
import Data.List (find)
import Foundation
import Task
import Yesod.Core


getTasksYesod :: Handler Tasks
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
-- getTaskIDR i = maybe notFound returnJson . find (matchesID i) =<< getTasksYesod
getTaskIDR i = do
  tasks' <- getTasksYesod
  let mtask = find (matchesID i) tasks'
  maybe notFound returnJson mtask
--  let mtask = find (matchesID i) tasks'
--  case mtask of
--    Just task -> returnJson task
--    Nothing   -> notFound

deleteTaskIDR :: Int -> Handler Value
-- deleteTaskIDR i = do
deleteTaskIDR i = do
  tasks' <- getsYesod tasks
  mtask <- liftIO $ modifyMVar tasks' (pure . removeTask i)
  maybe notFound returnJson mtask

-- | A simple handler, that just outputs in the console the JSON body of the POST request
-- Note: requireJsonBody succeeds only if the passed JSON is correct, e.g. matches the
-- FromJSON instance for Task
postTaskR :: Handler ()
postTaskR = do
  task <- requireJsonBody
  liftIO $ print (task :: Task)
