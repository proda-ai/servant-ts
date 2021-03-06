{-# LANGUAGE MagicHash #-}
{-# LANGUAGE OverloadedStrings #-}

module Servant.TS.InstanceTests (
    instanceTests
) where

import Data.Fixed (Fixed, E0(..))
import Data.Functor.Compose (Compose(..))
import Data.Functor.Const (Const(..))
import Data.Functor.Identity (Identity(..))
import Data.Functor.Product (Product(..))
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as HashMap
import qualified Data.HashSet as HS
import Data.Int (Int8, Int16, Int32, Int64)
import Data.List.NonEmpty (NonEmpty)
import Data.Map (Map)
import qualified Data.Map as Map
import qualified Data.Monoid as Monoid
import qualified Data.Primitive.Array as PM
import qualified Data.Primitive.PrimArray as PM
import qualified Data.Primitive.SmallArray as PM
import qualified Data.Primitive.Types as PM
import qualified Data.Primitive.UnliftedArray as PM
import Data.Ratio (Ratio, (%))
import Data.Tagged
import qualified Data.Semigroup as Semigroup
import Data.Text (Text)
import qualified Data.Text as Text
import qualified Data.Text.Lazy as LT
import Data.Time
import Data.Time.Clock
import Data.Time.LocalTime
import Data.Tree (Tree(..))
import Data.Proxy
import Data.UUID as UUID
import Data.Vector (Vector)
import qualified Data.Vector as V
import qualified Data.Vector.Generic as VG
import qualified Data.Vector.Mutable as VM
import qualified Data.Vector.Primitive as VP
import qualified Data.Vector.Storable as VS
import qualified Data.Vector.Unboxed as VU
import Data.Version (Version, makeVersion)
import Data.Word (Word8, Word16, Word32, Word64)
import Numeric.Natural (Natural)
import Foreign.C.Types (CTime(..))
import GHC.Exts
import Test.Tasty
import Test.Tasty.HUnit

import Servant.TS.TestHelpers

instanceTests :: TestTree
instanceTests = testGroup "Aeson <-> TS instance isomorphic"
    [ makeTest True
    , makeTest LT
    , makeTest ()
    , makeTest ('a' :: Char)
    , makeTest (1.0 :: Double)
    , makeTest (1.0 :: Float)
    , makeTest (1 % 2 :: Ratio Int)
    , makeTest (1 :: Fixed E0)
    , makeTest (1 :: Int) 
    , makeTest (1 :: Integer)
    , makeTest (1 :: Natural)
    , makeTest (1 :: Int8)
    , makeTest (1 :: Int16)
    , makeTest (1 :: Int32)
    , makeTest (1 :: Int64)
    , makeTest (1 :: Word)
    , makeTest (1 :: Word8)
    , makeTest (1 :: Word16)
    , makeTest (1 :: Word32)
    , makeTest (1 :: Word64)
    , makeTest (CTime 1)
    , makeTest ("a" :: Text)
    , makeTest ("a" :: LT.Text)
    , makeTest (makeVersion [1,2,3,4])
    , makeTest (Just 1 :: Maybe Int)
    , makeTest (Nothing :: Maybe Int)
    , makeTest (Left 1 :: Either Int Text)
    , makeTest (Right "a" :: Either Int Text)
    , makeTest ([] :: [Int])
    , makeTest ([1] :: [Int])
    {- , makeTest (NonEmpty [1] :: NonEmpty Int) -}
    , makeTest (Identity 1 :: Identity Int)
    , makeTest (Const 1 :: Const Int Text)
    , makeTest (Compose 1 :: Compose Identity Identity Int)
    , makeTest (Pair (Identity 1) (Const "a") :: Product Identity (Const Text) Int)
    {- , makeTest (Seq [1]) -}
    {- , makeTest (Set [1]) -}
    {-, makeTest (IntSet [1]) -}
    {- IntMap -}
    , makeTest (Node 1 [Node 2 [], Node 3 []] :: Tree Int)
    , makeTest (Map.insert 1 "a" Map.empty :: Map Int Text) 

    {- UUID -}
    , makeTest (UUID.fromWords 1 2 3 4)

    {- vector -}
    , makeTest (V.fromList [1] :: V.Vector Int)
    , makeTest (VS.fromList [1] :: VS.Vector Int)
    , makeTest (VP.fromList [1] :: VP.Vector Int)
    , makeTest (VU.fromList [1] :: VU.Vector Int)


    , makeTest (HS.singleton 1 :: HS.HashSet Int)
    , makeTest (HashMap.fromList [("a", 1)] :: HashMap Text Int)

    {- primitive -}
    , makeTest (PM.fromList [1, 2] :: PM.Array Int)
    , makeTest (PM.smallArrayFromList [1, 2] :: PM.SmallArray Int)
    , makeTest (PM.primArrayFromList [1, 2] :: PM.PrimArray Int)
    {- , makeTest (PM.newUnliftedArray 1 1 :: PM.UnliftedArray Int) -}

    {- Date Types -}
    , makeTest (ModifiedJulianDay 123456)
    , makeTest (TimeOfDay 7 30 0)
    , makeTest (LocalTime (ModifiedJulianDay 123456) (TimeOfDay 7 30 0))
    , makeTest (UTCTime (ModifiedJulianDay 123456) (secondsToDiffTime 24))
    , makeTest (nominalDay)
    , makeTest (secondsToDiffTime 24)
    , makeTest ((Monoid.Dual "a" `mappend` Monoid.Dual "b") :: Monoid.Dual Text)
    , makeTest ((Monoid.First Nothing `mappend` Monoid.First (Just "b")) :: Monoid.First Text)
    , makeTest ((Monoid.Last Nothing `mappend` Monoid.Last (Just "b")) :: Monoid.Last Text)
    , makeTest ((Semigroup.Min 1 `mappend` 2) :: Semigroup.Min Int)
    , makeTest (Proxy :: Proxy Int)
    , makeTest (Tagged 1 :: Tagged Text Int)
    , makeTest ((1, "a") :: (Int, Text))
    , makeTest ((1, "a", False) :: (Int, Text, Bool))
    , makeTest ((1, "a", False, 2) :: (Int, Text, Bool, Int))
    , makeTest ((1, "a", False, 2, "b") :: (Int, Text, Bool, Int, Text))
    , makeTest ((1, "a", False, 2, "b", True) :: (Int, Text, Bool, Int, Text, Bool))
    , makeTest ((1, "a", False, 2, "b", True, 3) :: (Int, Text, Bool, Int, Text, Bool, Int))
    , makeTest ((1, "a", False, 2, "b", True, 3, "c") :: (Int, Text, Bool, Int, Text, Bool, Int, Text))
    , makeTest ((1, "a", False, 2, "b", True, 3, "c", 4) :: (Int, Text, Bool, Int, Text, Bool, Int, Text, Int))
    , makeTest ((1, "a", False, 2, "b", True, 3, "c", 4, "d") :: (Int, Text, Bool, Int, Text, Bool, Int, Text, Int, Text))
    , makeTest ((1, "a", False, 2, "b", True, 3, "c", 4, "d", 5) :: (Int, Text, Bool, Int, Text, Bool, Int, Text, Int, Text, Int))
    , makeTest ((1, "a", False, 2, "b", True, 3, "c", 4, "d", 5, "c") :: (Int, Text, Bool, Int, Text, Bool, Int, Text, Int, Text, Int, Text))
    , makeTest ((1, "a", False, 2, "b", True, 3, "c", 4, "d", 5, "c", 6) :: (Int, Text, Bool, Int, Text, Bool, Int, Text, Int, Text, Int, Text, Int))
    ]