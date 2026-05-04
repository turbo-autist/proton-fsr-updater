# Proton FSR Updater

A simple script to extract and deploy the latest AMD FSR 3.x/4.x DLLs to your GE-Proton installation on Fedora.

## What it Does
* Automatically finds your GE-Proton directory.
* Downloads/Extracts updated FSR components.
* Enables a cleaner, sharper upscaling experience in supported games.

## Usage Example

```text
user@fedora:~/proton-fsr-updater$ ls -l
insgesamt 929624
-rw-r--r--. 1 user user       314  3. Mai 23:18 README.md
-rwxr-xr-x. 1 user user      2363  3. Mai 22:54 update-fsr.sh
-rw-r--r--. 1 user user 951923856 17. Apr 13:32 whql-amd-software-adrenalin-edition-26.3.1-win11-b.exe

user@fedora:~/proton-fsr-updater$ ./update-fsr.sh whql-amd-software-adrenalin-edition-26.3.1-win11-b.exe 
--- Extracting: whql-amd-software-adrenalin-edition-26.3.1-win11-b.exe ---
 [!] Cache is empty. Initializing first-time setup.
 [+] Result: Upgrading cache to FSR 4.1.1...
------------------------------------------------------------
 SUCCESS: FSR Component Updated to FSR 4.1.1
 SAVED TO: /home/user/.cache/protonfixes/upscalers/amdxcffx64_v4.1.0_69A0952A304a000.dll
------------------------------------------------------------
 To enable in Steam, use these Launch Options:

 FSR4_UPGRADE=1 PROTON_FSR4_INDICATOR=1 %command%
------------------------------------------------------------
user@fedora:~/proton-fsr-updater$