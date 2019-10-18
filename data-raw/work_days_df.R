## code to prepare `work_days_df` dataset goes here
work_days_df <- arrow::read_feather("C:/Users/xmxf129/iCloudDrive/Desktop/NU/R/work_days_df.feather")

usethis::use_data(work_days_df)
