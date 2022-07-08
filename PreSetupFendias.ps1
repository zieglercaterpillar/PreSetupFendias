﻿####This script creates the FendiasDownload directory and copies cached updates to expedite the installation process
####TL 7/1/2022
Get-Date > C:\Utilities\PreFendiasLog.txt
mkdir C:\FendiasDownload >> C:\Utilities\PreFendiasLog.txt
robocopy '\\e500srv6\Software\Fendias\NewFendiasData\Fendias V 1.2022' C:\FendiasDownload\ /e /copyall >> C:\Utilities\PreFendiasLog.txt
robocopy '\\e500srv6\Software\Fendias\NewFendiasData\Fendias V 1a.2022' C:\FendiasDownload\ /e /copyall >> C:\Utilities\PreFendiasLog.txt
robocopy '\\e500srv6\Software\Fendias\NewFendiasData\Fendias V 3.2021' C:\FendiasDownload\ /e /copyall >> C:\Utilities\PreFendiasLog.txt
robocopy '\\e500srv6\Software\Fendias\NewFendiasData\manifests' C:\FendiasDownload\ /e /copyall >> C:\Utilities\PreFendiasLog.txt
exit