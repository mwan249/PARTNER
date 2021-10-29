library(tidyverse)

ReadRedcapReport = function(
  token = Sys.getenv("redcap_token"),
  url = "https://redcap.emory.edu/api/",
  report_id = '29228',
  format='csv',
  csvDelimiter='',
  rawOrLabel='raw',
  rawOrLabelHeaders='raw',
  exportCheckboxLabel='false',
  returnFormat='json',
  ...
)
{
  form.data <- list(token=token,
                    content='report',
                    format=format,
                    report_id=as.character(report_id),
                    csvDelimiter=csvDelimiter,
                    rawOrLabel=rawOrLabel,
                    rawOrLabelHeaders=rawOrLabelHeaders,
                    exportCheckboxLabel=exportCheckboxLabel,
                    returnFormat=returnFormat
  )
  response <- httr::POST(url, body = form.data, encode = "form")
  readr::read_csv(httr::content(response,as="text"),...)
}


DownloadData = function(){
  d = ReadRedcapReport(report_id='31632')
  d
}