select answers.survey_id, 0 as points_version, date(str_to_date(answers.date_survey_taken, '%d/%m/%Y')) as date_survey_taken, answers.entity_id, answers.entity_type_id,

(
case
when answers.Q1='Four or more' then 0
when answers.Q1='Three' then 5
when answers.Q1='Two' then 9
when answers.Q1='One' then 16
when answers.Q1='None' then 24
end +
case
when answers.Q2='None, pre-school, or kindergarten' then 0
when answers.Q2='Grade school (incomplete)' then 5
when answers.Q2='Grade school (complete)' then 7
when answers.Q2='High school (incomplete)' then 9
when answers.Q2='High school (complete), non-university superior (incomplete) or no female head' then 10
when answers.Q2='Non-university superior (complete) or higher' then 16
end +
case
when answers.Q3='Earth, wood planks, other, or no residence' then 0
when answers.Q3='Cement' then 2
when answers.Q3='Parquet, polished wood, linoleum, vinyl, tile, or similar' then 15
end +
case
when answers.Q4='Adobe, mud, or matting' then 0
when answers.Q4='Wattle and daub, wood, matting, brick or cement blocks, stone blocks with lime or cement, other, or no residence' then 2
end +
case
when answers.Q5='One' then 0
when answers.Q5='Two' then 1
when answers.Q5='Three, four, or five' then 5
when answers.Q5='Six or more' then 10
end +
case
when answers.Q6='Other' then 0
when answers.Q6='Firewood, charcoal, or kerosene' then 5
when answers.Q6='Gas (LPG or natural)' then 9
when answers.Q6='Electricity or does not cook' then 16
end +
case
when answers.Q7='No' then 0
when answers.Q7='Yes' then 5
end +
case
when answers.Q8='None' then 0
when answers.Q8='One' then 3
when answers.Q8='Two or more' then 7
end +
case
when answers.Q9='No' then 0
when answers.Q9='Yes' then 3
end +
case
when answers.Q10='No' then 0
when answers.Q10='Yes' then 2
end
) 
as ppi_score
from
(SELECT
qg.id as survey_id,
GROUP_CONCAT(if(q.nickname = 'ppi_peru_2009_survey_date', qgr.response, NULL)) AS 'date_survey_taken',
qgi.entity_id as entity_id,
es.entity_type_id as entity_type_id,
GROUP_CONCAT(if(q.nickname = 'ppi_peru_2009_family_members_0_to_17', qgr.response, NULL)) AS 'Q1',
GROUP_CONCAT(if(q.nickname = 'ppi_peru_2009_female_head_education_level', qgr.response, NULL)) AS 'Q2',
GROUP_CONCAT(if(q.nickname = 'ppi_peru_2009_house_floors', qgr.response, NULL)) AS 'Q3',
GROUP_CONCAT(if(q.nickname = 'ppi_peru_2009_house_walls', qgr.response, NULL)) AS 'Q4',
GROUP_CONCAT(if(q.nickname = 'ppi_peru_2009_house_rooms', qgr.response, NULL)) AS 'Q5',
GROUP_CONCAT(if(q.nickname = 'ppi_peru_2009_cooking_fuel', qgr.response, NULL)) AS 'Q6',
GROUP_CONCAT(if(q.nickname = 'ppi_peru_2009_has_refrigerator', qgr.response, NULL)) AS 'Q7',
GROUP_CONCAT(if(q.nickname = 'ppi_peru_2009_color_televisions', qgr.response, NULL)) AS 'Q8',
GROUP_CONCAT(if(q.nickname = 'ppi_peru_2009_has_blender', qgr.response, NULL)) AS 'Q9',
GROUP_CONCAT(if(q.nickname = 'ppi_peru_2009_has_iron', qgr.response, NULL)) AS 'Q10'
FROM question_group_response qgr, question_group_instance qgi, question_group qg, sections_questions sq, questions q, event_sources es
WHERE qgr.question_group_instance_id = qgi.id and qgr.sections_questions_id = sq.id and sq.question_id = q.question_id and qgi.question_group_id = qg.id and qg.title="PPI Peru 2009" and qgi.event_source_id = es.id
GROUP BY question_group_instance_id) as answers