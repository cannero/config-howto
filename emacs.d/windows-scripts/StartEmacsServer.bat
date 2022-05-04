set HOME=%APPDATA%
del /Q "%HOME%/.emacs.d/server/*"
SET PATH=%PATH%;%~pd0%.
runemacs.exe --daemon
rem start directory can be set in shortcut
rem -c "(setq default-directory ""c:/dir/"")"
