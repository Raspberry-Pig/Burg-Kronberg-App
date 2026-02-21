#define MyAppName "Burg Kronberg"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Burg Kronberg"
#define MyAppExeName "BurgKronberg.exe"
#define MyAppURL "https://burgkronberg.de"

[Setup]
AppId={{A4B2B86B-6C86-4D97-9B4D-6F3A58D4D1F2}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir=build\installer
OutputBaseFilename=BurgKronbergSetup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayIcon={app}\{#MyAppExeName}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppName} Installer
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}
VersionInfoCopyright=Copyright (C) 2026 {#MyAppPublisher}

; For signed installers/uninstallers (recommended):
; 1) Install a code-signing certificate in Windows cert store
; 2) Configure SignTool and remove leading semicolons.
; SignTool=signtool sign /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 /a $f
; SignedUninstaller=yes

[Languages]
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Desktop-Verknupfung erstellen"; GroupDescription: "Zusatzliche Aufgaben:"; Flags: unchecked

[Files]
; Flutter Windows build output (must contain .exe, flutter_windows.dll, data/, etc.)
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion
; Add VC++ runtime installer into setup payload.
Source: "installer\prereqs\vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; Required for VCRUNTIME*.dll on target machines without Visual C++ runtime.
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; Flags: waituntilterminated
Filename: "{app}\{#MyAppExeName}"; Description: "{#MyAppName} starten"; Flags: nowait postinstall skipifsilent
