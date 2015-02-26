# php4_installer [![Flattr this][flatter_png]][flatter]

php4_installer download and installs PHP 4, the PECL extensions,
the PHP Manual (English) in Windows Help (CHM) Format, and the Zend Optimizer,
which are available at http://www.php.net, and http://zend.com.

php_installer also performs the following:

* copies php.ini-recommended to php.ini and sets the following settings:
````
  extension_dir="C:\Program Files\php4\ext"
  error_log="C:\Program Files\php4\logs\phperror.log"
  upload_tmp_dir="C:\Program Files\php4\uploads"
  session.save_path="C:\Program Files\php4\sessions"
````

* Adds the following variables to your environment:
````
   PHPRC=C:\Program Files\php4
````

* Adds the installation directory to your PATH environment variable.
	On 32-bit systems, this directory is usually `C:\Program Files\PHP`.
	On 64-bit systems, this directory is usually `C:\Program Files(x86)\PHP`.

php_installer looks in the directory where php_installer.exe is for
any files it needs before attempting to download them. If it does download a
file, it will attempt to save a copy of the file in this same directory.

## Usage

````
php_installer [options]

Options:
/S         Install the application silently with the default options selected
/D=path    Install into the directory 'path' (default is
           %ProgramFiles%\PHP4)
/INSTYPE n Where n is a number between 0 and 3:
           0: PHP and Manual (Default)
           1: PHP Only
           2: PHP Manual Only (CHM English)
           3: Zend Optimizer Only
           4: All
           5: None
````

## Contributing

To contribute to this project, please see [CONTRIBUTING.md](CONTRIBUTING.md).

## Bugs

To view existing bugs, or report a new bug, please see [issues](../../issues).

## Changelog

To view the version history for this project, please see [CHANGELOG.md](CHANGELOG.md).

## License

This project is [MIT licensed](LICENSE).

## Contact

This project was created and is maintained by [Ross Smith II][] [![endorse][endorse_png]][endorse]

Feedback, suggestions, and enhancements are welcome.

[Ross Smith II]: mailto:ross@smithii.com "ross@smithii.com"
[flatter]: https://flattr.com/submit/auto?user_id=rasa&url=https%3A%2F%2Fgithub.com%2Frasa%2Fphp4_installer
[flatter_png]: http://button.flattr.com/flattr-badge-large.png "Flattr this"
[endorse]: https://coderwall.com/rasa
[endorse_png]: https://api.coderwall.com/rasa/endorsecount.png "endorse"

