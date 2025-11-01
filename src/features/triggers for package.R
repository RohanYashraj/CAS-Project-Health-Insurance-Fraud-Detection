#' Age-based fraud trigger
#' @description The triggers file contains reasonable age ranges for getting a certain medical procedure done. This function creates a flag to identify all the claimants whose age is falls outside this range.
#'              The age should be specified consistently in the claims_file and the triggers_file for this function to work.

#' @param claims_file data set containing claim-level information
#' @param age_column_name column within the claims file that indicates the age of the policy holder
#' @param triggers_file file containing the age ranges for each procedure code
#' @param procedure_code column in the triggers_file that contains the code/identifier for the medical procedure
#' @param lower_age_limit column in the triggers_file that contains the lower age limit for getting the procedure done
#' @param upper_age_limit column in the triggers_file that contains the upper age limit for getting the procedure done
#'
#' @return input claims_file with age_flag column
#' @export
#'
#' @examples
age_trigger_map <-
  function(claims_file, age_column_name, triggers_file, procedure_code, lower_age_limit, upper_age_limit){

    stopifnot("age_column_name doesn't exist in the claims_file"=age_column_name %in% colnames(claims_file))
    stopifnot("procedure_code doesn't exist in the claims_file"=procedure_code %in% colnames(claims_file))

    stopifnot("triggers file doesn't have the required columns"= c(procedure_code, lower_age_limit, upper_age_limit) %in% colnames(triggers_file))

    stopifnot("age_column_name has to be a numeric field"= is.numeric(claims_file[[age_column_name]]))
    stopifnot("lower_age_limit has to be a numeric field"= is.numeric(triggers_file[[lower_age_limit]]))
    stopifnot("upper_age_limit has to be a numeric field"= is.numeric(triggers_file[[upper_age_limit]]))

    age_column_name <- sym(age_column_name)
    lower_age_limit <- sym(lower_age_limit)
    upper_age_limit <- sym(upper_age_limit)

    claims_file %>%
      left_join(triggers_file, by = procedure_code) %>%
      mutate(age_flag = case_when((!!age_column_name < !!lower_age_limit) & (!!age_column_name > !!upper_age_limit) ~ 1,
                                  TRUE ~ 0))
  }


#' Gender-based fraud trigger
#' @description Some procedures are gender specific. This function creates a red flag if a procedure is performed for a claimant for a wrong gender. For example gynacologic procedure for a male claimant will raise a redflag.
#'              The gender should be specified consistently in the claims_file and the triggers_file for this function to work.
#' @param claims_file   data set containing claim-level information
#' @param gender_column_name column in the claims_file that contains the gender of the policy holder
#' @param triggers_file file containing the gender specification for each procedure code
#' @param procedure_code column in the triggers_file that contains the code/identifier for the medical procedure
#' @param gender_trigger column in the triggers_file that contains the specification of gender for each medical procedure
#'
#' @return input claims_file with gender_flag column
#' @export
#'
#' @examples
gender_trigger_map <- function(claims_file, gender_column_name, triggers_file, procedure_code, gender_trigger){

  stopifnot("gender_column_name doesn't exist in the claims_file"=gender_column_name %in% colnames(claims_file))
  stopifnot("procedure_code doesn't exist in the claims_file"=procedure_code %in% colnames(claims_file))

  stopifnot("triggers file doesn't have the required columns"= c(procedure_code, gender_trigger) %in% colnames(triggers_file))

  stopifnot("gender_column_name must be Male or Female"= unique(claims_file[[gender_column_name]]) %in% c("Male", "Female"))

  gender_trigger <- sym(gender_trigger)
  gender_column_name <- sym(gender_column_name)

  claims_file %>%
    left_join(triggers_file, by = procedure_code) %>%
    mutate(gender_flag = case_when(!!gender_trigger == "Both" ~ 0,
                                   !!gender_trigger != !!gender_column_name ~ 1,
                                   TRUE ~ 0))

}



#' Close proximity-based fraud trigger
#' @description a claim is in close proximity if the treatment start date is very close to the policy commencement date. This function  will raise a flag for such claims.
#'
#' @param claims_file data set containing claim-level information
#' @param treatment_start_date column in the claims_file that contains the starting date of the treatment
#' @param policy_commencement_date column in the claims_file that contains the commencement date of the policy
#' @param triggers_file file containing the number of days for each procedure within which we can call it as a close proximity claim
#' @param procedure_code column in the triggers_file that contains the code/identifier for the medical procedure
#' @param close_prox_days column in the triggers_file that contains the number of days for each procedure within which can call it as a close proximity claim
#'
#' @return input claims_file with close_prox_flag and claim_duration_days columns
#'
#' @export
#'
#' @examples
close_prox_trigger_map <- function(claims_file, treatment_start_date, policy_commencement_date, triggers_file, procedure_code, close_prox_days){

  stopifnot("treatment_start_date doesn't exist in the claims_file"=treatment_start_date %in% colnames(claims_file))
  stopifnot("policy_commencement_date doesn't exist in the claims_file"=policy_commencement_date %in% colnames(claims_file))
  stopifnot("procedure_code doesn't exist in the claims_file"=procedure_code %in% colnames(claims_file))

  stopifnot("triggers file doesn't have the required columns"= c(procedure_code, close_prox_days) %in% colnames(triggers_file))

  stopifnot("treatment_start_date is not in date format"=is.Date(claims_file[[treatment_start_date]]))
  stopifnot("policy_commencement_date is not in date format"=is.Date(claims_file[[policy_commencement_date]]))
  stopifnot("close_prox_days is not in numeric format"=is.numeric(triggers_file[[close_prox_days]]))

  treatment_start_date <- sym(treatment_start_date)
  policy_commencement_date <- sym(policy_commencement_date)
  close_prox_days <- sym(close_prox_days)

  claims_file %>%
    left_join(triggers_file, by = procedure_code) %>%
    mutate(claim_duration_days = !!treatment_start_date - !!policy_commencement_date,
           close_prox_flag = case_when(claim_duration_days < !!close_prox_days ~ 1,
                                       TRUE ~ 0))

}


#' claim amount-based fraud trigger
#' @description For each procedure there is a specific amount that is generally agreed between the insurer and the medical service provider. This is especially the case for cashless claim processing. If the claim amount is higher than this agreed procedure specific amount it will raise a flag.
#'
#' @param claims_file data set containing claim-level information
#' @param claim_paid_field column in the claims_file that contains the claim amount paid by the insurer
#' @param triggers_file file containing the agreed specific amount for each procedure
#' @param procedure_code column in the triggers_file that contains the code/identifier for the medical procedure
#' @param procedure_amount_field column in the triggers_file that contains the agreed specific amount for each procedure
#'
#' @return input claims_file with claim_amount_ratio and claim_amount_flag columns
#'
#' @export
#'
#' @examples
claim_amount_trigger_map <- function(claims_file, claim_paid_field, triggers_file, procedure_code, procedure_amount_field){

  stopifnot("claim_paid_field doesn't exist in the claims_file"=claim_paid_field %in% colnames(claims_file))
  stopifnot("procedure_code doesn't exist in the claims_file"=procedure_code %in% colnames(claims_file))

  stopifnot("triggers file doesn't have the required columns"= c(procedure_code, procedure_amount_field) %in% colnames(triggers_file))

  stopifnot("claim_paid_field is not in numeric format"=is.numeric(claims_file[[claim_paid_field]]))
  stopifnot("procedure_amount_field is not in numeric format"=is.numeric(triggers_file[[procedure_amount_field]]))


  procedure_amount_field <- sym(procedure_amount_field)
  claim_paid_field <- sym(claim_paid_field)

  claims_file %>%
    left_join(triggers_file, by = procedure_code) %>%
    mutate(claim_amount_ratio = !!claim_paid_field / !!procedure_amount_field,
           claim_amount_flag = case_when(claim_amount_ratio != 1 ~ 1,
                                         TRUE ~ 0))

}


#' Hospital admitted days-based fraud trigger
#' @description For each procedure there is a reasonable number of days a claimant could be admitted in the hospital.If the number of days actually admitted is higher than what is reasonable for that procedure this function will raise flag.
#' @param claims_file  data set containing claim-level information
#' @param no_of_days_stayed column in the claims_file that contains the number of days actually admitted in the hospital
#' @param triggers_file file containing the reasonable number of days a claimant could be admitted in the hospital for each procedure
#' @param procedure_code column in the triggers_file that contains the code/identifier for the medical procedure
#' @param admission_days_trigger column in the triggers_file that contains the reasonable number of days a claimant could be admitted in the hospital for each procedure
#'
#' @return input claims_file with no_days_ratio and hosp_days_flag columns
#' @export
#'
#' @examples
hosp_days_trigger_map <- function(claims_file, no_of_days_stayed, triggers_file, procedure_code, admission_days_trigger){

  stopifnot("no_of_days_stayed doesn't exist in the claims_file"=no_of_days_stayed %in% colnames(claims_file))
  stopifnot("procedure_code doesn't exist in the claims_file"=procedure_code %in% colnames(claims_file))

  stopifnot("triggers file doesn't have the required columns"= c(procedure_code, admission_days_trigger) %in% colnames(triggers_file))

  stopifnot("no_of_days_stayed is not in numeric format"=is.numeric(claims_file[[no_of_days_stayed]]))
  stopifnot("admission_days_trigger is not in numeric format"=is.numeric(triggers_file[[admission_days_trigger]]))


  no_of_days_stayed <- sym(no_of_days_stayed)
  admission_days_trigger <- sym(admission_days_trigger)

  claims_file %>%
    left_join(triggers_file, by = procedure_code) %>%
    mutate(hosp_days_flag = case_when(!!no_of_days_stayed > !!admission_days_trigger ~ 1,
                                      TRUE ~ 0))

}


#' treatment date validity-based fraud trigger
#' @description For each policy there is a commencement and termination date within which the claim event(treatment) should occur. If the treatment date is outside these dates it will raise a flag
#' @param claims_file data set containing claim-level information
#' @param treatment_start_date_field column in the claims_file that contains the starting date of the treatment
#' @param policy_commencement_date_field column in the claims_file that contains the commencement date of the policy
#' @param policy_termination_date_field column in the claims_file that contains the termination date of the policy
#'
#' @return input claims_file with treatment_date_validity_flag column
#' @export
#'
#' @examples
treatment_date_validity_trigger_map <- function(claims_file, treatment_start_date_field, policy_commencement_date_field, policy_termination_date_field){

  stopifnot("treatment_start_date_field doesn't exist in the claims_file"=treatment_start_date_field %in% colnames(claims_file))

  stopifnot("policy_commencement_date_field doesn't exist in the claims_file"=policy_commencement_date_field %in% colnames(claims_file))

  stopifnot("policy_termination_date_field doesn't exist in the claims_file"=policy_termination_date_field %in% colnames(claims_file))

  stopifnot("treatment_start_date_field is not in correct format"=is.Date(claims_file[[treatment_start_date_field]]))
  stopifnot("policy_commencement_date_field is not in correct format"=is.Date(claims_file[[policy_commencement_date_field]]))
  stopifnot("policy_termination_date_field is not in correct format"=is.Date(claims_file[[policy_termination_date_field]]))


  treatment_start_date_field = sym(treatment_start_date_field)
  policy_commencement_date_field = sym(policy_commencement_date_field)
  policy_termination_date_field = sym(policy_termination_date_field)

  claims_file %>%
    mutate(treatment_date_validity_flag = case_when((as.numeric(!!treatment_start_date_field - !!policy_commencement_date_field) < 0) | (as.numeric(!!policy_termination_date_field- !!treatment_start_date_field) < 0) ~ 1,
                                                    TRUE ~ 0))

}


#' claim reporting delay based fraud trigger
#' @description For each policy there is a treatment start date and treatment end date. The claim should be reported within the permissible days after treatment end date(discharge). If the claim reported date is outside the permissible limit it will raise a flag
#' @param claims_file data set containing claim-level information
#' @param treatment_end_date_field column in the claims_file that contains the ending date of the treatment
#' @param claim_reported_date_field column in the claims_file that contains the claim reported date of the policy
#' @param claim_delay_days a user input that sets a permissible time period within which a claim should be reported
#'
#' @return input claims_file with claims_delay_flag column
#' @export
#'
#' @examples
claim_reported_delay_trigger_map <- function(claims_file, treatment_end_date_field, claim_reported_date_field,claim_delay_days){
  
  stopifnot("treatment_end_date_field doesn't exist in the claims_file"=treatment_end_date_field %in% colnames(claims_file))
  
  stopifnot("claim_reported_date_field doesn't exist in the claims_file"=claim_reported_date_field %in% colnames(claims_file))
  
  
  stopifnot("treatment_end_date_field is not in correct format"=is.Date(claims_file[[treatment_end_date_field]]))
  stopifnot("claim_reported_date_field is not in correct format"=is.Date(claims_file[[claim_reported_date_field]]))
  stopifnot("claim_delay_days is not in correct format"=is.numeric(claim_delay_days))
  
  
  treatment_end_date_field = sym(treatment_end_date_field)
  claim_reported_date_field = sym(claim_reported_date_field)
  
  claims_file %>%
    mutate(claim_reported_delay_flag = case_when((as.numeric(!!claim_reported_date_field - !!treatment_end_date_field  ) > claim_delay_days)  ~ 1,
                                                    TRUE ~ 0))
  
}




#' Empanelled hospitals(medical service providers)-based fraud trigger
#' @description The insurer generally empanells hospitals to service its policy holders. In the process of empanelment the insurer ensures that the hospital has the required facilities and also agrees the tarrif for each of the treatments. If the hospital mentioned is not a part of the empanelled list of hospitals it will raise a flag
#' @param claims_file  data set containing claim-level information
#' @param hospital_id_field column with unique identity number of the hospitals
#' @param empanelled_hospitals_list file containing the list of all the empanelled hospitals
#' @param empanelled_hospital_id column in the empanelled_hospital_list file that contains all the unique hospital ids
#'
#' @return input claims_file with hospital_empanelled_flag column
#' @export
#'
#' @examples
hospital_empanelled_trigger_map <- function(claims_file, hospital_id_field,empanelled_hospitals_list,empanelled_hospital_id){

  stopifnot("hospital_id_field doesn't exist in the claims_file"=hospital_id_field %in% colnames(claims_file))

  stopifnot("hospital empanellment file doesn't have the required columns"= c(empanelled_hospital_id) %in% colnames(empanelled_hospitals_list))

  stopifnot("hospital_id_field is not in correct format"=is.character(claims_file[[hospital_id_field]]))

  hospital_id_field_1 = sym(hospital_id_field)
  empanelled_hospital_id_1 = sym(empanelled_hospital_id)

  empanelled_hospitals_list <-
    empanelled_hospitals_list %>%
    mutate(hospital_empanelled_flag = 0) %>%
    rename(!!hospital_id_field_1 := !!empanelled_hospital_id_1)


  claims_file %>%
    left_join(empanelled_hospitals_list, by = hospital_id_field) %>%
    mutate(hospital_empanelled_flag = ifelse(is.na(hospital_empanelled_flag), 1 , hospital_empanelled_flag))

  
}



#' Claim count-based fraud trigger
#' @description We don't expect the policyholder to get a given medical treatment more than few times a year, depending on the nature of the treatment. If the policy holder has taken a given treatment unreasonably high number of times, it needs to be investigated for fraud. This the function identifies all such policyholders.
#' @param claim_count file that contains the total number of times a policy holder claimed for a given procedure in a given time period
#' @param claim_count_pa column that contains the total number of claims per year by a policy holder
#' @param claim_count_trigger_file file containing maximum number of  times a policy holder can claim for each procedure
#' @param procedure_code_field column in the claim_count_trigger_file that contains the code/identifier for each medical procedure
#' @param claim_count_trigger column in the claim_count_trigger_file that indicates the number of times a procedure can be claimed by a policyholder before it can be considered as potential fraud
#'
#' @return input claims_file with claim_count_flag column
#' @export
#'
#' @examples
claim_count_trigger_map <- function(claim_count,claim_count_pa,claim_count_trigger_file,procedure_code_field, claim_count_trigger ){

  stopifnot("claim_count_pa doesn't exist in the claim_count file"= claim_count_pa %in% colnames(claim_count))


  stopifnot("claim_count_pa is not in correct format"=is.numeric(claim_count[[claim_count_pa]]))
  stopifnot("claim_count_trigger is not in correct format"=is.numeric(claim_count_trigger_file[[claim_count_trigger]]))
  claim_count_pa = sym(claim_count_pa)
  claim_count_trigger = sym(claim_count_trigger)



  claim_count %>%
    left_join(claim_count_trigger_file, by = procedure_code_field) %>%
    mutate(claim_count_flag = case_when(claim_count_pa > claim_count_trigger ~ 1,
                                        TRUE ~ 0))

}


#' Procedure overlap-based fraud trigger
#' @description There could be some overlaps between procedures in practice. For example, if a claim is made for normal delivery, a claim for cezarean after a month is not possible and should be investigated for fraud.
#' @param claims_file data set containing claim-level information
#' @param procedure_code_field column in the claims_file that contains the code for each medical procedure
#' @param insured_id_field column in the claims_file that contains unique identity number for each policy holder
#' @param overlap_list_file file indicating the overlaps between the procedures
#' @param procedure_code_map_field1 column with code of first procedure to in overlap list file
#' @param procedure_code_map_field2 column with code of second procedure in overlap list file
#' @param overlap_field column in the overlap_list_file stating the overlap of the procedure - true or false
#'
#' @return input claims_file with package_overlap_flag column
#' @export
#'
#' @examples
package_overlap_trigger_map <- function(claims_file, procedure_code_field,insured_id_field, overlap_list_file, procedure_code_map_field1, procedure_code_map_field2, overlap_field){

  stopifnot("procedure_code_field doesn't exist in the claims_file"= procedure_code_field %in% colnames(claims_file))
  stopifnot("insured_id_field doesn't exist in the claims_file"= insured_id_field %in% colnames(claims_file))
  stopifnot("procedure_code_map_field1 doesn't exist in the overlap_list_file"= procedure_code_map_field1 %in% colnames(overlap_list_file))
  stopifnot("procedure_code_map_field1 doesn't exist in the overlap_list_file"= procedure_code_map_field1 %in% colnames(overlap_list_file))
  stopifnot("overlap_field doesn't exist in the overlap_list_file"= overlap_field %in% colnames(overlap_list_file))

  procedure_code_field_x <- sym(procedure_code_field)
  insured_id_field_x <- sym(insured_id_field)
  procedure_code_map_field1_x <- sym(procedure_code_map_field1)
  procedure_code_map_field2_x <- sym(procedure_code_map_field2)
  overlap_field_x <- sym(overlap_field)

  procedure_list <-
    claims_file %>%
    dplyr::select(!!insured_id_field_x,!!procedure_code_field_x)

  primary_procedure_code.x = paste0(procedure_code_field,".x")
  primary_procedure_code.y = paste0(procedure_code_field,".y")

  overlap_map <-
    procedure_list %>%
    left_join(procedure_list, by = insured_id_field) %>%
    filter(procedure_code_map_field1_x != procedure_code_map_field2_x) %>%
    left_join(overlap_list_file, by = c(primary_procedure_code.x = procedure_code_map_field1 ,primary_procedure_code.y = procedure_code_map_field2)) %>%
    group_by(!!insured_id_field_x) %>%
    summarise(overlap = sum(!!overlap_field_x))

  claims_file %>%
    left_join(overlap_map, by = insured_id_field) %>%
    rename(package_overlap_flag = overlap)


}



#' Hospital distance-based fraud trigger
#' @description It is reasonable to expect that the policyholder gets treated in the nearest hospital. If the distance between the residence location and the hospital location is more than a defined threshold, this function will raise a flag
#' @param claims_file data set containing claim-level information
#' @param residence_location_field column in the claims_file with the location of the policy holder
#' @param hospital_location_field column in the claims_file with the location of the hospital
#' @param hospital_distance_file file with reference table of distances between places in the data
#' @param residence_location_map column in the hospital_distance_file  with the list of all possible residence locations
#' @param hospital_location_map column in the hospital_distance_file with all the possible hospital locations
#' @param hospital_distance_field column in the hospital_distance_file that contains the distance between the hospital location and the residence location
#' @param distance_threshold  distance level beyond which claim is flagged for fraud
#'
#' @return input claims_file with hospital_distance_flag column
#' @export
#'
#' @examples
hospital_distance_trigger_map <- function(claims_file, residence_location_field, hospital_location_field, hospital_distance_file, residence_location_map, hospital_location_map,hospital_distance_field, distance_threshold){

  stopifnot("residence_location_field doesn't exist in the claims_file"= residence_location_field %in% colnames(claims_file))
  stopifnot("hospital_location_field doesn't exist in the claims_file"= hospital_location_field %in% colnames(claims_file))
  stopifnot("residence_location_map doesn't exist in the hospital_distance_file"= residence_location_map %in% colnames(hospital_distance_file))
  stopifnot("hospital_location_map doesn't exist in the hospital_distance_file"= hospital_location_map %in% colnames(hospital_distance_file))


  stopifnot("distance_threshold is not in correct format"=is.numeric(distance_threshold))
  
  hospital_distance <- sym(hospital_distance_field)

  claims_file %>% 
    left_join( hospital_distance_file, by = setNames(c(residence_location_map, hospital_location_map),c(residence_location_field, hospital_location_field))) %>%
    mutate(hospital_distance_flag = ifelse(!!hospital_distance > distance_threshold,1,0))

}
