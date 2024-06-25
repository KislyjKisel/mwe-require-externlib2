import Lake
open Lake DSL

package «b» where

target ffi.o pkg : FilePath := do
  let oFile := pkg.buildDir / "c" / "ffi.o"
  let srcJob <- inputFile <| pkg.dir / "ffi.c"
  let weakArgs := #["-I", (<- getLeanIncludeDir).toString]
  buildO oFile srcJob weakArgs #["-fPIC"] "cc" getLeanTrace

@[default_target]
extern_lib libleanffib pkg := do
  let ffiO <- ffi.o.fetch
  let name := nameToStaticLib "leanffib"
  buildStaticLib (pkg.nativeLibDir / name) #[ffiO]
