
# Data Augmentation with K-means clustering algorithm.
This repository contains R code that augments an existing small tabular data that can then be used for a machine learning algorithm (i.e. neural network, linear regression, random forest etc). The algorithm works by exploiting the k-means clustering algorithm by applying it on the dissimilarity matrix of the data’s columns. Clustering similar columns into groups then randomly permuting rows in those clustered groups effectively “populates” the feature space of the dataset yet maintains the underlying correlations that make up critical relationships of the dataset. The k-means clustering algorithm works using the euclidean distance by default (hence why I apply it on a dissimilarity matrix).

![Visualization_of_concept](synthetic_dataset.png)

# Explanation of the Files in this Repository: 

## Starting_Data_Correlation_Grid.png

This is the correlation matrix for the data. Columns {1,2, and 3} are highly correlated thus would be clustered together by the k-means algorithm while columns {5 and 6} would be in another cluster, while {7 and 8} would be in another (assuming 3 clusters was found to be optimal for the k-means algorithm for this dataset). 

![Initial_correlation_grid](Starting_Data_Correlation_Grid.png)

## Augmented_Data_with_k-means_Clustering.R

This R code chunk takes in a dataset and forms the dissimilarity matrix (line #12). The columns are then grouped and rearranged in the dataframe so that columns with high levels of similarity are placed next to each other (line #22) and eventually grouped together into a list (line #59). A small section of rows from each group are selected and randomly permuted (lines 67 -76). And the column subsets are replaced back into the list. Finally the column subsets in the list are all recombined into a singular dataframe (line #81). 


## Augemented_Data_Correlation_Matrix.png

This is the correlation matrix for the augmented data. As we can see the correlations between the columns remain very similar to that of the initial dataset. 
