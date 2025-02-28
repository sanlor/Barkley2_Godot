echo converting *.mp3 to *.ogg 
for /r %%i in ( *.mp3 ) do ffmpeg -i "%%i" -acodec libvorbis "%%~di\%%~pi\%%~ni.ogg"