WITH incorrect_records AS  
 (SELECT       
 auditor_report.location_id,  
 visits.record_id,    
 employee.employee_name AS employee_name,    
 auditor_report.true_water_source_score AS auditor_score,    
 water_quality.subjective_quality_score AS surveyor_score  
 FROM      
 auditor_report  
 JOIN       
 visits   
 ON      
 auditor_report.location_id = visits.location_id 
 JOIN    
 water_quality  
 ON   
 visits.record_id = water_quality.record_id    
 JOIN     
 employee  
 ON      
 visits.assigned_employee_id = employee.assigned_employee_id  
 WHERE    
 auditor_report.true_water_source_score - water_quality.subjective_quality_score <> 0      AND visits.visit_count = 1 ),       
 
error_count AS
( SELECT 
	 employee_name,   
    COUNT(*) AS number_of_mistakes
    
FROM  incorrect_records
GROUP BY employee_name)
 
 SELECT
	employee_name,
	number_of_mistakes
FROM
	error_count
WHERE
number_of_mistakes > (SELECT round(AVG(number_of_mistakes)) AS avg_error_count_per_empl
FROM error_count);
