MAMP-Controller.sugar
=====================

Control [MAMP][mamp] without having to open their controller application using this sugar for the [Espresso text editor][espresso]. 

[mamp]: <http://www.mamp.info/> "MAMP, Mac OS X, Apache, MySQL, PHP"
[espresso]: <http://macrabbit.com/espresso/> "The Espresso text editor, by MacRabbit"

Simply start the via Actions -> MAMP.

Using
-----
First install any and all dependencies, listed below. The instructions for
doing so can be found on their respective homes.

Clone this project somewhere, with the following:
    
    git clone git://github.com/conceited-drudge/mamp-controller.sugar.git ./MAMP-Controller.sugar
    
And then link it to your syntaxes directory:
    
    mkdir -p "~/Library/Application Support/Espresso/Sugars/"
    ln -s "$(pwd)/MAMP-Controller.sugar" "/Users/$(whoami)/Library/Application Support/Espresso/Sugars/"



Customizing
-----------

You can edit the MAMP-Controller.sugar/TextActions/Actions.xml file and add a custom start page. By default, it will use whatever is configured in MAMP (i.e. /MAMP/). Simply specify something under the <page> tag in the OpenStartPage action. This is a *relative* path to the MAMP apache instance.

License
-------

The content in this sugar is public domain. A mention would be cool someplace if you do use it for anything cool though.
