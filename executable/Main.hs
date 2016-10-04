module Main (main) where

import qualified Media.Split
-- import System.Remote.Monitoring

main :: IO ()
main = Media.Split.main
  -- ekg <- forkServer "localhost" 8000
