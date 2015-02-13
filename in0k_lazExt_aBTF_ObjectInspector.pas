{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit in0k_lazExt_aBTF_ObjectInspector;

interface

uses
  in0k_lazExt_aBTF_ObjectInspector_REG, lazExt_aBTF_ObjectInspector, 
  lazExt_aBTF_ObjectInspector_DEBUG, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('in0k_lazExt_aBTF_ObjectInspector_REG', 
    @in0k_lazExt_aBTF_ObjectInspector_REG.Register);
end;

initialization
  RegisterPackage('in0k_lazExt_aBTF_ObjectInspector', @Register);
end.
