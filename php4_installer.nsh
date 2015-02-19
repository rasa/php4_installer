# Copyright (c) 2005-2015 Ross Smith II (http://smithii.com). MIT Licensed.

!insertmacro DownloadCLI  "1 2 5" "PHP ${PHP_VER}" "http://www.php.net/distributions/php-${PHP_VER}-Win32.zip"	"" ''
#!insertmacro DownloadCLI  "1 2 5" "PHP ${PHP_VER}" "http://museum.php.net/win32/php-${PHP_VER}-Win32.zip"	"" ''
#!insertmacro DownloadCLI "1 3 5" "PECL Extensions ${PHP_VER}" "http://www.php.net/distributions/pecl-${PHP_VER}-Win32.zip"	"extensions" ''
!insertmacro DownloadGUI  "1 3 5" "PHP Manual (English CHM Version)" "http://www.php.net/distributions/manual/php_manual_chm.zip"	"chm\php_manual_en.chm" "chm" ''
!insertmacro DownloadAny  "  4 5" "Zend Optimizer" "http://downloads.zend.com/optimizer/${ZEND_VER}/ZendOptimizer-${ZEND_VER}-Windows-i386.exe"	"" ''
