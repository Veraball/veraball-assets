; --------------------------------
; Name and file
  Name "Veraball"
  VIProductVersion "0.1.0.0"
  OutFile "..\..\..\veraball-releases\windows\veraball-installer.exe"
  VIAddVersionKey "OriginalFilename" $OutFile
; --------------------------------
; Installer information
  VIAddVersionKey "ProductName" "Veraball Installer"
  VIAddVersionKey "FileDescription" "Veraball Installer"
  VIAddVersionKey "CompanyName" "Calinou and contributors"
  VIAddVersionKey "LegalCopyright" "2015 Calinou and contributors"
  VIAddVersionKey "FileVersion" "0.1.0.0"
  BrandingText "Veraball Installer" ; Change the branding from NSIS version to Veraball Team
; --------------------------------
; General
  ; Include Modern UI
  !include "MUI2.nsh"

  SetCompressor lzma
  SetCompressorDictSize 96
  SetDatablockOptimize on

  SetDateSave off ; Installed files will show the date they were installed instead of when they were created in git

  InstallDir "$PROGRAMFILES\Veraball" ; Default installation folder
  InstallDirRegKey HKLM "Software\Veraball" "Install_Dir" ; Get installation folder from registry if available

  ; Request the most privileges user can get
  RequestExecutionLevel admin

  !define MUI_ICON "veraball.ico" ; Use RE icon for installer.
  !define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico" ; Don't use RE icon so uninstaller isn't mistaken for game.
  Icon "veraball.ico"
  UninstallIcon "veraball.ico"

  AutoCloseWindow false ; Do not close the Finish page automatically
  !define MUI_FINISHPAGE_NOREBOOTSUPPORT ; Do not need to reboot to install Veraball
  !define MUI_ABORTWARNING ; Warn if aborting installer

  ; All pages
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "header.bmp"
; --------------------------------
; Pages
   ; Run game after install checkbox
    !define MUI_FINISHPAGE_RUN "$INSTDIR\veraball.exe"
    !define MUI_FINISHPAGE_RUN_TEXT "Run Veraball"

  !define MUI_COMPONENTSPAGE_SMALLDESC
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES

  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH
; --------------------------------
; Compute Estimated Size for Add/Remove Programs
  !define ARP "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball"
  !include "FileFunc.nsh"
; --------------------------------
; Installer Sections
Section "Veraball (required)" GameFiles

  SectionIn RO

  SetOutPath $INSTDIR

  File /r "..\..\..\veraball-releases\windows\Veraball\*.*"

  WriteRegStr HKLM "SOFTWARE\Veraball" "Install_Dir" "$INSTDIR"

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball" "DisplayName" "Veraball"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball" "DisplayVersion" "0.1.0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball" "DisplayIcon" "$INSTDIR\misc\veraball.ico"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball" "Publisher" "Calinou and contributors"

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball" "InstallSource" "http://veraball.github.io"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball" "InstallLocation" "$INSTDIR"

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball" "HelpLink" "http://veraball.github.io"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball" "URLInfoAbout" "http://veraball.github.io"

  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball" "NoRepair" 1
  WriteUninstaller "uninstall.exe"

  ; Estimated Size for Add/Remove Programs
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "${ARP}" "EstimatedSize" "$0"

SectionEnd

Section "Start Menu Shortcuts" StartMenu

  CreateDirectory "$SMPROGRAMS\Veraball"

  SetOutPath "$INSTDIR"

  CreateShortCut "$SMPROGRAMS\Veraball\Veraball.lnk" "$INSTDIR\veraball.exe" "" "$INSTDIR\misc\veraball.ico" 0
  CreateShortCut "$SMPROGRAMS\Veraball\Uninstall Veraball.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0

SectionEnd
; --------------------------------
; Uninstaller Section
Section "Uninstall"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Veraball"
  DeleteRegKey HKLM "Software\Veraball"

  RMDir /r "$SMPROGRAMS\Veraball"
  RMDir /r "$INSTDIR"

SectionEnd
; --------------------------------
; Languages
  !insertmacro MUI_LANGUAGE "English"
  LangString DESC_GameFiles ${LANG_ENGLISH} "The Veraball game files. Required to play the game."
  LangString DESC_StartMenu ${LANG_ENGLISH} "Add shortcuts to your Start Menu"

  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${GameFiles} $(DESC_GameFiles)
    !insertmacro MUI_DESCRIPTION_TEXT ${StartMenu} $(DESC_StartMenu)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
