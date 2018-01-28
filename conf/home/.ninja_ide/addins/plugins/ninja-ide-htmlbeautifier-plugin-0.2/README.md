ninja-ide-htmlbeautifier-plugin
===============================

Plugin for beautifying your HTML files

This plugins allows you to have your code pretty-printed by pressing CTRL+SHIFT+P.
(It will not interfer with autopepper since there's files type validation)
It uses beautifulsoup4 and html.parser.

Warning for django templates
----------------------------

This parser **works** for it, but it will beautify the HTML not the django tags, so there will be some strange indentations.

Error in html tags ending may cause some strange results (For me, all my code was put into a link tag that was not closed).


Current-Version: 0.2

Tested with : nindja-ide 2.2

Version History
---------------

* 0.1 - Initial pluggin
* 0.2 - Added support indentation based on settings
      - Added indentation for not indented section (Without that, the code would be destroyed after a few beautifying)
      - Removed the bug that would indent more and more and more the multilines comments

Thanks to
---------

Martin Reiter (blackcoffeerider) for the autopepper plugin. By debuggin it I learn how to make this plugin. https://github.com/blackcoffeerider/ninja-ide-autopepper-plugin


