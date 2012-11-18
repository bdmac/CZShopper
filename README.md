# Care Zone Shopper iOS Application

This is an example shopping list application for Care Zone. It is targeted at iOS 5.0+.

## Requirements

* Access and maintain the shopping list data on Care Zone server.
* Support offline read access to the list using Core Data.
* Create, edit and delete do not work offline.
* For iOS, support iOS 5 and up, and use ARC.
* Gracefully handle errors.
* Consistently format your code and ensure it’s easy to read.

## Open Source Projects Used

This project uses CocoaPods to manage 3rd party library dependencies.  The following
open source projects were used:

1. __RestKit__: RestKit is "an Objective-C framework for iOS that aims to make interacting with 
   RESTful web services simple, fast and fun". It also integrates with CoreData for offline access.
2. __SVProgressHUD__: An easy to use progress HUD for letting users know when network access is happening.

## Project Notes

The project was mostly trivial to implement but the offline access was something that I had not
dealt with previously. Our current apps do not support offline access so I had to figure out
the best way of managing it.

Thankfully it _is_ something we had been wanting to add (just haven't had bandwidth to do it) so I
had already started doing some cursory investigation into RestKit and knew that it had CoreData
support for offline access.

Using RestKit was a bit of a mixed bag... It was not very easy to figure out how to do various things
because they support N ways to do each thing it seems like.  This made figuring out the best
practices tricky. It's also a fairly mature (read, old) library so a lot of the stuff I found was
outdated. Once I figured things out though it __did__ make most things relatively painless but I would
say that I still don't have the full library and all of its power figured out yet.

Previously I had been using the wonderful AFNetworking library from the Gowalla guys for all of our 
networking needs.  When I started working with iOS, RestKit was not yet updated to support blocks but 
AFNetworking did so that made my decision pretty easy.

Even though figuring out RestKit was a bit tricky I feel like it was worth the extra time since it
is something I will likely end up using at Trazzler (OpenPlaces) for offline access if/when we
implement that feature.

## Tests

There aren't any at this point... I've never really TDD'd my iOS projects and figuring out RestKit
took longer than I thought it would so I ran out of time.