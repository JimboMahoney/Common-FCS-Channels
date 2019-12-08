# Common-FCS-Channels
Opens two or more FCS files and creates new files that contain only the Channels common to all.

### Description
During my work with flow & mass cytometry files (FCS), I've found that sometimes you have captured an experiment using different Channels / Parameters (usually, these are extra / unnecessary).
<br>
<br>
When trying to work with this in many software packages, including flowCore, this causes problems due to the different number of Channels in each file. Therefore, I implemented a simple script that will load at least two files, compare them and create <b>new</b> files (with the name "crop" added). These files can then be loaded into whatever package you wish.

### Usage
Simply copy/paste the script and run it in [R](https://cran.r-project.org/). My preference is an IDE such as [R-Studio](https://rstudio.com/).

### Limitations
If the user-defined parameter names are different between files, this script won't be affected, but the output files will still have differently named channels / parameters. This may or may not be a problem downstream.
<br><br>
For a much more powerful (interative) method to compare and change Channel (Parameter) names etc. check out the [Premessa](https://github.com/ParkerICI/premessa) package.
