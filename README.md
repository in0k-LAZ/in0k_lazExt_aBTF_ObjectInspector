Описание
========

**Пакет расширение Lazarus IDE**: перемещение на "передний" план окна ["Object Inspector"](http://wiki.freepascal.org/IDE_Window:_Object_Inspector) при переходе в окно ["Form Editor"](http://wiki.freepascal.org/IDE_Window:_Form_Editor).

##Использование

Допустим, работая в окне **"Source Editor"** и имея расположение окон 

![рис. 1](https://github.com/in0k-LAZ/in0k_lazExt_aBTF_ObjectInspector/blob/master/aBTF_FormEditor_ObjectInspector_FROM.png)

нажав клавишу **F12**, для перехода в режим редактирования формы, получим следующую картинку

![рис. 2](https://github.com/in0k-LAZ/in0k_lazExt_aBTF_ObjectInspector/blob/master/aBTF_FormEditor_ObjectInspector.png)

где:

1. окно "Form Editor" получившее фокус
2. окно "Object Inspector" автоматически перемещенное на "передний" план.

## Настройка и установка

1. Скопировать исходники в любую удобную директорию `<$someDir>`.
2. Открыть файл `<$someDir>/in0k_lazExt_aBTF_ObjectInspector.lpk` в **Lazarus IDE**.
3. Настроить редактируя файл `<$someDir>/in0k_lazext_abtf_objectinspector_ini.inc`.
4. Скомпилировать и установить пакет.

*замечания*: подробно про установку пакетов должно быть написано [тут](http://wiki.freepascal.org/Install_Packages). 

