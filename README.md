In Flutter 3.27, a 'touch-action: none' property was added for embedded views (see: https://github.com/flutter/engine/pull/53945) to give the Flutter engine full control over all touch gestures in the browser.

The issue is that, due to this 'touch-action' property, we are unable to interact with the main browser scroll. Removing the property is not a viable solution, as it would make it impossible to interact with any scroll within the Flutter app. I'm unsure what the best approach is.

This video demonstrates the behavior I am referring to:

https://github.com/user-attachments/assets/8cd34506-b65f-4eff-82ff-97411f141718

