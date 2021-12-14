library(tidyverse)

ReadRedcapReport = function(
  token = Sys.getenv("redcap_token"),
  url = "https://redcap.emory.edu/api/",
  report_id = '31632',
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

DownloadData = function(event_name = c(
  "screening_arm_2",
  "informed_consent_arm_2",
  "prefg_arm_1",
  "randomization_arm_3",
  "baseline_arm_3",
  "3month_arm_3",
  "78_month_screening_arm_3",
  "12month_arm_3",
  "intervention_arm_3",
  "monthly_checkin_arm_3")) ReadRedcapReport(report_id='31632') |> 
  mutate(sex = case_when(
    sex___1 == 1 ~ "Male",
    sex___2 == 1 ~ "Female"
  )) |> 
  select(age, sex, everything()) |> 
  rename(Age = age, Sex = sex) |> 
  rename(MoCA = moca_total) |> 
  rename(BDIII = bdi_total_score) |> 
  rename(TICS = total_score) |> 
  group_by(participants) |> 
  fill(c(Age,Sex),.direction="downup") |> 
  ungroup() |> 
  filter(redcap_event_name %in% event_name)

FindMissing = function(d,varname){
  dmiss = d[,c("participants",varname)]
  d[is.na(d[,varname]),"participants"]
}

