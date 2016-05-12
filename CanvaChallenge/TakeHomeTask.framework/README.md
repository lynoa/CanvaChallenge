Photo mosaic
------------

The goal of this task is to implement the following flow in an iOS app.
This task should take around 3-5 hours, there is no hard limit,
   focus on getting the best results in this time.

1. A user selects a local image file.
2. The app must:
   * load that image;
   * divide the image into tiles;
   * find a representative color for each tile (average);
   * fetch a tile from the provided server (framework) for that color;
   * composite the results into a photomosaic of the original image;
3. Tiles should be displayed to the user as they are downloaded.
4. The client app should make effective use of parallelism and asynchrony.

You should have a file [TakeHomeTask.framework](./task/TakeHomeTask.framework).
This frameworks provides an API to access the (faked) mosaic tile server.

You should, in priority order:

 * pretend you're submitting this as production-quality code for review; i.e.,
   - write the code so it can have unit tests written for it;
   - make the code adaptable to changing requirements;
   - write effective comments, enough to understand the code in 6 months;
 * it should be easy to compile, avoid complex dependencies,
   Carthage and CocoaPods are fine.
 * do not use third-party libraries that directly solve the task,
   this will not tell us anything about you,
   and will not produce adaptable code;
 * use the latest (App Store / Stable) Xcode;
 * use a tile size of 32x32;
 * make the UI work on different iOS devices;

You may:

 * choose a minimum iOS version you want to support
   (latest version must be supported);
 * use Swift or Objective-C, although we would prefer to see Swift;
 * make it work with different tile sizes other than 32x32;
 * be as creative as you like with the submission UI
   (transitions, zoom, progress indicators, etc.);
   however, it is not the focus of the task, a minimal UI is fine;
 * write tests if you want to; although it's not required;

Have fun!
