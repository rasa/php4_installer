<?php

$argv = $_SERVER['argv'];

$src		= count($argv) >= 2 ? $argv[1] : 'php.ini-recommended';
$php_root = dirname($src);
if ($php_root == '.') {
	$php_root = 'c:/php';
	$src = $php_root . '/' . $src;
}
$php_root .= '/';

$dest		= count($argv) >= 3 ? $argv[2] : 'php.ini';
if (dirname($dest) == '.') {
	$dest = $php_root . $dest;
}

$ext_dir	= count($argv) >= 4 ? $argv[3] : (version_compare(PHP_VERSION, '5.0.0', '>=') ? 'ext' : 'extensions');
if (dirname($ext_dir) == '.') {
	$ext_dir = $php_root . $ext_dir;
}

$log	= count($argv) >= 5 ? $argv[4] : 'logs/phperror.log';
if (dirname($log) == 'logs') {
	$log = $php_root . $log;
}

$sess_dir	= count($argv) >= 6 ? $argv[5] : 'sessions';
if (dirname($sess_dir) == '.') {
	$sess_dir = $php_root . $sess_dir;
}

$upload_dir	= count($argv) >= 7 ? $argv[6] : 'uploads';
if (dirname($upload_dir) == '.') {
	$upload_dir = $php_root . $upload_dir;
}

$wsdl_dir	= count($argv) >= 7 ? $argv[6] : 'wsdl_cache';
if (dirname($wsdl_dir) == '.') {
	$wsdl_dir = $php_root . $wsdl_dir;
}

$in = fopen($src, 'r');

if (!$in)
	die(sprintf("Cannot open '%s'", $src));
	
$out = fopen($dest, 'w');

if (!$out)
	die(sprintf("Cannot open '%s'", $dest));

printf("Creating %s from %s\n", $dest, $src);

$dlls = glob($ext_dir . '/*.dll');

for ($i = 0; $i < count($dlls); ++$i) {
	$dlls[$i] = strtolower(basename($dlls[$i]));
}

sort($dlls);
$used_dlls = array();

$in_dlls = false;

while (!feof($in)) {
	$s = fgets($in);

# use these if you want this script to not uncomment these values:
#	$s = preg_replace('/^([\s;]*)extension_dir\s*=.*/i',		sprintf('$1extension_dir = "%s"', 		$ext_dir), $s);
#	$s = preg_replace('/^([\s;]*)error_log\s*=.*/i',			sprintf('$1error_log = "%s"',				$log), $s);
#	$s = preg_replace('/^([\s;]*)session.save_path\s*=.*/i',	sprintf('$1session.save_path = "%s"', 	$sess_dir), $s);
#	$s = preg_replace('/^([\s;]*)upload_tmp_dir\s*=.*/i',		sprintf('$1upload_tmp_dir = "%s"',		$upload_dir), $s);

	$s = preg_replace('/^([\s;]*)extension_dir\s*=.*/i',		sprintf('extension_dir = "%s"', 		$ext_dir), $s);
	$s = preg_replace('/^([\s;]*)error_log\s*=\sfilename.*/i',			sprintf('error_log = "%s"',		$log), $s);
	$s = preg_replace('/^([\s;]*)session.save_path\s*=.*/i',	sprintf('session.save_path = "%s"', 	$sess_dir), $s);
	$s = preg_replace('/^([\s;]*)soap.wsdl_cache_dir\s*=.*/i',		sprintf('soap.wsdl_cache_dir = "%s"', 		$wsdl_dir), $s);
	$s = preg_replace('/^([\s;]*)upload_tmp_dir\s*=.*/i',		sprintf('upload_tmp_dir = "%s"',		$upload_dir), $s);

	if (preg_match('/^;?extension\s*=(.*\.dll)/', $s, $matches)) {
		$in_dlls = true;
		$this_dll = strtolower($matches[1]);
		foreach ($dlls as $dll) {
			if (array_key_exists($dll, $used_dlls) || array_key_exists($this_dll, $used_dlls)) {
				continue;
			}
			if ($dll < $this_dll) {
				fputs($out, sprintf(";extension=%s\n", $dll));
				$used_dlls[$dll] = 1;
				continue;
			}

			fputs($out, $s);
			$used_dlls[$this_dll] = 1;
			break;
		}
		
		continue;
	}
	
	if ($in_dlls) {
		foreach ($dlls as $dll) {
			if (array_key_exists($dll, $used_dlls)) {
				continue;
			}
			fputs($out, sprintf(";extension=%s\n", $dll));
			$used_dlls[$dll] = 1;
		}
	}

	fputs($out, $s);
}

fclose($in);
fclose($out);

?>
