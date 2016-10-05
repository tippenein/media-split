{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric     #-}
module Media.Split where

import System.Process
import System.FilePath
import System.Directory
import System.IO.Unsafe
import Data.Monoid ((<>))
import Options.Generic
import Data.List (intercalate, groupBy)
import Data.Char
import Data.Maybe (fromJust)
import qualified Data.Map.Lazy as M
import GHC.IO.Exception (ExitCode)
import System.Exit (exitSuccess, exitFailure)

type RemoteFilePath = String

data Manifest
  = Manifest
  { target :: FilePath
  , book_dest :: Maybe String
  , music_dest :: Maybe String
  , dry_run :: Bool
  } deriving (Generic, Show)

instance ParseRecord Manifest

data Media
  = Book
  | Music
  deriving (Show, Eq, Ord)

videoExtensions = []
bookExtensions = [".djvu", ".azw3", ".epub", ".mobi", ".pdf"]
musicExtensions = [".mp3", "mp4", ".wav", ".flac", ".ogg", ".aiff", "aac"]

extensionFrom = map toLower . takeExtension

moveFiles :: [FilePath] -> Maybe String -> IO ()
moveFiles [] _ = print "no files" >> pure () -- exitFailure
moveFiles _ Nothing  = print "no destination" >> pure () -- exitFailure
moveFiles fs (Just rfp) = do
  let cmd = "scp -r \"" ++ intercalate " " (fmap (\f -> "\"" ++f++ "\"") fs) ++ " " ++ rfp
  print cmd
  pure ()
  -- exitSuccess
  -- ecode <- system cmd
  -- return ecode

split :: FilePath -> M.Map Media [FilePath]
split source = do
  let fs = unsafePerformIO $ getDirectoryContents source

  M.fromList
    [ (Book, filter (\fp -> extensionFrom fp `elem` bookExtensions) fs)
    , (Music, filter (\fp -> extensionFrom fp `elem` musicExtensions) fs)
    ]

writeManifest :: Manifest -> IO ()
writeManifest manifest = undefined

run m = do
  let sm = split $ target m
  let books = fmap (\fp -> target m </> fp) $ fromJust $ M.lookup Book sm
  let music = fromJust $ M.lookup Music sm
  moveFiles books $ music_dest m
  moveFiles books $ book_dest m
  return ()

main = do
  x <- getRecord "split and move files"
  print (x :: Manifest)

  run (x :: Manifest)
