# Blitz

A simple presentation app that enforces a specific format: 

* 20 slides
* 15 seconds each
* 5 minutes total

To use, drop a PDF or Keynote file (you'll need iWork '09 installed for Keynote support) onto its icon. Blitz assumes you'll have 20 slides at 1280x720.

Or, load the slideshow (any format) into Keynote, put the presenter display on the laptop, and the slideshow display on the main screen. Start Blitz, and turn on **Floating Counters**. Adjust the position of the counters, then return to Keynote and set the slideshow to the first slide. When you're ready, click the floating counter on the presenter display, and the show starts!

Blitz will send 19 advance events to Keynote; each is the same as tapping the space bar. Builds can be done with automatic buildout, as long as the whole slide is built within 15 seconds. Fewer than 20 slides can be used as long as the total number of advance events to get to the end is 19.

Requires Mac OS X 10.6 (though [Kevin Mitchell has a 10.5-happy fork here](http://github.com/kamitchell/Blitz)).

Please [report bugs and request features](http://rentzsch.lighthouseapp.com/projects/32860-blitz/tickets/new) on the [Lighthouse project site](http://rentzsch.lighthouseapp.com/projects/32860-blitz/tickets?q=all). Want to chip in? [Here's what needs to be done](http://rentzsch.lighthouseapp.com/projects/32860-blitz/tickets/bins/29884).

## Version History

* **Post-1.0** Thu 21 Oct 2010 [download](http://github.com/downloads/kamitchell/Blitz/Blitz.kam.2010-10-21.zip)
	* [NEW] Preferences window to adjust colors of the counter. Theme Blitz.app to match the colors of your conference!
	* [NEW] **Floating Counters** in the Window menu will create one floating counter per screen. These counters send advance events to Keynote, and will float over it if **Allow Expose, Dashboard, and others to use screen** is checked in the Slideshow preferences. The counters are draggable for a choice of positioning. Start a slideshow in Keynote, then click the counter to start. Another click will stop the counter, and yet another will reset it to 0.

* **1.0** Tue 22 Sep 2009 [download](http://cloud.github.com/downloads/rentzsch/Blitz/Blitz-1.0.zip)
	* [NEW] Can now open .key files directly utilizing undocumented QuickLookUI.framework functionality. [ticket 9](http://rentzsch.lighthouseapp.com/projects/32860/tickets/9) ([rentzsch](http://github.com/rentzsch/Blitz/commit/6770af7608d76e7424d2c181d93b4951f7b8006a))

	* [NEW] Support for extracting and displaying speaker notes from .key files. [ticket 9](http://rentzsch.lighthouseapp.com/projects/32860/tickets/9) (Tim Wood).

	* [NEW] Full-screen display. [ticket 1](http://rentzsch.lighthouseapp.com/projects/32860/tickets/1) ([Philippe Casgrain](http://github.com/rentzsch/Blitz/commit/7ba02d9c3a19e732bd4fa9c8c55e640e2e43173b))

	* [NEW] Better end-of-talk display. [ticket 3](http://rentzsch.lighthouseapp.com/projects/32860/tickets/3-better-end-of-talk-display) ([Philippe Casgrain](http://github.com/rentzsch/Blitz/commit/b4be0c5921f2edc31ea3f92d57ff52e4a16518d8))

	* [FIX] Disable PDFView scroll wheel. [ticket 5](http://rentzsch.lighthouseapp.com/projects/32860/tickets/5) ([Philippe Casgrain](http://github.com/rentzsch/Blitz/commit/2bc84f511646bc6799ac7fc742464b2e45082374))

* **0.1** Sun 28 Jun 2009 [download](http://cloud.github.com/downloads/rentzsch/Blitz/Blitz-0.1.zip)

	* Initial version
