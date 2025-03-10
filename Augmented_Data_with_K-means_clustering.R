
# ----------------------------------------------------------------------- column clustering algorithm

dataframe_column_grouping <- function(input_df, group_num){
    
    cor_mat <- round(cor(input_df), 3) # correlation matrix
    
    # The distance matrix (aka dissimilarity matrix) will be used so that the grouping based in the 
    # euclidean distance (default for k-clustering in R) returns groups
    # with vectors that are correlated. 
    
    distances <- ifelse(cor(cor_mat) < 0 , abs(-1-cor(cor_mat)), abs(1-cor_mat))
    # Perform the k-means clustering algorithm. 
  
    k_means <- kmeans(t(distances), centers = group_num)
    
    column_clustered_df <- as.data.frame(t(k_means$cluster))
    
    col_groups <- sort((as.vector(unlist(column_clustered_df[1,]))))
    
    # reorder the column so that columns with high similarity are next to each other.
    col_permuted_df <- input_df[ ,order((as.vector(unlist(column_clustered_df[1,]))))]
    
    outputs <- list(col_permuted_df, col_groups) 

return(outputs)
}

dataframe_column_grouping_list <- dataframe_column_grouping(data,3) 
grouped_data <- dataframe_column_grouping_list[[1]]
col_group_vec <- dataframe_column_grouping_list[[2]]  


# --------------------------------------------------------------------- create colored correlation plot

colored_correlation_plot <- function(data){
  
  correlation_matrix <- cor(data) %>% round(3)
  
  corrplot(correlation_matrix, method = "color", 
           type = "upper",
           tl.col = "black",   # Text label color
           tl.srt = 45,        # Text label rotation
           addCoef.col = "black",  # Add correlation coefficients
           number.cex = 0.7)   # Size of the numbers
           #method = "pie",
           
}

colored_correlation_plot(data)


col_subset_list <- list()

for( colmn in c(1:length(unique(col_group_vec)))){
  
  focal_df <- data.frame( grouped_data[ ,(which(col_group_vec == colmn))] )
  colnames(focal_df) <- colnames(grouped_data)[which(col_group_vec == colmn)]
  col_subset_list[[ length(col_subset_list)+1 ]] <- focal_df
}

partition_size <- as.integer(nrow(data) / (length(col_subset_list)))

for(df in c(1:(length(col_subset_list)-1))){

  focal_df <- col_subset_list[[df]]
  focal_rows_start <- ((df*partition_size) - (partition_size - 1))
  focal_rows_start
  focal_rows_end <- (focal_rows_start + (partition_size - 1))
  
  if(df == length(col_subset_list) ){
    focal_rows_end <- nrow(data)
  }
  
  focal_rows_indices <- seq(from = focal_rows_start, to = focal_rows_end, by = 1)
  focal_df[focal_rows_indices, ] <- focal_df[sample(focal_rows_indices), ]
  col_subset_list[[df]] <- focal_df
}


synthetic_df <- do.call(cbind, col_subset_list)


