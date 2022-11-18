# Power BI Sidekick
Use the external tool Power BI Sidekick to retrieve quick insights on your Power BI reports.


### Three main components
1. Report pages --> scan through all elements relevant for evaluation from a page perspective.
2. Mini tools --> fifteen mini tools addressing different aspects of the report ( DAX dependencies, calculation groups, bookmarks, search expressions ... )
3. Documentation --> overview of the objects that are being used in the report ( tables, columns, measures, bookmarks ...)

Hopefully useful for many alike Power BI developers, just check it out!  
See https://github.com/andreasjongenburger/power-bi-sidekick/wiki/Set-up-and-run-Power-BI-Sidekick for installation instructions.  
See https://andreasjongenburger.com/introducing-power-bi-sidekick/ for an introduction of the tool with more info on functionality and use cases.

### Standing on the shoulders of giants

The intention is to share this external tool in the Power BI Community. This follows naturally given the fact that the Power BI Sidekick also has benefited from community shared content.

Parts of the performance metrics are based on the Vertipaq Analyzer tool created by DAX heroes Marco Russo and Alberto Ferrari (https://github.com/sql-bi/VertiPaq-Analyzer).

Another big shout-out goes to Stephanie Bruno, who created the Power BI Field Finder (https://github.com/stephbruno/Power-BI-Field-Finder). From that project, I took the beautiful idea of visualizing objects that are used in the Power BI reports with svg-miniature-images.

### Licence

Given that Stephanie Bruno's project is shared under the GNU General Public License v3.0 and my usage of code snippets from her tool, Power BI Sidekick will also be shared under the same license.

### Disclaimer

This version is only tested on my own projects. No liability, responsiblity or warranty applies to the creator.

Always create a backup of your report, before making adjustments - like removement of columns and/or measures - based on the insights provided by Power BI Sidekick.
