select answers.survey_id, 0 as points_version, date(str_to_date(answers.date_survey_taken, '%d/%m/%Y')) as date_survey_taken, answers.entity_id, answers.entity_type_id,

(
case
when answers.Q1='Balochistan' then 0
when answers.Q1='Northwest Frontier Province' then 9
when answers.Q1='Sindh' then 11
when answers.Q1='Punjab or Islamabad' then 12
end +
case
when answers.Q2='Five or more' then 0
when answers.Q2='Four' then 6
when answers.Q2='Three' then 11
when answers.Q2='Two' then 15
when answers.Q2='One' then 22
when answers.Q2='None' then 31
end +
case
when answers.Q3='Not all' then 0
when answers.Q3='All, or no children ages 5 to 13' then 5
end +
case
when answers.Q4='Two or more' then 0
when answers.Q4='One' then 5
when answers.Q4='None' then 12
end +
case
when answers.Q5='Less than Class 1 or no data' then 0
when answers.Q5='No female head/spouse' then 4
when answers.Q5='Class 1 or higher' then 6
end +
case
when answers.Q6='Others' then 0
when answers.Q6='Hand pump, covered/closed well, motorized pump/tube well, or piped water' then 3
end +
case
when answers.Q7='None or other' then 0
when answers.Q7='Flush connected to pit/septic tank or open drain' then 2
when answers.Q7='Flush connected to public sewerage' then 4
end +
case
when answers.Q8='No' then 0
when answers.Q8='Yes' then 12
end +
case
when answers.Q9='No' then 0
when answers.Q9='Yes' then 3
end +
case
when answers.Q10='No' then 0
when answers.Q10='Yes' then 12
end
) 
as ppi_score
from
(SELECT
qg.id as survey_id,
GROUP_CONCAT(if(q.nickname = 'ppi_pakistan_2009_survey_date', qgr.response, NULL)) AS 'date_survey_taken',
qgi.entity_id as entity_id,
es.entity_type_id as entity_type_id,
GROUP_CONCAT(if(q.nickname = 'ppi_pakistan_2009_province', qgr.response, NULL)) AS 'Q1',
GROUP_CONCAT(if(q.nickname = 'ppi_pakistan_2009_family_members_0_to_13', qgr.response, NULL)) AS 'Q2',
GROUP_CONCAT(if(q.nickname = 'ppi_pakistan_2009_family_members_5_to_13_in_school', qgr.response, NULL)) AS 'Q3',
GROUP_CONCAT(if(q.nickname = 'ppi_pakistan_2009_employed_elementary_work', qgr.response, NULL)) AS 'Q4',
GROUP_CONCAT(if(q.nickname = 'ppi_pakistan_2009_female_head_education_level', qgr.response, NULL)) AS 'Q5',
GROUP_CONCAT(if(q.nickname = 'ppi_pakistan_2009_water_source', qgr.response, NULL)) AS 'Q6',
GROUP_CONCAT(if(q.nickname = 'ppi_pakistan_2009_toilet_type', qgr.response, NULL)) AS 'Q7',
GROUP_CONCAT(if(q.nickname = 'ppi_pakistan_2009_owns_refrigerator', qgr.response, NULL)) AS 'Q8',
GROUP_CONCAT(if(q.nickname = 'ppi_pakistan_2009_owns_television', qgr.response, NULL)) AS 'Q9',
GROUP_CONCAT(if(q.nickname = 'ppi_pakistan_2009_owns_trasportation', qgr.response, NULL)) AS 'Q10'
FROM question_group_response qgr, question_group_instance qgi, question_group qg, sections_questions sq, questions q, event_sources es
WHERE qgr.question_group_instance_id = qgi.id and qgr.sections_questions_id = sq.id and sq.question_id = q.question_id and qgi.question_group_id = qg.id and qg.title="PPI Pakistan 2009" and qgi.event_source_id = es.id
GROUP BY question_group_instance_id) as answers