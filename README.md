# PSS Revive

PSS Revive is an editor and librarian for Yamaha PSS x80 synths.  
A important part of the project is also the [wiki](https://github.com/BobanSpasic/PSS-Revive/wiki), as a collection of informations about the PSS-x80 series.  
I use PSS-x80 as a common name for Yamaha PortaSound PSS-480, PSS-580, PSS-680 and PSS-780 synth/keyboards.  

Main screen:
![PSS-Revive](https://github.com/BobanSpasic/PSS-Revive/blob/main/doc/screenshot_dev3.png)

Direct editing of the SysEx data:
![PSS-Revive](https://github.com/BobanSpasic/PSS-Revive/blob/main/doc/screenshot_dev4.png)

## ToDo
- Better Envelope graphics

## Dependencies
Windows 64 - SQLite3 (dll included in download)

Linux Qt5 - Libc6, sqlite3, portmidi, libQt5Pas

Linux GTK2 - Libc6, sqlite3, portmidi

FreeBSD - Libc6, sqlite3, portmidi, Qt5Pas and optional alsa_seq_server to access MIDI ports.

## Compiling
Developed by using [Lazarus/Freepascal.](https://www.lazarus-ide.org/)

External components needed to build the PSS Revive are available through Lazarus OPM (Online Package Manager):
- ATShapeLine
- EyeCandyControls
- HashLib4Pascal
- TAChart
- BGRA Controls
- IndustrialStuff
- TK Controls

## Linux notes
libQt5pas distributed with Ubuntu and derivates is know to cause problems. 

Please use the builds from David Bannon: https://github.com/davidbannon/libqt5pas/releases

For Linux on 64-bit PC, you'll need libqt5pas1_2.11-1_amd64.deb 

## Windows notes
On Windows, the PortMidi library is not used. I did't found any working 64-bit version of portmidi.dll on the internet.
It means, MIDI on Windows is accessed through native Windows' MultiMedia System (MMSYSTEM).
