url <- "https://redcap.emory.edu/api/"
formData <- list("token"=token,
                 content='report',
                 format='json',
                 report_id='31632',
                 csvDelimiter='',
                 rawOrLabel='raw',
                 rawOrLabelHeaders='raw',
                 exportCheckboxLabel='false',
                 returnFormat='json'
)
response <- httr::POST(url, body = formData, encode = "form")
result <- httr::content(response)
result


