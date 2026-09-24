test_that("launch_app() builds a shiny.appobj without error", {
  app <- launch_app()
  expect_s3_class(app, "shiny.appobj")
})

test_that("launch_app_dev() builds a shiny.appobj without error", {
  app <- launch_app_dev()
  expect_s3_class(app, "shiny.appobj")
})

test_that("launch_upload_demo() builds a shiny.appobj without error", {
  app <- launch_upload_demo()
  expect_s3_class(app, "shiny.appobj")
})

test_that("launch_select_demo() builds a shiny.appobj without error", {
  app <- launch_select_demo()
  expect_s3_class(app, "shiny.appobj")
})
