import Lake
open Lake DSL

package «b» where

input_file ffi_static.c where
  path := "ffi.c"
  text := true

target ffi.o pkg : System.FilePath := do
  let srcJob ← ffi_static.c.fetch
  let oFile := pkg.buildDir / "c" / "ffi_static.o"
  let weakArgs := #["-I", (<- getLeanIncludeDir).toString]
  buildO oFile srcJob weakArgs #["-fPIC"] "cc"

@[default_target]
extern_lib libleanffib pkg := do
  let ffiO <- ffi.o.fetch
  let name := nameToStaticLib "leanffib"
  buildStaticLib (pkg.staticLibDir / name) #[ffiO]
