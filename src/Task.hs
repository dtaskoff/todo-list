module Task where

import Foundation
import Types
import Yesod.Core


postTaskR :: Handler ()
postTaskR = do
  task <- requireJsonBody
  liftIO $ print (task :: Task)
