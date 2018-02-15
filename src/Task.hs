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

deleteTaskIDR :: Int -> Handler Value
-- deleteTaskIDR i = do
deleteTaskIDR i = do
  tasks' <- getsYesod tasks
  mtask <- liftIO $ modifyMVar tasks' (pure . removeTask i)
  maybe notFound returnJson mtask

-- | Given an index `i` and Tasks gives a tuple with all Tasks without the first
-- one having such an index and Just that Task, if such Task exists, else Nothing
removeTask :: Int -> Tasks -> (Tasks, Maybe Task)
removeTask i tasks =
  case break ((== i) . tid) tasks of   -- ^ breaks the list of tasks into two halves
    (ts, t:ts') -> (ts ++ ts', Just t) -- ^ where `t` is the first Task in the list that has an index `i`
    (ts, []) -> (ts, Nothing)

-- | A simple handler, that just outputs in the console the JSON body of the POST request
-- Note: requireJsonBody succeeds only if the passed JSON is correct, e.g. matches the
-- FromJSON instance for Task
postTaskR :: Handler ()
postTaskR = do
  task <- requireJsonBody
  liftIO $ print (task :: Task)
