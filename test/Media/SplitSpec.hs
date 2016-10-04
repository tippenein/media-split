module Media.SplitSpec (spec) where

import Media.Split

import Test.Hspec

spec :: Spec
spec =
  describe "main" $ do
    it "returns the unit" $
      main `shouldReturn` ()
