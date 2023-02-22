{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Internal.RestrictedIO (
    RestrictedIO
    , UnsafeFileIO(..)
    , EntropyIO(..)
) where

import Data.Kind

import Internal.Untrusted

type RestrictedIO m entropy = (UnsafeFileIO m, EntropyIO m entropy, RandomIO m)

class UnsafeFileIO (m :: Type -> Type) where
    -- | read a file from an untrusted part of the filesystem, yielding an untrusted
    -- Value
    untrustedReadFile  :: FilePath -> m (Untrusted String)
    -- | write to the untrusted part of the filesystem. This is identical to the
    -- conventional @readFile@ function
    untrustedWriteFile :: FilePath -> String -> m ()

class EntropyIO (m :: Type -> Type) (entropy :: Type) where
    genEntropyPool :: m entropy

-- | Generate random numbers. Important that the random number is samples only using
-- things inside of the enclave
class RandomIO (m :: Type -> Type) where
    type Gen m
    newGen :: m (Gen m)
    splitGen :: Gen m -> m (Gen m, Gen m)
    uniFromGen :: (Int, Int) -> Gen m -> m (Int, Gen m)
