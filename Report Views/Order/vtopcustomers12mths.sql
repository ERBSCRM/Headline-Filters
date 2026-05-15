/* This view is used for YTD/ CYTD reporting for top customers. It calculates the total order gross amount for the current 
fiscal year to date (CYTD) and the previous fiscal year to date (PYTD) - The fiscal year starts July 1st and ends June 30th. 
The view also calculates the difference in amount and percentage between CYTD and PYTD for each customer. 
*/
WITH FiscalDates AS (
    SELECT
        CASE
            WHEN MONTH(GETDATE()) >= 7
            THEN DATEFROMPARTS(YEAR(GETDATE()), 7, 1)
            ELSE DATEFROMPARTS(YEAR(GETDATE()) - 1, 7, 1)
        END AS CurrentFiscalYearStart
),
Last12Months_Comparison AS (
    SELECT
        c.Comp_CompanyId,
        c.comp_name,

        SUM(CASE
            WHEN o.Orde_opened >= fd.CurrentFiscalYearStart
             AND o.Orde_opened < DATEADD(YEAR, 1, fd.CurrentFiscalYearStart)
            THEN o.Orde_grossamt
            ELSE 0
        END) AS orde_cytd_amount,

        SUM(CASE
            WHEN o.Orde_opened >= DATEADD(YEAR, -1, fd.CurrentFiscalYearStart)
             AND o.Orde_opened < fd.CurrentFiscalYearStart
            THEN o.Orde_grossamt
            ELSE 0
        END) AS orde_pytd_amount,

        MAX(o.Orde_grossamt_cid) AS orde_cytd_amount_CID,
        MAX(o.Orde_grossamt_cid) AS orde_pytd_amount_CID,
        MAX(o.Orde_grossamt_cid) AS orde_ytd_difference_CID

    FROM Orders o
    INNER JOIN Opportunity opp
        ON o.Orde_opportunityid = opp.Oppo_OpportunityId
    INNER JOIN Company c
        ON c.Comp_CompanyId = opp.Oppo_PrimaryCompanyId
    CROSS JOIN FiscalDates fd
    WHERE o.Orde_opened >= DATEADD(YEAR, -1, fd.CurrentFiscalYearStart)
      AND o.Orde_opened < DATEADD(YEAR, 1, fd.CurrentFiscalYearStart)
      AND o.Orde_Deleted IS NULL
    GROUP BY
        c.Comp_CompanyId,
        c.comp_name
)
SELECT
    lc.Comp_CompanyId,
    lc.comp_name,
    lc.orde_cytd_amount_CID,
    lc.orde_pytd_amount_CID,
    lc.orde_ytd_difference_CID,
    lc.orde_cytd_amount,
    lc.orde_pytd_amount,
    lc.orde_cytd_amount - lc.orde_pytd_amount AS orde_ytd_difference,
    CASE
        WHEN lc.orde_pytd_amount = 0 THEN NULL
        ELSE ((lc.orde_cytd_amount - lc.orde_pytd_amount) / lc.orde_pytd_amount) * 100
    END AS percent_difference
FROM Last12Months_Comparison lc