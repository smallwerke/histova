test_that("pi converts", {
  expect_equal(convert_text("Is it finally &Pi; day?"), "Is it finally \U03A0 day?")
})

test_that("Tau converts at head of string", {
  expect_equal(convert_text("&Tau; begins the day."), "\U03A4 begins the day.")
})
