unit in0k_lazExt_aBTF_ObjectInspector_REG;

{$mode objfpc}{$H+}

interface

{$I in0k_lazExt_aBTF_ObjectInspector_INI.inc}

uses {$ifDef lazExt_aBTF_ObjectInspector_EventLOG_mode}lazExt_aBTF_ObjectInspector_DEBUG,{$endIf}
     lazExt_aBTF_ObjectInspector;

procedure REGISTER;

implementation
var _aBTF_CodeExplorer_:tLazExt_aBTF_ObjectInspector;

procedure REGISTER;
begin
   _aBTF_CodeExplorer_:=tLazExt_aBTF_ObjectInspector.Create;
   _aBTF_CodeExplorer_.RegisterInIdeLAZARUS;
    {$ifDef lazExt_aBTF_ObjectInspector_EventLOG_mode}
    lazExt_aBTF_ObjectInspector_DEBUG.RegisterInIdeLAZARUS;
    {$endIf}
end;

initialization
   _aBTF_CodeExplorer_:=NIL;
finalization
   _aBTF_CodeExplorer_.FREE;
end.

