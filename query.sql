WITH RECURSIVE
eligible_campaigns AS (
  SELECT id
  FROM campaign
  WHERE creation_status IN ('approved', 'aborted', 'resumed', 'stopped')
    AND processing_status = 'processed'
),
chain_root(id, root_id) AS (
  SELECT id, id AS root_id
  FROM campaign
  WHERE parent_id IS NULL
  UNION ALL
  SELECT c.id, cr.root_id
  FROM campaign c
  JOIN chain_root cr ON c.parent_id = cr.id
),
chain_size AS (
  SELECT root_id, COUNT(*) AS members
  FROM chain_root
  GROUP BY root_id
),
logs AS (
  SELECT l.customer_id, cr.root_id
  FROM communication_log l
  JOIN eligible_campaigns e ON l.communication_id = e.id
  JOIN chain_root cr ON cr.id = e.id
  WHERE l.merchant_id = 501
    AND l.communication_type = '2'
    AND l.sent_time >= '2026-10-01' AND l.sent_time < '2026-11-01'
),
per_root AS (
  SELECT
    root_id,
    COUNT(*) AS row_count,
    COUNT(DISTINCT customer_id) AS distinct_customers
  FROM logs
  GROUP BY root_id
)
SELECT
  SUM(
    CASE WHEN cs.members = 1
         THEN row_count
         ELSE distinct_customers
    END
  ) AS target_base
FROM per_root
JOIN chain_size cs USING (root_id);
