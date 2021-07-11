{ pkgs }:
{
  wrapLua = lua: ''
    lua << EOF
      ${lua}
    EOF
  '';
}
