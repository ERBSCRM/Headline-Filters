USE [CRM]
GO
/****** Object:  Trigger [dbo].[OpportunityForecastUpdate]    Script Date: 15/05/2026 11:05:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[OpportunityForecastUpdate]
ON [dbo].[Opportunity]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF @@NESTLEVEL > 1 RETURN;

    ;WITH AffectedOpportunities AS (
        SELECT DISTINCT i.Oppo_OpportunityId
        FROM inserted i
        WHERE i.Oppo_OpportunityId IS NOT NULL
    ),
    ForecastTotals AS (
        SELECT
            AO.Oppo_OpportunityId,
            ForecastTotal = ISNULL(SUM(ISNULL(QI.quit_quotedpricetotal, 0)), 0)
        FROM AffectedOpportunities AO
        LEFT JOIN Quotes Q
            ON Q.Quot_OpportunityId = AO.Oppo_OpportunityId
           AND Q.quot_rollup = 'Y'
           AND Q.quot_deleted IS NULL
        LEFT JOIN QuoteItems QI
            ON QI.QuIt_orderquoteid = Q.Quot_OrderQuoteID
           AND QI.quit_c_addtoforecast= 'Y'
           AND QI.quit_deleted IS NULL
        GROUP BY AO.Oppo_OpportunityId
    )
    UPDATE O
    SET
        O.Oppo_Forecast = FT.ForecastTotal,
        O.Oppo_Forecast_CID = 3
    FROM Opportunity O
    JOIN ForecastTotals FT
        ON FT.Oppo_OpportunityId = O.Oppo_OpportunityId;
 ----------------------------------------------------------------------
    -- Forecast is based on quote items marked includeforecast = 'Y'
    -- and quotes with rollup = 'Y'
    ----------------------------------------------------------------------
    DECLARE @QuoteForcastTotal NUMERIC(13,2)
	DECLARE @opportunityId INT
    SET @QuoteForcastTotal = 0

    SELECT @QuoteForcastTotal = ISNULL(SUM(ISNULL(quit_quotedpricetotal, 0)), 0)
    FROM Opportunity
    INNER JOIN Quotes     ON Quot_opportunityid  = Oppo_OpportunityId
    INNER JOIN QuoteItems ON QuIt_orderquoteid   = Quot_OrderQuoteID
    WHERE Quot_opportunityid    = @opportunityId
      AND quot_rollup           = 'Y'
      AND quit_c_addtoforecast = 'Y'
      AND Quotes.quot_deleted    IS NULL
      AND QuoteItems.quit_deleted IS NULL

    UPDATE Opportunity
    SET Oppo_Forecast     = @QuoteForcastTotal,
        Oppo_Forecast_CID =3
    WHERE Oppo_OpportunityId = @opportunityId;

	Update Opportunity 
	 SET
        Oppo_Closed =
            CASE
                WHEN Oppo_Closed IS NULL AND Oppo_Opened IS NOT NULL
                THEN DATEADD(MONTH, 3, Oppo_Opened)
                ELSE Oppo_Closed
            END
END
