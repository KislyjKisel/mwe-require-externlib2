import Lake
open Lake DSL

package «b» where
  -- add package configuration options here

lean_lib «B» where
  -- add library configuration options here

@[default_target]
lean_exe «b» where
  root := `Main

target ffi.o pkg : FilePath := do
  let oFile := pkg.buildDir / "c" / "ffi.o"
  let srcJob <- inputFile <| pkg.dir / "ffi.c"
  let weakArgs := #["-I", (<- getLeanIncludeDir).toString]
  buildO oFile srcJob weakArgs #["-fPIC"] "cc" getLeanTrace

extern_lib libleanffib pkg := do
  let ffiO <- ffi.o.fetch
  let name := nameToStaticLib "leanffib"
  buildStaticLib (pkg.nativeLibDir / name) #[ffiO]
