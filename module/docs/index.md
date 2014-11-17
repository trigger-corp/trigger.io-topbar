``topbar``: Native top bar
==========================

The ``topbar`` module displays a fixed native header bar in mobile apps
and provides a JavaScript API to modify it at runtime.

To get an idea of how these headers can look, see our blog post, [How to build hybrid mobile apps combining native UI components with HTML5](http://trigger.io/cross-platform-application-development-blog/2012/04/30/how-to-build-hybrid-mobile-apps-combining-native-ui-components-with-html5/).

##API

!method: forge.topbar.show(success, error)
!param: success `function()` callback to be invoked when no errors occur
!description: Shows the topbar. The topbar is shown by default and will only be hidden if you call [forge.topbar.hide()](index.html#forgetopbarhidesuccess-error).
!platforms: iOS, Android
!param: error `function(content)` called with details of any error which may occur

!method: forge.topbar.hide(success, error)
!param: success `function()` callback to be invoked when no errors occur
!description: Hides the topbar.
!platforms: iOS, Android
!param: error `function(content)` called with details of any error which may occur

!method: forge.topbar.setTitle(title, success, error)
!param: title `string` title to be displayed
!param: success `function()` callback to be invoked when no errors occur
!description: Set the title displayed in the top bar.
!platforms: iOS, Android
!param: error `function(content)` called with details of any error which may occur

!method: forge.topbar.setTitleImage(image, success, error)
!param: image `file` file object as returned by something like [forge.file.saveURL](file.html#forgefilesaveurlurl-success-error), or a string path relative to the src directory, e.g. "img/button.png"
!param: success `function()` callback to be invoked when no errors occur
!description: Set the title displayed in the top bar to an image.
!platforms: iOS, Android
!param: error `function(content)` called with details of any error which may occur

!method: forge.topbar.setTint(color, success, error)
!param: color `array` an array of four integers in the range [0,255] that make up the RGBA color of the topbar. For example, opaque red is [255, 0, 0, 255].
!param: success `function()` callback to be invoked when no errors occur
!description: Set a color to tint the topbar with, in effect the topbar will become this color.
!platforms: iOS, Android
!param: error `function(content)` called with details of any error which may occur

> ::Note:: On iOS 6 and 7 this color will also be used to tint the status bar, you can
use this in combination with hiding the topbar if you only want a
colored status bar and not a topbar.

!method: forge.topbar.setTitleTint(color, success, error)
!param: color `array` an array of four integers in the range [0,255] that make up the RGBA color of the title text. For example, opaque red is [255, 0, 0, 255].
!param: success `function()` callback to be invoked when no errors occur
!description: Set a color to tint the topbar title with.
!platforms: iOS, Android
!param: error `function(content)` called with details of any error which may occur


!method: forge.topbar.setStatusBarStyle(style, success, error)
!platforms: iOS 7 only
!param: style `string` either ``"default`` or ``"light_content"``.
!param: success `function()` callback to be invoked when no errors occur
!param: error `function(content)` called with details of any error which may occur
!description: Set the status bar style on iOS 7, default will use black text, light_content will use white text.

!method: forge.topbar.addButton(params, callback, error)
!param: params `object` button options, must contain at least ``icon`` or ``text``
!param: callback `function()` callback to be invoked each time the button is pressed
!description: Add a button with an icon to the top bar. 
!platforms: iOS, Android
!param: error `function(content)` called with details of any error which may occur

The first parameter is an object describing the button with the following properties:

-  ``icon``: An icon to be shown on the button: this should be relative
   to the ``src`` directory, e.g. ``"img/button.png"``.
-  ``text``: Text to be shown on the button, either ``text`` or ``icon``
   must be set.
-  ``type``: Create a special type of button, the only option currently
   is ``"back"`` which means the button will cause the webview to go
   back when pressed.
-  ``style``: Use a predefined style for the button, currently this can
   either be ``"done"`` which will style a positive action (which may be
   overriden by ``tint``), or ``"back"`` to show a back arrow style
   button on iOS.
-  ``position``: The position to display the button, either ``left`` or
   ``right``. If not specified the first free space will be used.
-  ``tint``: The color of the button, defined as an array similar to
   ``setTint``.
-  ``prerendered``: (Android and iOS 7 only) If true and an icon is provided the icon will not be modified when displayed, if false (or missing) the icon will be coloured with the tint colour.

**Example**:

    forge.topbar.addButton({
      text: "Search",
      position: "left"
    }, function () {
      alert("Search pressed");
    });

!method: forge.topbar.removeButtons(success, error)
!param: success `function()` callback to be invoked when no errors occur
!description: Remove currently added buttons from the top bar.
!platforms: iOS, Android
!param: error `function(content)` called with details of any error which may occur

##Style Guidlines

The [forge.topbar.setTitleImage](index.html#forgetopbarsettitleimageimage-success-error) method and ``icon`` option in the [forge.topbar.addButton](index.html#forgetopbaraddbuttonparams-callback-error)
method allow you to specify images within the topbar element. These
guidelines may help you to make them look good across devices:

-  The title image will be scaled down (but not up) to fit the
height of the topbar exactly. This means any padding should be
included in the image, and the image should be at least 100px
high.
-  The button icons will also be scaled down (but not up) to fit the
height of the button precisely. The width of the button is the
width of the icon (or text) plus a small amount of padding. We'd
recommend button icons are at least 64px high to make sure they
always fill the button.
-  The total width of the title and buttons is not checked by Forge,
so its up to you to test everything fits, We'd recommend leaving
spare space to make sure devices with unexpected screen ratios
don't overlap.
