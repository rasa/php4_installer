# Copyright (c) 2005-2015 Ross Smith II (http://smithii.com). MIT Licensed.

!define PHP_VER 4.4.9
!define ZEND_VER 3.3.3

!define PRODUCT_NAME "php4_installer"
!define PRODUCT_DIR "PHP4"
#!define PRODUCT_VERSION "1.0"
!define PRODUCT_DESC "PHP4 Installer ${PRODUCT_VERSION} for PHP ${PHP_VER}"
!define PRODUCT_TRADEMARKS "PHP is copyright (c) 1997-2015 The PHP Group"

!addincludedir "../nsislib"
!addincludedir "nsislib"

!include "config.nsh"

!undef PRODUCT_EXE
!undef PRODUCT_FILE
!define NO_DESKTOP_ICONS
#!define ADD_INSTDIR_TO_PATH

!define COPYDIR "$EXEDIR"
#!define NOEXTRACTPATH
!define UNZIP_DIR "$INSTDIR"

# 0:
InstType "PHP ${PHP_VER} and Manual Only"
# 1:
InstType "PHP ${PHP_VER} Only"
# 2:
InstType "PHP Manual Only"
# 3:
InstType "Zend Optimizer ${ZEND_VER} Only"
# 4:
InstType "All"
# 5:
InstType "None"

!include "common.nsh"

Section "-hidden1"
	CreateDirectory "$INSTDIR\chm"
	File "fixini.php"
	File "setup.iss"
SectionEnd

!include "php4_installer.nsh"

!include "WriteEnvStr.nsh"

Section "-hidden2"
	Var /GLOBAL PHPUNZIP_DIR
	StrCpy $PHPUNZIP_DIR "$INSTDIR\php-${PHP_VER}"

	FindFirst $0 $1 "$PHPUNZIP_DIR\*.*"
	loop:
	  StrCmp $1 "" done
	  #DetailPrint "Deleting '$PHPUNZIP_DIR\$1'"
	  #Delete   "$INSTDIR\$1"
	  #RmDir /r "$INSTDIR\$1"
	  DetailPrint "Renaming '$PHPUNZIP_DIR\$1' to '$INSTDIR\$1'"
	  Rename   "$PHPUNZIP_DIR\$1" "$INSTDIR\$1"
	  FindNext $0 $1
	  Goto loop
	done:
	FindClose $0

	#DetailPrint "Deleting '$PHPUNZIP_DIR'"
	#RmDir /r "$PHPUNZIP_DIR"

	Push PHPRC
	Push "$INSTDIR"
	Call WriteEnvStr

	Push "$INSTDIR\dlls"
	Call AddToPath

	Push "$INSTDIR"
	Call AddToPath

	Var /GLOBAL TEMP_DIR
	StrCpy $TEMP_DIR "$INSTDIR"
	CreateDirectory "$TEMP_DIR\logs"
	CreateDirectory "$TEMP_DIR\sessions"
	CreateDirectory "$TEMP_DIR\uploads"
	CreateDirectory "$TEMP_DIR\wsdl_cache"

	CopyFiles "$INSTDIR\cli\php.exe" "$INSTDIR\php-cli.exe"

	IfFileExists "$INSTDIR\php.ini" phpini_exists 0
		CopyFiles "$INSTDIR\php.ini-recommended" "$INSTDIR\php.ini"
		CreateShortCut "$SMPROGRAMS\${PRODUCT_DIR}\Edit php.ini.lnk" "$INSTDIR\php.ini"

		DetailPrint 'Executing "$INSTDIR\php-cli.exe" -q fixini.php "$INSTDIR\php.ini-recommended"'
		ExecWait '"$INSTDIR\php-cli.exe" -q fixini.php "$INSTDIR\php.ini-recommended"' $0
		DetailPrint '"$INSTDIR\php-cli.exe" -q fixini.php "$INSTDIR\php.ini-recommended" returned error $0'
	phpini_exists:

	IfSilent 0 not_silent
		IfFileExists "$EXEDIR\ZendOptimizer-${ZEND_VER}-Windows-i386.exe" 0 zend_done
			DetailPrint 'Executing "net stop apache2"...'
			ExecWait 'cmd.exe /c start "Stopping Apache..." /min net stop apache2' $0
			DetailPrint '"net stop apache2" returned $0'
			DetailPrint 'Executing "$EXEDIR\ZendOptimizer-${ZEND_VER}-Windows-i386.exe"...'
			ExecWait '"$EXEDIR\ZendOptimizer-${ZEND_VER}-Windows-i386.exe" /s /f1"$INSTDIR\setup.iss"' $0
			DetailPrint '"$EXEDIR\ZendOptimizer-${ZEND_VER}-Windows-i386.exe" returned $0'
			Goto zend_done
	not_silent:
		IfFileExists "$EXEDIR\ZendOptimizer-${ZEND_VER}-Windows-i386.exe" 0 zend_done
			DetailPrint 'Executing "$EXEDIR\ZendOptimizer-${ZEND_VER}-Windows-i386.exe"...'
			ExecWait '"$EXEDIR\ZendOptimizer-${ZEND_VER}-Windows-i386.exe"' $0
			DetailPrint '"$EXEDIR\ZendOptimizer-${ZEND_VER}-Windows-i386.exe" returned $0'
	zend_done:
SectionEnd

Section uninstall
	Push "$INSTDIR\dlls"
	Call un.RemoveFromPath

	Push PHPRC
	Call un.DeleteEnvStr
SectionEnd
