# PSAppDeployToolkit Deploy-Application.ps1 Scripts

Deployments Scripts using the [PowerShell App Deployment Toolkit](https://psappdeploytoolkit.com/).

## SFX Build

*Self-extracting archives (briefly referred as SFX files) are computer executable programs containing both an (usually compressed) archive of files and the routines needed to extract the content (SFX module), usually packed as Microsoft Windows EXE executable file.*

The ``sfx_build.bat`` script creates a self extracting archive containing the contents of ``Toolkit`` directory from PSAppDeployToolkit, the ``Deploy-Application.ps1`` specific from the application that are being deployed and the files listed at ``sfx_listfiles.txt``.

The ``sfx_build.bat`` script uses SFX module for installers (``7zSD.sfx``) that allows you to create your own installation program. Such a module extracts the archive to the user's temp folder, and runs a specified program, and removes the temp files after the program finishes. Parameters could be passed to the ``Deploy-Application.exe`` exe from self extract exe (``[ApplicationName]_sfx_setup.exe``) without any changes to config file.

The objective of ``sfx_build.bat`` script is create a SFX installer that extracts and automatically runs ``Deploy-Application.exe`` file from PSAppDeployToolkit aiming the creation of an "all-in-one" installer for deployment tasks through FusionInventory or other deployment tools.

### SFX Build Variables

You need to edit the ``sfx_build.bat`` script itself to adapt it to your environment. The following variables should be changed:

Variable            | Description
-----------------   | -----------
``PSAppDeployPath`` | The folder that contains the PSAppDeployToolkit.
``SEVENZPath``      | The folder that contains the 7-Zip (7z.exe) executable. You can download any versions of 7-Zip (including latest beta versions) from: https://www.7-zip.org/download.html
``SEVENZSFXPath``   | The folder that contains the SFX module for installers (7zSD.sfx) file. Acquiring the ``7zSD.sfx`` stuffs is easy: The installers are on the [official download page](https://www.7-zip.org/download.html). Just look for keyword **7-Zip Extra**. Version 9.20 for example is https://www.7-zip.org/a/7z920_extra.7z

### SFX Build Example

```
C:/
├─ Applications/
│  ├─ 7zSD.sfx
│  ├─ sfx_build.bat
│  ├─ sfx_config.txt
│  ├─ 7-Zip/
│  │  ├─ 7z1900.msi
│  │  ├─ 7z1900-x64.msi
│  │  ├─ 7-Zip_Customizations.mst
│  │  ├─ Deploy-Application.ps1
│  │  ├─ sfx_listfile.txt
│  │  ├─ sfx_config.txt
```

In the example scenario above, execute the ``sfx_build.bat`` with the following commands:

```
cd /d C:\Applications
"C:\Applications\sfx_build.bat" "C:\Applications\7-Zip\"
```

The ``sfx_build.bat`` will do as following:

1. The ``sfx_build.bat`` copies the contents from ``Toolkit`` folder (``%PSAppDeployPath%\Toolkit``) to the ``%TEMP%\bat~%RANDOM%`` folder.

2. After that, the ``sfx_build.bat`` script parses ``C:\Applications\7-Zip\sfx_listfile.txt`` contents:

```
"Deploy-Application.ps1" "Deploy-Application.ps1"
"7z1900.msi" "Files/7z1900.msi"
"7z1900-x64.msi" "Files/7z1900-x64.msi"
"7-Zip_Customizations.mst" "Files/7-Zip_Customizations.mst"
```

This file specifies which file should be copied to ``%PSAppDeployPath%\Toolkit`` and which location it should be placed. The ``sfx_listfile.txt`` content above will be parsed as:

```
copy /y "C:\Applications\7-Zip\Deploy-Application.ps1" "%TEMP%\bat~%RANDOM%\Deploy-Application.ps1"
copy /y "C:\Applications\7-Zip\7z1900.msi" "%TEMP%\bat~%RANDOM%\Files\7z1900.msi"
copy /y "C:\Applications\7-Zip\7z1900-x64.msi" "%TEMP%\bat~%RANDOM%\Files\7z1900-x64.msi"
copy /y "C:\Applications\7-Zip\7-Zip_Customizations.mst" "%TEMP%\bat~%RANDOM%\Files\7-Zip_Customizations.mst"
```

Please note that absolute paths are also supported, e.g. if the line ``"Z:\7-Zip_Customizations.mst" "Files/7-Zip_Customizations.mst"`` is set into ``sfx_listfile.txt``, it will be parsed as ``copy "Z:\7-Zip_Customizations.mst" "%TEMP%\bat~%RANDOM%\Files\7-Zip_Customizations.mst"``.

3. Now the script will compress the contents to ``%TEMP%\bat~%RANDOM%`` to ``"C:\Applications\7-Zip\7-zip.7z"``.

4. After that, the script will create the SFX file by concatenating these three files:

- ``"C:\Application\7zSD.sfx"``
- ``"C:\Application\7-Zip\sfx_config.txt"``
- ``"C:\Application\7-Zip\7-zip.7z"``

The file ``"C:\Application\7-Zip\sfx_config.txt"`` allows to create a SFX installer with a [Custom Installer config file](https://sevenzip.osdn.jp/chm/cmdline/switches/sfx.htm).

If ``"C:\Application\7-Zip\sfx_config.txt"`` doesn't exists, the script will attempt to use a general ``sfx_config.txt`` file available at the same location of ``sfx_build.bat`` script. If none of these files exists, the script will fail.
