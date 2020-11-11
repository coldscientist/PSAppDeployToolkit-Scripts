# 7-Zip Deployment Script for PSAppDeployToolkit

The ``Deploy-Application.ps1`` script deploy 7-Zip using [PSAppDeployToolkit](https://psappdeploytoolkit.com/).

The script supports the following 7-Zip previous installations scenarios:

- The script detects if an ``.exe`` 7-Zip installation type is in-place, uninstalls it and replaces it installing the specific 7-Zip MSI installation type to the OS arch (32-bit/64-bit).
- The script detects if a ``32-bit`` 7-Zip installation is in place into a Windows x64 OS, uninstalls it and replaces it installing the specific 7-Zip MSI installation type to the OS arch (32-bit/64-bit).

## File Tree

```
7-Zip/
├─ 7z1900.msi
├─ 7z1900-x64.msi
├─ 7-Zip_Customizations.mst
├─ Deploy-Application.ps1
├─ sfx_listfile.txt
```

The ``7-Zip_Customizations.mst`` file (optional - available at http://adriank.org/how-to-deploy-7-zip-9-20/) automatically associates 7-Zip with Windows file type associations to be handled by Windows Explorer.  With no .mst file, ``.7z``, ``.rar`` and other extensions will not associated with 7-zip and we simply cannot open the archive files.

## Parameters

The following parameters are available:

Parameter        | Default | Description
---------------- | ------- | -----------
Uninstall-WinRAR | False   | Uninstall silently any instance of WinRAR installed at the target computer after 7-Zip installation.

Please see "Toolkit Parameters" at PSAppDeployToolkit documentation for additional parameters.

## Example

To deploy 7-Zip and uninstall WinRAR after 7-Zip installation:

```
Deploy-Application.exe -UninstallWinRAR
```

## SFX Build

You can use the [SFX Build](../) script that parses ``sfx_listfile.txt`` to create an "all-in-one" installer that extracts PSAppDeployToolkit files to the user's temp folder and runs ``Deploy-Application.exe``.
