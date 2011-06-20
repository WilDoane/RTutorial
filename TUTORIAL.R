# Prepared by: William Doane, PhD <wdoane@bennington.edu>
# during the Computational Biology for Biology Educators workshop
# Lafayette College, Easton PA, 2011 06 12 - 2011 06 17

# Any line or part of a line that begins with a hash mark # is a comment, ignored by R

# Values
1        # integer
1.4      # decimal fraction
1e-2 + 7 # Scientific notation: "1 times 10 to the -2 plus 7"
"red"    # string value
TRUE     # boolean/logical value

# The display of values can be affected by environment settings
1e-1 + 7
1e-2 + 7
1e-3 + 7
1e-4 + 7
1e-5 + 7
1e-6 + 7
1e-7 + 7
1e-8 + 7

getOption("digits")
options(digits=10) # if you want a specific number of sig. figs

1e-1 + 7
1e-2 + 7
1e-3 + 7
1e-4 + 7
1e-5 + 7
1e-6 + 7
1e-7 + 7
1e-8 + 7

options(digits=5) # a sane default

# Collections of values
c(1,2)                      # collection of integer values
c("red", "blue")            # collection of string values
c(TRUE, TRUE, FALSE, TRUE)  # collection of boolean (logical) values
?c
c(1,2) + 1
c("red", "blue") + 1  # ERROR


# Sequences of values
seq(1, 10)
seq(1, 10) * 2
seq(1, 10, by=2)
?seq

letters
LETTERS

# Matrices of values
matrix(seq(1, 10), nrow=2)
?matrix
matrix(seq(1, 10), nrow=2) / 2

# Variables store values
# Variable names must begin with an alphabetic character
#                cannot contain spaces
#                must NOT be the same as an existing R function name
#                by convention use . to separate words: final.grades
#                should be meaningful within the context of your research
# Either <- or = is used evaluate the right-hand side and store it 
#   in the variable named on the left-hand side

XX = matrix(seq(1, 10), nrow=2)
XX
XX / 2        # computes but does not store, the value(s)
XX
XX <- XX / 2  # computes the value(s) and stores the result back in XX

t(XX) %*% XX  # X'X ... matrix multiplication of X-transpose and X

# We can consider the whole matrix
XX

# ... just a single row
XX[1, ]

# ... or a single column
XX[, 2]

# ... or a single cell
XX[1, 2]    # the cell at row 1, column 2



# Organizing analyses
# 1. Create a directory for each new analysis project
#    so that you can save the history, workspace, etc. 
#    separately for each project.
#
#    ~ means "the current user's home directory"

dir.create("~/research/example", recursive=TRUE)

# 2. Set the current working directory to that directory
# In R-Studio, you can do this either using the menus
#        Tools > Set working directory...
#
# ... or using standard R commands
setwd("~/research/example")

# 3. Save the history of your analysis regularly and annotate it
savehistory("20110617-Tutorial.Rhistory")


# 4. Import raw data into R, then do any data cleaning within R
#    so that data transformations (log, male/female, corrections, etc)
#    are documented as part of your analysis.
# 
#    Some common R filename conventions: 
#       raw.xls
#       raw.csv
#       20110617-cleaned-gender.RData
#       20110618-imputed-missingvalues.RData
#       analysis.R



# ** TUTORIAL NOTE **
# At this point, you should copy the raw.xls and raw.csv files
# to your home directory, into the research folder, into the
# example folder.
#
# That way, your data, saved workspaces, saved history, save R scripts,
# etc. are all stored together.


# Reading data from a file
# In R-Studio, you can do this either using the menus
#        Workspace > Import Dataset > From Text File...
#
# ... or using standard R commands
raw = read.csv("raw.csv", header=TRUE)

# Inspect the first few rows of data as a sanity check
head(raw)

# We should see...
#       id  pre post gender
# 1   Aaron   5    6      m
# 2   Betty  31   56      f
# 3  Calvin  30   43      m
# 4   Daisy  46   95      f
# 5  Eileen   3   21      f
# 6 Forrest  35   66      m

# Check that columns (parameters) have been read/named correctly
str(raw)

# We should see...
# 'data.frame':  21 obs. of  4 variables:
#  $ id     : Factor w/ 21 levels "Aaron","Betty",..: 1 2 3 4 5 6 7 8 9 10 ...
#  $ pre   : int  5 31 30 46 3 35 20 7 11 47 ...
#  $ post  : int  6 56 43 95 21 66 51 30 46 59 ...
#  $ gender: Factor w/ 2 levels "f","m": 2 1 2 1 1 2 2 1 2 2 ...

# Note that the student names have been read-in as a parameter, X,
# and converted to a categorical factor with 21 levels.

# We can consider just the first column (student names)
head(raw[, 1])

# We really want to use those as row names, not as a parameter
rownames(raw) = raw[, 1]
head(raw)

# We should see...
#                 id  pre post gender
# Aaron         Aaron   5    6      m
# Betty         Betty  31   56      f
# Calvin       Calvin  30   43      m
# Daisy         Daisy  46   95      f
# Eileen       Eileen   3   21      f
# Forrest     Forrest  35   66      m




# There are several ways to select columns from a matrix...
# Select all columns from the matrix
head(raw)

# Select contiguous columns
head(raw[, 1:2])

# Select possibly non-contiguous columns
head(raw[, c(1,4)])

# Change the order of the columns selected
head(raw[, c(3, 2)])

# Exclude a column
head(raw[, -1])





# Remove the student names parameter column (column #1)
raw = raw[, -1]
head(raw)

# We should see...
#           pre post gender
# Aaron       5    6      m
# Betty      31   56      f
# Calvin     30   43      m
# Daisy      46   95      f
# Eileen      3   21      f
# Forrest    35   66      m



#Generate descriptive statistics
summary(raw)

# You'll get a warning ("NAs introduced by coercion") for any 
# remaining factors (categorical parameters)
sd(raw)

# Generate an initial exploratory scatter plot
pairs(raw)

# Let's find out what the coding is for this factor
levels(raw$gender)

# We should se...
# [1] "f" "m"
#
# indicating that F == 1 and M == 2


# Let's add a couple of functions to our workspace to be able to
# plot nicer pairs scatter plots.
#
# It's not critical that you understand how these functions
# work at the moment, just that they create (1) text showing
# the r value for each comparison and (2) a histogram for
# each parameter.
panel.cor = function(x, y, digits=2, prefix="r=", cex.cor)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y))
  txt <- format(c(r, 0.123456789), digits=digits)[1]
  txt <- paste(prefix, txt, sep="")
  if(missing(cex.cor)) cex <- 0.6/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex)
}

panel.hist = function(x, ...)
{
    usr <- par("usr"); on.exit(par(usr))
    par(usr = c(usr[1:2], 0, 1.5) )
    h <- hist(x, plot = FALSE)
    breaks <- h$breaks; nB <- length(breaks)
    y <- h$counts; y <- y/max(y)
    rect(breaks[-nB], 0, breaks[-1], y, col="gray", ...)
}
  
# Note that panel.smooth is built in, so we don't need to define it.
pairs(raw, lower.panel = panel.cor, diag.panel = panel.hist, upper.panel = panel.smooth)

# Save the plot to a PDF in the working directory
# In R-Studio, you can do this either using the menus
#        Plots > Save plot as PDF...
#
# ... or using standard R commands
pdf("pairsplot.pdf")
pairs(raw, lower.panel = panel.cor, diag.panel = panel.hist, upper.panel = panel.smooth)
dev.off()

  
# Save the plot as a JPEG, too, for use on a webpage
# In R-Studio, you can do this either using the menus
#        Plots > Save plot as image...
#
# ... or using standard R commands
jpeg("pairsplot.jpg")
pairs(raw, lower.panel = panel.cor, diag.panel = panel.hist, upper.panel = panel.smooth)
dev.off()


# 5. Install any packages you need for more advanced/specialized analyses
#    Be sure to install anything the package depends upon, too
#    In R-Studio, you can do this either using the menus
#        Tools > Install packages...
#
#    ... or using standard R commands
install.packages("granova", dependencies = TRUE)

# 6. Include any "library(...)" commands in your history, if you've
#    used any additional packages, so that you can clearly see which
#    packages you've relied upon.
library(granova)

#    You can find out how to use the package with R's help commands
?granova

#    Since my data represents a dependent sample, I'll focus on that
#    Examples are found by looking at the help for a given function
?granova.ds

#    and scrolling to the bottom of that help page.

# granova.ds needs a data paramater that's just our dependent scores
head(raw)
head(raw[, 1:2])

granova.ds(raw[, 1:2])

# preferably with the POST scores as column 1 and the PRE column 2
granova.ds(raw[, 1:2], revc = TRUE)



# Save our workspace with all the data objects we've created so 
# we can continue working with it later
# In R-Studio, you can do this either using the menus
#        Workspace > Save Workspace as...
#
# ... or using standard R commands
save.image("20110617-Workspace.RData")

# Save our history, in case we want to repeat this analysis
savehistory("20110617-FirstGlance.Rhistory")

#end our R session
quit()







