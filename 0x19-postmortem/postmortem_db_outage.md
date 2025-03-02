# Postmortem: Database Connection Failure Outage
<img src="./db_outage.gif"/>
Database outages be like this for real lol

## Issue Summary


**Duration:** March 2, 2025, 12:00 CAT — March 2, 2025, 14:15 CAT (2 hours 15 minutes)

**Impact:** The primary database connection pool was exhausted, leading to service downtime for approximately 60% of active users. Users experienced slow load times, failed API requests, and in some cases, complete inaccessibility to core services. The outage impacted both web and mobile applications, causing significant disruptions in user experience.

**Root Cause:** A recent deployment introduced an inefficient database query that caused a surge in active connections, eventually exceeding the database’s maximum connection limit. The lack of proper indexing in the new query led to a full-table scan on a high-traffic endpoint, further exacerbating the issue by overloading the database server.

## Timeline
12:00 CAT — *Issue detected via high database latency alerts from the monitoring system.*  
12:05 CAT — *Engineers noticed increased API failures and began investigating.*  
12:15 CAT — *Customer support reported complaints about service unavailability.*  
12:30 CAT — *Initial suspicion pointed to a network issue, leading to a diversion in debugging efforts.*  
13:00 CAT — *Deeper analysis of logs revealed excessive database connections from a recently deployed service.*  
13:15 CAT — *Engineers identified the inefficient query and attempted to revert the deployment.*  
13:30 CAT — *Additional logging was enabled to monitor connection usage in real-time.*  
13:45 CAT — *Reverting the update reduced the connection load, and services began recovering.*  
14:15 CAT — Full resolution confirmed. Database performance returned to normal.
## Root Cause and Resolution
The issue stemmed from a new feature deployment that introduced a query performing a full-table scan on a frequently accessed database table. The query lacked proper indexing and was executed on every request, leading to a massive increase in database connections. Once the maximum connection pool limit was reached, subsequent queries were queued or dropped, effectively bringing down affected services.

To resolve the issue, the team:
* Rolled back the faulty deployment to restore previous functionality.
* Optimized the inefficient query by introducing indexing and pagination to reduce load.
* Increased connection pool monitoring thresholds to trigger earlier alerts.
* Conducted a database performance review to identify similar high-risk queries.
## Corrective and Preventative Measures
### Improvements:
* Improve database query review process before deployments to detect inefficiencies.
* Enhance alerting for abnormal connection pool exhaustion to prevent future outages.
* Introduce load testing for high-traffic endpoints before rolling out changes.
* Ensure rollback strategies are well-documented and can be executed quickly.
### Action Items:
This postmortem underscores the need for careful database query optimization, proactive monitoring, and improved deployment processes to prevent similar outages in the future. By implementing the outlined corrective measures, we aim to enhance system reliability and ensure better service availability for users.
