Use healthcare_dataset;
select * from hc_data;

update hc_data
set Admit_Date = str_to_date(Admit_Date, '%d-%m-%Y');
alter table hc_data
modify Admit_Date date;

update hc_data
set Discharge_Date = str_to_date(Discharge_Date, '%d-%m-%Y');
alter table hc_data
modify Discharge_Date date;

update hc_data
set Followup_Date = str_to_date(Followup_Date, '%d-%m-%Y');
alter table hc_data
modify Followup_Date date;

# What is the total number of patients admitted during the given date range?
select 
	date_format(Admit_Date, '%Y-%m-01 00:00:00') as MoM, 
	count(`Patient_ID`) as patients_count from hc_data
group by 1;

# Find the number of patients diagnosed with each type of disease (e.g., Viral Infection, Typhoid, Malaria, Flu, Pneumonia).
select 
	Diagnosis,  
	count(`Patient_ID`) as count_patient from hc_data
group by 1
;

# Calculate the average length of stay for patients admitted to different ward types (General, ICU, Private).
select 
	Bed_Occupancy, 
	round(avg(Discharge_Date - Admit_Date),2) as avg_stay_hospital 
from hc_data
group by 1
;

# Identify the doctor who treated the most patients during the given date range.
select doctor, count(patient_id) as count_patient from hc_data
group by 1 
order by 2 desc
limit 1
;
# Determine the average billing amount for each type of test (MRI, CT Scan, X-Ray, Blood Test, Ultrasound).
select test, round(avg(Billing_Amount),2) as avg_test_bill from hc_data
group by 1
order by 2 desc
;


# Calculate the total revenue generated from the health insurance amounts.
select sum(Health_Insurance_Amount) as total_revenue from hc_data;

# Determine the average feedback score for each doctor.
select Doctor, round(avg(Feedback),2) as avg_feedback from hc_data
group by 1;

# Find the patients whose billing amount exceeds the health insurance amount by a significant margin like 10%.
select Patient_ID, 
case when Billing_Amount > 1.1 * Health_Insurance_Amount then 1 else 0
end 
as margin
from hc_data
;















