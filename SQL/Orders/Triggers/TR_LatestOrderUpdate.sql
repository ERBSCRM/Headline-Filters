USE [CRM]
GO
/****** Object:  Trigger [dbo].[TR_LatestOrderUpdate]    Script Date: 15/05/2026 11:22:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- Author:          Mohammed copied to Headline from Taj


-- =============================================

ALTER TRIGGER [dbo].[TR_LatestOrderUpdate]

   ON  [dbo].[Orders]

 AFTER INSERT,Update

AS

BEGIN

      Declare @Order_OrderId int,@Oppo_primarycompanyid int
      Declare @Order_opportunityid int
      Declare @Order_Date datetime
      

      

      Select @Order_OrderId=Orde_OrderQuoteID,@Order_Date=Orde_opened,@Order_opportunityid=Orde_opportunityid from inserted
      where orde_q_type = 'INV:1'

      Select @Oppo_primarycompanyid=Oppo_primarycompanyid   from opportunity where Oppo_OpportunityId=@Order_opportunityid



       if @Oppo_primarycompanyid is not null

        update company set comp_c_lastordereddate = @Order_Date where Comp_CompanyId=@Oppo_primarycompanyid

     
End