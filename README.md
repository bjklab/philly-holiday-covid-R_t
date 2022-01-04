Watch Out for the Case Backfill!
================
Brendan J. Kelly, MD, MS

This week, COVID-19 cases have continued to rise in Philadelphia,
Pennsylvania (4119 observed cases on December 28, 2021), despite
<a href="https://policylab.chop.edu/covid-lab-mapping-covid-19-your-community">incidence
modelling</a> that predicted a peak closer to 680 cases/day. I wanted to
understand how <b>case backfill</b>, the process of updating COVID-19
daily case counts for up to a week after the initial daily case counts
are recorded, might impact estimates of the COVID-19 reproductive number
(R<sub>t</sub>) and predictions of future COVID-19 incidence based on
R<sub>t</sub>. During the winter holiday season, short staffing may
result in data entry and transfer delays that
<a href="https://www.nytimes.com/interactive/2021/11/22/us/covid-data-holiday-averages.html">increase
the impact of case backfill</a>. To understand the <b>holiday backfill
effect</b>, I compared the COVID-19 case data available for
Philadelphia, Pennsylvania on 22 December 2021 to the case data
available today, 3 January 2022:

<img src="./figs/p_combined_tp.png" width="90%" style="display: block; margin: auto;" />

In the top panel, the comparison of incidence data demonstrates that
<b>case backfill</b> significantly increased cases in the week prior to
December 22, 2021. In the bottom panel, the effect of this missing data
to skew R<sub>t</sub> below 1 can be seen. R<sub>t</sub> was estimated
using a mean serial interval of 2.2 days (SD 0.8 days), based on the
best available data on the
<a href="https://www.medrxiv.org/content/10.1101/2021.12.25.21268301v1">Omicron
variant</a>, via the <a href="">EpiEstim R package</a>. The median
(line) and 95% confidence interval (shading) for the estimated
R<sub>t</sub> are shown.

The same model for R<sub>t</sub> based on the most recent available data
again suggests that R<sub>t</sub> is trending down… but this should not
be cause for excess optimism in light of the <b>holiday backfill
effect</b> seen last week.
