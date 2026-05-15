<!-- #include file ="../accpaccrm.js" -->

<%

            CID=CRM.GetContextInfo("Company", "Comp_Companyid");



            RecComp=CRM.FindRecord("Company","Comp_companyid="+CID)

    var CName=RecComp("Comp_name").substring(0, 1);



 // RecLib=CRM.FindRecord("Library","Libr_type='PriceList' and Libr_companyid="+CID)
 sql2="Select  Top 1 *  from Library where Libr_type='PriceList' and Libr_companyid="+CID+" and libr_deleted is null order by libr_createddate desc";
 RecLib=eWare.CreateQueryObj(sql2);
 RecLib.SelectSql();
 
 



newURL="&"+RecLib("libr_filepath")+RecLib("libr_filename")+"&Mode=0&FileName="+RecLib("libr_filepath")+RecLib("libr_filename")



            var x=CRM.URL(Act=520)   //CL UPDATE
            var x2=x.split("&Mode=")
            newURL=x2[0]+newURL



if (RecLib.RecordCount >0)
{
Response.Redirect(newURL)
}
else
{
 Response.write("Price list not exist for this company")
}




%>

