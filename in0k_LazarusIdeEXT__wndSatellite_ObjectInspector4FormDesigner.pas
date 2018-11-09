{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit in0k_LazarusIdeEXT__wndSatellite_ObjectInspector4FormDesigner;

{$warn 5023 off : no warning about unused units}
interface

uses
  in0k_LazarusIdeEXT__REGISTER, 
  in0k_lazarusIdePLG__wndSatellite_ObjectInspector4FormDesigner, 
  in0k_lazarusIdeSRC__expertCORE, in0k_lazarusIdeSRC__wndDEBUG, 
  in0k_lazarusIdeSRC__fuckUp_onActivate, 
  in0k_lazarusIdeSRC__ideForm_ObjectInspector, in0k_lazarusIdeSRC__B2SP, 
  in0k_bringToSecondPlane_LazLCL, in0k_bringToSecondPlane_WinAPI, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('in0k_LazarusIdeEXT__REGISTER', 
    @in0k_LazarusIdeEXT__REGISTER.Register);
end;

initialization
  RegisterPackage('in0k_LazarusIdeEXT__wndSatellite_ObjectInspector4'
    +'FormDesigner', @Register);
end.
