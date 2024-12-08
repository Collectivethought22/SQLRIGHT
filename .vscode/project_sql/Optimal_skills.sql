WITH skills_demand AS (  
SELECT skills, skills_dim.skill_id,
COUNT(skills_job_dim.job_id) AS demand_count
FROM JOB_POSTINGS_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id 
WHERE job_title_short = 'Data Analyst' AND job_location = 'Anywhere' AND job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id, skills_dim.skills
),
top_paying_skills AS (
    SELECT skills, skills_job_dim.skill_id,
ROUND(AVG (job_postings_fact.salary_year_avg), 0) AS salary_average
FROM JOB_POSTINGS_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id 
WHERE job_title_short = 'Data Analyst' AND job_postings_fact.salary_year_avg IS NOT NULL AND job_location = 'Anywhere'
GROUP BY skills_job_dim.skill_id, skills_dim.skills
)

SELECT skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    salary_average
FROM skills_demand
INNER JOIN top_paying_skills ON skills_demand.skill_id = top_paying_skills.skill_id
WHERE demand_count > 10
ORDER BY
    salary_average DESC,
    demand_count DESC
    LIMIT 25