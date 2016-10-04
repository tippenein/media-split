{-# LANGUAGE OverloadedStrings #-}
module Media.Split where

import System.Process
import System.FilePath (takeExtension)
import System.Directory
import qualified  Data.Text as T

bookExtensions = [".djvu", ".azw3", ".epub", ".mobi", ".pdf"]
videoExtensions = []
musicExtensions = [".mp3", "mp4", ".wav", ".flac", ".ogg", ".aiff"]

downcase = T.toLower

extensionFrom :: FilePath -> T.Text
extensionFrom = downcase . T.pack . takeExtension

type RemoteFilePath = T.Text

moveFiles :: [FilePath] -> RemoteFilePath -> IO ()
moveFiles [] _ = log "no files"
moveFiles fs rfp = do
  _ <- process $  "scp " ++ fs ++ " " ++ rfp
  pure ()

main = do
  fs <- listDirectory <$> source
  pure ()
  -- mapConcurrently moveFiles
