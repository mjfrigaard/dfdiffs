library(fs)
library(stringr)
library(purrr)

# uploadDataDemo
upload_r_files <- list.files("./R", full.names = TRUE, pattern = "^upload|^load")
upload_dev_files <- str_replace_all(string = upload_r_files, pattern = "./R/", "dev/uploadDataDemo/")
# copy files over
walk2(.x = upload_r_files, .y = upload_dev_files,
  .f = fs::file_copy, overwrite = TRUE)

# displayDataDemo
display_r_files <- list.files("./R", full.names = TRUE, pattern = "^display|^upload|^load")
display_dev_files <- str_replace_all(string = display_r_files, pattern = "./R/", "dev/displayDataDemo/")
# copy files over
walk2(.x = display_r_files, .y = display_dev_files,
  .f = fs::file_copy, overwrite = TRUE)

# selectDataDemo
select_r_files <- list.files("./R", full.names = TRUE, pattern = "^select|^display|^upload|^load")
select_dev_files <- str_replace_all(string = select_r_files, pattern = "./R/", "dev/selectDataDemo/")
# copy files over
walk2(.x = select_r_files, .y = select_dev_files,
  .f = fs::file_copy, overwrite = TRUE)
