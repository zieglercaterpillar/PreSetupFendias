﻿####This script creates the FendiasDownload directory and copies cached updates to expedite the installation process
####TL 7/1/2022
mkdir C:\FendiasDownload
Copy-Item '\\e500srv6\Software\Fendias\test\Fendias V 1.2022' C:\FendiasDownload -Recurse
Copy-Item '\\e500srv6\Software\Fendias\test\Fendias V 1a.2022' C:\FendiasDownload -Recurse
Copy-Item '\\e500srv6\Software\Fendias\test\Fendias V 3.2021' C:\FendiasDownload -Recurse