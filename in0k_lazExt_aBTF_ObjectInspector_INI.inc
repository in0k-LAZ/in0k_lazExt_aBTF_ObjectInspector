
//------------------------------------------------------------------------------
//
// Опции настройки компиляции
//
//------------------------------------------------------------------------------

// определяем режим ДЕБАГ
//  Позволяет просматривать лог событий в отдельном окне из IDE
//  View -> IDE Internals -> [eventLog] lazExt_aBTF_ObjectInspector
{.$define lazExt_aBTF_ObjectInspector_EventLOG_mode}

// АвтоOткрытие окна "Object Inspector".
{$define lazExt_aBTF_ObjectInspector_Auto_SHOW}

// Режим работы.
// ------------

// Режим работы через winApi.
//  Позволяет "вытягивать" окно CodeExplorer на ПРЕД-топ позицию, что позволяет
//  исключить мерцание окон SourceEditor.
//  Использует мотоды Windows API, поэтому в системах отличных от Windows
//  автоматически отключается (так как не тестировалась).
{$define lazExt_aBTF_ObjectInspector_BTF_use_winAPI}

// Режим работы через vclAPI.
// НЕ реализовано
{.$define lazExt_aBTF_ObjectInspector_BTF_use_vclAPI}

// Режим работы через lclAPI.
// без заморочек, тупо с морганием, через `BringToFront`.
{.$define lazExt_aBTF_ObjectInspector_BTF_use_lclAPI}



//------------------------------------------------------------------------------
//
// Тюнинг настроек в зависимости от Целевой Системы
//
//------------------------------------------------------------------------------

{$IFDEF Windows}
{$else}
    {$undef  lazExt_aBTF_ObjectInspector_BTF_use_winAPI}
    {$undef  lazExt_aBTF_ObjectInspector_BTF_use_vclAPI}
    {$define lazExt_aBTF_ObjectInspector_BTF_use_lclAPI}
{$endIf}

