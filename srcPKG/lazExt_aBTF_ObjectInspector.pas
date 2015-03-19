unit lazExt_aBTF_ObjectInspector;

{$mode objfpc}{$H+}

interface

{$I in0k_lazExt_aBTF_ObjectInspector_INI.inc}

{%region --- setUp INLINE SETTINGs for Compile     ---------------- /fold}
{$undef _lazExt_aBTF_BTF_use_vclAPI_}
{$undef _lazExt_aBTF_BTF_use_lclAPI_}
{$undef _lazExt_aBTF_BTF_use_winAPI_}
//----
{$ifDef lazExt_aBTF_ObjectInspector_BTF_use_vclAPI}
    {$define _lazExt_aBTF_BTF_use_vclAPI_}
    {$undef  _lazExt_aBTF_BTF_use_lclAPI_}
    {$undef  _lazExt_aBTF_BTF_use_winAPI_}
{$endif}
{$ifDef lazExt_aBTF_ObjectInspector_BTF_use_lclAPI}
    {$undef  _lazExt_aBTF_BTF_use_vclAPI_}
    {$define _lazExt_aBTF_BTF_use_lclAPI_}
    {$undef  _lazExt_aBTF_BTF_use_winAPI_}
{$endif}
{$ifDef lazExt_aBTF_ObjectInspector_BTF_use_winAPI}
    {$undef  _lazExt_aBTF_BTF_use_vclAPI_}
    {$undef  _lazExt_aBTF_BTF_use_lclAPI_}
    {$define _lazExt_aBTF_BTF_use_winAPI_}
{$endif}
//----
{$ifDef lazExt_aBTF_ObjectInspector_EventLOG_mode}
    {$define _EventLOG_}
{$else}
    {$undef  _EventLOG_}
{$endIf}
{$define _INLINE_}
{%endRegion}
{%region --- Hint about Global SETTINGs on Compile ---------------- /fold}
{$hint 'SETTINGs info: ---------------------------->>>'}
{$ifDef lazExt_aBTF_ObjectInspector_EventLOG_mode}
    {$hint 'lazExt_aBTF_ObjectInspector_EventLOG_mode On'}
{$else}
    {$hint 'lazExt_aBTF_ObjectInspector_EventLOG_mode OFF'}
{$endif}
{$ifDef lazExt_aBTF_ObjectInspector_Auto_SHOW}
    {$hint 'lazExt_aBTF_ObjectInspector_Auto_SHOW On'}
{$else}
    {$hint 'lazExt_aBTF_ObjectInspector_Auto_SHOW OFF'}
{$endif}
//---
{$ifDef _lazExt_aBTF_BTF_use_winAPI_}
    {$hint 'lazExt_aBTF_CodeExplorer_WinAPI_mode On'}
{$endif}
{$ifDef _lazExt_aBTF_BTF_use_lclAPI_}
    {$hint 'lazExt_aBTF_CodeExplorer_lclAPI_mode On'}
{$endif}
{$ifDef _lazExt_aBTF_BTF_use_vclAPI_}
    {$hint 'lazExt_aBTF_CodeExplorer_vclAPI_mode On'}
{$endif}

{$hint '<<<---------------------------------------->>>'}
{%endRegion}

uses {$ifDEF lazExt_aBTF_ObjectInspector_EventLOG_mode}
        Dialogs, lazExt_aBTF_ObjectInspector_DEBUG,
     {$endIf}
     {$ifDef  _lazExt_aBTF_BTF_use_winAPI_}
        windows,
     {$endIf}
     ObjectInspector,
     FormEditingIntf,
     LCLType, PropEdits,
     Classes, Forms;

type

 tLazExt_aBTF_ObjectInspector=class
  {%region -- _SETzOrder_ - реализация методов расстановки окон --- /fold}
  strict private //<
    {$if defined(_lazExt_aBTF_BTF_use_vclAPI_)}
    function _SETzOrder_vclAPI_(const wndTOP,wndNXT:TCustomForm):boolean; inline;
    {$elseif defined(_lazExt_aBTF_BTF_use_lclAPI_)}
    function _SETzOrder_lclAPI_(const wndTOP,wndNXT:TCustomForm):boolean; inline;
    {$elseif defined(_lazExt_aBTF_BTF_use_winAPI_)}
    function _SETzOrder_winAPI_(const wndTOP,wndNXT:TCustomForm):boolean; inline;
    {$else}
        {$ERROR "method `_sendToUNDER_xxx_` unDefined"}
    {$endif}
  protected //< основной вызов, в котором идет выбор реализации
    function _SETzOrder_(const wndTOP,wndNXT:TCustomForm):boolean;
  {%endregion}
  {%region -- _wndDSGNR_  - окно "под дизайнером" ----------------- /fold}
  strict private
   _wndDSGNR_:TCustomForm; //< текущая форма "подДизайнерингом"
  strict private //< подмена аля "СабКлассинг"
   _wndDSGNR_onActivate_original_:TNotifyEvent;
    procedure _wndDSGNR_onActivate_myCustom_(Sender:TObject);
    procedure _wndDSGNR_rePlace_onActivate_ (const wnd:TCustomForm);
    procedure _wndDSGNR_reStore_onActivate_ (const wnd:TCustomForm);
  strict private //< подмена аля "СабКлассинг"
   _wndDSGNR_onDestroy_original_:TNotifyEvent;
    procedure _wndDSGNR_onDestroy_myCustom_ (Sender:TObject);
    procedure _wndDSGNR_rePlace_onDestroy_  (const wnd:TCustomForm);
    procedure _wndDSGNR_reStore_onDestroy_  (const wnd:TCustomForm);
  strict private
    procedure _wndDSGNR_rePlace_(const wnd:TCustomForm);
    procedure _wndDSGNR_reStore_(const wnd:TCustomForm);
  protected //<
    procedure _wndDSGNR_SET_(const DSGNR:TCustomForm);
    procedure _wndDSGNR_CLR_;
  {%endregion}
  {%region -- _wndOInsp_  - Окно "Object Inspector" --------------- /fold}
  strict private
   _wndOInsp_:TCustomForm; //< "закешированное" окно, если оно ЕСТЬ => autoShow НЕ должно работать
    procedure _wndOInsp_CLR_;
  strict private
    function  _wndOInsp_find_inSCREEN_:TCustomForm;
    function  _wndOInsp_prepare_:TCustomForm;
  private
    function  _wndOInsp_GET:TCustomForm;
  {%endRegion}
  {%region --- ВСЯ СУТь ------------------------------------------- /fold}
  protected
    function _do_BTF_ObjectInspector_(const wndDSGNR:TCustomForm):boolean;
  {%endRegion}
  {%region --- ide_Window_CEV : API_004 --------------------------- /fold}
  {$ifDef _lazExt_aBTF_CodeExplorer_API_004_}
  strict private
   _ide_Window_OIV_:tForm;                        //< найденное окно
   _ide_Window_OIV_onClose_original_:TCloseEvent; //< его событие при выходе
    procedure _OIV_onClose_myCustom_(Sender:TObject; var CloseAction:TCloseAction);
    procedure _OIV_rePlace_onClose(const wnd:tForm);
    procedure _OIV_reStore_onClose(const wnd:tForm);
  private
    procedure _CEV_SET_(const wnd:tForm);
  {$endIf}
  {%endRegion}
  public
    constructor Create;
    destructor DESTROY; override;
  public
    procedure _ideEvent_ChangeLookupRoot_;
    procedure RegisterInIdeLAZARUS;
  end;

implementation

{$ifDEF _EventLOG_}
const
   _cPleaseReport_=
        LineEnding+
        'EN: Please report this error to the developer.'+LineEnding+
        'RU: Пожалуйста, сообщите об этой ошибке разработчику.'+
        LineEnding;
{$endIf}

constructor tLazExt_aBTF_ObjectInspector.Create;
begin
   _wndDSGNR_CLR_
end;

destructor tLazExt_aBTF_ObjectInspector.DESTROY;
begin
    inherited;
end;

//------------------------------------------------------------------------------

procedure tLazExt_aBTF_ObjectInspector.RegisterInIdeLAZARUS;
begin
    GlobalDesignHook.AddHandlerChangeLookupRoot(@_ideEvent_ChangeLookupRoot_);
end;

//------------------------------------------------------------------------------

{%region --- _SETzOrder_ ------------------------------------------ /fold}

//---
// выстраивание окон в определенном Z порядкЕ. В резУльтате должно получится
//  wndTOP - на самом верху (по идее оно там и лежит)
//  wndNXT - сразу под окном wndTOP
//--- !!! ---
// корректность вызова (входных параметров)
// ДОЛЖНА проверяется в ВЫЗЫВАЮЩЕЙ процедуре
//---

{$ifDef _lazExt_aBTF_BTF_use_vclAPI_}
function tLazExt_aBTF_ObjectInspector._SETzOrder_vclAPI_(const wndTOP,wndNXT:TCustomForm):boolean;
begin
   // без заморочек, тупо с морганием
   wndNXT.BringToFront;
   wndTOP.BringToFront;
   result:=true;
end;
{$endIf}

{$ifDef _lazExt_aBTF_BTF_use_lclAPI_}
function tLazExt_aBTF_ObjectInspector._SETzOrder_lclAPI_(const wndTOP,wndNXT:TCustomForm):boolean;
begin
    {$error "method unDefined"}
    {todo: реализовать по аналогии с BringToFront, теми же методами}
    result:=false;
end;
{$endIf}

{$ifDef _lazExt_aBTF_BTF_use_winAPI_}
function tLazExt_aBTF_ObjectInspector._SETzOrder_winAPI_(const wndTOP,wndNXT:TCustomForm):boolean;
var dwp:HDWP;
begin // используем реальный WIN API инструментарий
    dwp:=BeginDeferWindowPos(1);
    DeferWindowPos(dwp,wndNXT.Handle,wndTOP.Handle,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
    result:=EndDeferWindowPos(dwp);
end;
{$endIf}

//------------------------------------------------------------------------------

// разместить окна по Z порядку: wndNXT сразу под wndTOP
function tLazExt_aBTF_ObjectInspector._SETzOrder_(const wndTOP,wndNXT:TCustomForm):boolean;
begin // корректность вызова (входных параметров)
      // ДОЛЖНА проверяется в ВЫЗЫВАЮЩЕЙ процедуре
    {$if     defined(_lazExt_aBTF_BTF_use_vclAPI_)}
    result:=_SETzOrder_vclAPI_(wndTOP,wndNXT);
    {$elseif defined(_lazExt_aBTF_BTF_use_lclAPI_)}
    result:=_SETzOrder_lclAPI_(wndTOP,wndNXT);
    {$elseif defined(_lazExt_aBTF_BTF_use_winAPI_)}
    result:=_SETzOrder_winAPI_(wndTOP,wndNXT);
    {$else}
      result:=false;
      {$ERROR "method `_sendToUNDER_xxx_` unDefined"}
    {$endif}
    //------
    {$ifDEF _EventLOG_}
    if result then DEBUG('_SETzOrder_','OK '+'wndTOP'+addr2txt(wndTOP)+' wndNXT'+addr2txt(wndTOP))
              else DEBUG('_SETzOrder_','ER '+'wndTOP'+addr2txt(wndTOP)+' wndNXT'+addr2txt(wndTOP));
    {$endIf}
end;

{%endRegion}

{%region --- _wndDSGNR_  ------------------------------------------ /fold}

// _wndDSGNR_ - текущее окно под "дизайнерингом"
//  первый вход обнаруживается в событии `_ideEvent_ChangeLookupRoot_`
//
//  Для обнаружение перевода фокуса в окно реализуем "СабКлассинг" на уровне
//  событий:
//    onActivate - окно получает фокус и надо выполнить `_do_BTF_ObjectInspector_`
//    onDestroy  - окно УНИЧТОЖАЕТСЯ и надо убрать "СабКлассинг"


{$ifDEF _EventLOG_}
const
   _cTXT_wndEVENT         = 'wndEVENT';
   _cTXT_wndDSGNR         = 'wndDSGNR';
   _cTXT_wndDSGNR_rePALCE_='_wndDSGNR_rePALCE_';
   _cTXT_wndDSGNR_reSTORE_='_wndDSGNR_reSTORE_';
{$endIf}

//------------------------------------------------------------------------------

{%region ----- _wndDSGNR_onActivate_ -------------------- /fold}

// подмена стандартному событию
procedure tLazExt_aBTF_ObjectInspector._wndDSGNR_onActivate_myCustom_(Sender:TObject);
begin
    {$ifDEF _EventLOG_}
    DEBUG(_cTXT_wndEVENT,_cTXT_wndDSGNR+'.onActivate'+'------------>>>>>'+' Sender'+addr2txt(Sender));
    {$endIf}

    //--- выполняем то что ДОЛЖНО было быть выполнено
    if Assigned(_wndDSGNR_onActivate_original_) then begin
       _wndDSGNR_onActivate_original_(sender);
        {$ifDEF _EventLOG_}
        DEBUG('DSGNR','onActivate_original');
        {$endIf}
    end;
    //--- собственная добавка
    if Sender is TCustomForm then begin
       _do_BTF_ObjectInspector_(TCustomForm(Sender));
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG('skip','Sender is not TCustomForm');
        {$endIf}
    end;

    {$ifDEF _EventLOG_}
    DEBUG(_cTXT_wndEVENT,_cTXT_wndDSGNR+'.onActivate'+'------------<<<<<'+' Sender'+addr2txt(Sender));
    {$endIf}
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure tLazExt_aBTF_ObjectInspector._wndDSGNR_rePlace_onActivate_(const wnd:TCustomForm);
begin
    if Assigned(wnd) and (wnd.OnActivate<>@_wndDSGNR_onActivate_myCustom_) then begin
       _wndDSGNR_onActivate_original_:=wnd.OnActivate;
        wnd.OnActivate:=@_wndDSGNR_onActivate_myCustom_;
        {$ifDEF _EventLOG_}
        DEBUG(_cTXT_wndDSGNR_rePALCE_+'_onActivate_','wnd'+addr2txt(wnd)+' '+mthd2txt(@_wndDSGNR_onActivate_original_)+'->'+mthd2txt(@wnd.OnActivate));
        {$endIf}
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG(_cTXT_wndDSGNR_rePALCE_+'_onActivate_','SKIP wnd'+addr2txt(wnd)+' now'+mthd2txt(@wnd.OnActivate));
        {$endIf}
    end
end;

procedure tLazExt_aBTF_ObjectInspector._wndDSGNR_reStore_onActivate_(const wnd:TCustomForm);
begin
    if Assigned(wnd) and (wnd.OnActivate=@_wndDSGNR_onActivate_myCustom_) then begin
        {$ifDEF _EventLOG_}
        DEBUG(_cTXT_wndDSGNR_reSTORE_+'_onActivate_','wnd'+addr2txt(wnd)+' '+mthd2txt(@wnd.OnActivate)+'->'+mthd2txt(@_wndDSGNR_onActivate_original_));
        {$endIf}
        wnd.OnActivate:=_wndDSGNR_onActivate_original_;
       _wndDSGNR_onActivate_original_:=NIL;
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG(_cTXT_wndDSGNR_reSTORE_+'_onActivate_','SKIP wnd'+addr2txt(wnd)+' now'+mthd2txt(@wnd.OnActivate));
        {$endIf}
    end;
end;

{%endregion}

{%region ----- _wndDSGNR_onDestroy_  -------------------- /fold}

procedure tLazExt_aBTF_ObjectInspector._wndDSGNR_onDestroy_myCustom_(Sender:TObject);
begin
    {$ifDEF _EventLOG_}
    DEBUG(_cTXT_wndEVENT,_cTXT_wndDSGNR+'.onDestroy'+'------------>>>>>'+' Sender'+addr2txt(Sender));
    {$endIf}

    if Sender is TCustomForm then begin
        //--- собственная добавка
        if Sender=_wndDSGNR_ then _wndDSGNR_reStore_(TCustomForm(Sender))
        else begin
            {$ifDEF _EventLOG_}
            DEBUG('warning','------------<<<<<'+' Sender'+addr2txt(Sender)+'<>_wndDSGNR_'+addr2txt(_wndDSGNR_));
            {$endIf}
        end;
       _wndDSGNR_CLR_;
        //--- выполняем то что ДОЛЖНО было быть выполнено
        if Assigned(TCustomForm(Sender).OnDestroy) then begin
            TCustomForm(Sender).OnDestroy(Sender)
        end;
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG('skip','Sender is not TCustomForm');
        {$endIf}
    end;

    {$ifDEF _EventLOG_}
    DEBUG(_cTXT_wndEVENT,_cTXT_wndDSGNR+'.onDestroy'+'------------<<<<<'+' Sender'+addr2txt(Sender));
    {$endIf}
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure tLazExt_aBTF_ObjectInspector._wndDSGNR_rePlace_onDestroy_(const wnd:TCustomForm);
begin
    if Assigned(wnd) and (wnd.OnDestroy<>@_wndDSGNR_onDestroy_myCustom_) then begin
       _wndDSGNR_onDestroy_original_:=wnd.OnDestroy;
        wnd.OnDestroy:=@_wndDSGNR_onDestroy_myCustom_;
        {$ifDEF _EventLOG_}
        DEBUG(_cTXT_wndDSGNR_rePALCE_+'_onDestroy_','wnd'+addr2txt(wnd)+' '+mthd2txt(@_wndDSGNR_onDestroy_original_)+'->'+mthd2txt(@wnd.OnDestroy));
        {$endIf}
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG(_cTXT_wndDSGNR_rePALCE_+'_onDestroy_','SKIP wnd'+addr2txt(wnd)+' now'+mthd2txt(@wnd.OnDestroy));
        {$endIf}
    end
end;

procedure tLazExt_aBTF_ObjectInspector._wndDSGNR_reStore_onDestroy_(const wnd:TCustomForm);
begin
    if Assigned(wnd) and (wnd.OnDestroy=@_wndDSGNR_onDestroy_myCustom_) then begin
        {$ifDEF _EventLOG_}
        DEBUG(_cTXT_wndDSGNR_reSTORE_+'_onDestroy_','wnd'+addr2txt(wnd)+' '+mthd2txt(@wnd.OnDestroy)+'->'+mthd2txt(@_wndDSGNR_onDestroy_original_));
        {$endIf}
        wnd.OnDestroy:=_wndDSGNR_onDestroy_original_;
       _wndDSGNR_onDestroy_original_:=NIL;
    end
    else begin
        {$ifDEF _EventLOG_}
        DEBUG(_cTXT_wndDSGNR_reSTORE_+'_onDestroy_','SKIP wnd'+addr2txt(wnd)+' now'+mthd2txt(@wnd.OnDestroy));
        {$endIf}
    end;
end;

{%endregion}

//------------------------------------------------------------------------------

procedure tLazExt_aBTF_ObjectInspector._wndDSGNR_rePlace_(const wnd:TCustomForm);
begin
    {$ifDEF _EventLOG_}
    DEBUG(_cTXT_wndDSGNR_rePALCE_,'wnd'+addr2txt(wnd)+'-------------->');
    {$endIf}
   _wndDSGNR_rePlace_onActivate_(wnd);
   _wndDSGNR_rePlace_onDestroy_ (wnd);
    {$ifDEF _EventLOG_}
    DEBUG(_cTXT_wndDSGNR_rePALCE_,'wnd'+addr2txt(wnd)+'--------------<');
    {$endIf}
end;

procedure tLazExt_aBTF_ObjectInspector._wndDSGNR_reStore_(const wnd:TCustomForm);
begin
    {$ifDEF _EventLOG_}
    DEBUG(_cTXT_wndDSGNR_reSTORE_,'wnd'+addr2txt(wnd)+'-------------->');
    {$endIf}
   _wndDSGNR_reStore_onDestroy_ (wnd);
   _wndDSGNR_reStore_onActivate_(wnd);
    {$ifDEF _EventLOG_}
    DEBUG(_cTXT_wndDSGNR_reSTORE_,'wnd'+addr2txt(wnd)+'--------------<');
    {$endIf}
end;

//------------------------------------------------------------------------------

procedure tLazExt_aBTF_ObjectInspector._wndDSGNR_SET_(const DSGNR:TCustomForm);
begin
    if _wndDSGNR_<>DSGNR then begin
        if Assigned(_wndDSGNR_) then begin
           _wndDSGNR_reStore_(_wndDSGNR_);
           _wndDSGNR_CLR_;
        end;
       _wndDSGNR_:=DSGNR;
        if Assigned(_wndDSGNR_) then begin
           _wndDSGNR_rePlace_(_wndDSGNR_);
        end;
    end;
end;

procedure tLazExt_aBTF_ObjectInspector._wndDSGNR_CLR_;
begin
   _wndDSGNR_:=nil;
   _wndDSGNR_onActivate_original_:=nil;
   _wndDSGNR_onDestroy_original_ :=nil;
end;

{%endRegion}

{%region --- _wndOInsp_  ------------------------------------------ /fold}

procedure tLazExt_aBTF_ObjectInspector._wndOInsp_CLR_;
begin
   _wndOInsp_:=nil;
end;

//------------------------------------------------------------------------------

type //< тут возможно придется определять относительно ВЕРСИИ ЛАЗАРУСА
  _cOInsp_ObjectInspector_TFormClass_=TObjectInspectorDlg;

// исчем экземпляр окна в массиве Screen.Forms
//  поиск по типу!
function tLazExt_aBTF_ObjectInspector._wndOInsp_find_inSCREEN_:TCustomForm;
var i:integer;
    f:TForm;
begin
    result:=nil;
    for i:=0 to Screen.FormCount-1 do begin
        f:=Screen.Forms[i];
        if f is _cOInsp_ObjectInspector_TFormClass_ then begin
            result:=f;
            break;
        end;
    end;
    {$ifDEF _EventLOG_}
    if Assigned(result)
    then DEBUG('_wndOInsp_find_inSCREEN_','FOUND '+_cOInsp_ObjectInspector_TFormClass_.ClassName+addr2txt(result))
    else DEBUG('_wndOInsp_find_inSCREEN_','NOT found');
    {$endIf}
end;

//------------------------------------------------------------------------------

function tLazExt_aBTF_ObjectInspector._wndOInsp_prepare_:TCustomForm;
begin
    result:=_wndOInsp_find_inSCREEN_;
    {$ifDef lazExt_aBTF_ObjectInspector_Auto_SHOW}
    // суда мы попадем тока в случае ОТСУТСТВИЯ кешированной ссылки на
    // окно ObjectInspector, это означает что была смена она "подДизайнерингом"
    // и следовательно процедуру АВТОпоказа можно запускать
    if not Assigned(result) then begin
        // надо сказать программисту, чтоб он сообщил разработчику (т.е. мне),
        // что тут ОГРОМНЫЙ косячек, и теперь надо реализовывать вызов IDE
        // комманды для показа ObjectInspector
        {$ifDEF _EventLOG_}
        DEBUG('ERROR','Window "Object Inspector" NOT FOUND');
        ShowMessage('Window "Object Inspector" NOT FOUND!'+LineEnding+
                    'Package "LazExt_aBTF_ObjectInspector" useless. :-('+LineEnding+
                    'Uninstall it'+
                   _cPleaseReport_);
        {$endIf}
    end;
    if Assigned(result)and(not result.Visible) then begin
        result.SendToBack;
        result.show;
    end;
    {$endIf}
end;

//------------------------------------------------------------------------------

function tLazExt_aBTF_ObjectInspector._wndOInsp_GET:TCustomForm;
begin
    if not Assigned(_wndOInsp_) then begin
       _wndOInsp_:=_wndOInsp_prepare_;
    end;
    result:=_wndOInsp_;
end;

{%endRegion}

//------------------------------------------------------------------------------

procedure tLazExt_aBTF_ObjectInspector._ideEvent_ChangeLookupRoot_;
var tmp:TPersistent;
    wnd:TCustomForm;
begin
    {$ifDEF _EventLOG_}
    DEBUG('ideEvent','ChangeLookupRoot -------------------------------->>>>>');
    {$endIf}
    tmp:=GlobalDesignHook.LookupRoot;
    if Assigned(tmp) then begin
        wnd:=FormEditingHook.GetDesignerForm(tmp);
        if Assigned(wnd) then begin
           _wndDSGNR_SET_(wnd);
           _wndOInsp_CLR_; //< чтобы срабатывал механизм АВТОПОКАЗА
           _do_BTF_ObjectInspector_(wnd);
        end;
    end;
    {$ifDEF _EventLOG_}
    DEBUG('ideEvent','ChangeLookupRoot --------------------------------<<<<<');
    {$endIf}
end;

//------------------------------------------------------------------------------

{%region --- ВСЯ СУТь --------------------------------------------- /fold}

{ Целевая процедура этого компoнента.
    Все что тут написано работает ради того чтобы запустить эту процедуру.
    @prm wndDSGNR окно которое в данный момент "находится под дизайнером".
    @ret признак успешного выполнения
}
function tLazExt_aBTF_ObjectInspector._do_BTF_ObjectInspector_(const wndDSGNR:TCustomForm):boolean;
var wndOInsp:TCustomForm;
begin // wndDSGNR.Visible=true -- НАДУМАННАЯ проверка, так для общности
    {$ifDEF _EventLOG_}
    DEBUG('do_BTF_OI_EXECUTE','------------------------->>>>>');
    {$endIf}
    if Assigned(wndDSGNR) then begin
        wndOInsp:=_wndOInsp_GET; //< получаем ссылку на экземпляр
        if Assigned(wndOInsp) and (wndOInsp.Visible)
        then begin //< все проверки пройденны, можно начинать
            result:=_SETzOrder_(wndDSGNR,wndOInsp);
            {$ifDEF _EventLOG_}
            if result then DEBUG('OK','wndDSGNR'+addr2txt(wndDSGNR)+' wndOInsp'+addr2txt(wndOInsp))
                      else DEBUG('ER','wndDSGNR'+addr2txt(wndDSGNR)+' wndOInsp'+addr2txt(wndOInsp))
            {$endIf}
        end
        else begin
            {$ifDEF _EventLOG_}
            if not Assigned(wndOInsp)
            then DEBUG('SKIP','wndOInsp is NULL')
           else
            if not wndOInsp.Visible
            then DEBUG('SKIP','wndOInsp Visible=false')
           else
            begin
                 DEBUG('SKIP','wndOInsp cause is unknown')
            end;
            {$endIf}
        end;
    end
    else begin
        {$ifDEF _EventLOG_}
        if not Assigned(wndDSGNR)
        then DEBUG('SKIP','wndDSGNR is NULL')
       else
        begin
             DEBUG('SKIP','wndDSGNR cause is unknown')
        end;
        {$endIf}
    end;
    {$ifDEF _EventLOG_}
    DEBUG('do_BTF_OI_EXECUTE','-------------------------<<<<<');
    {$endIf}
end;

{%endRegion}

end.
