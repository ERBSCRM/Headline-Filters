<!-- #include file ="..\crmwizard.js" -->

<%

CRM.SetContext("Find");

if (CRM.Mode<Edit) CRM.Mode=Edit;

var sURL=new String( Request.ServerVariables("URL")() + "?" + Request.QueryString );

searchEntry=CRM.GetBlock("AssignmentSearchBox");
searchEntry.Title=CRM.GetTrans("Tabnames","Search");
searchEntry.ShowSavedSearch=true;
searchEntry.UseKeyWordSearch=true;

searchList=CRM.GetBlock("AssignmentGrid");
searchContainer=CRM.GetBlock("container");

searchContainer.ButtonTitle="Search";
searchContainer.ButtonImage="Search.gif";

searchContainer.AddBlock(searchEntry);
if( CRM.Mode != 6)
  searchContainer.AddBlock(searchList);

searchContainer.AddButton(CRM.Button("Clear", "clear.gif", "javascript:document.EntryForm.em.value='6';document.EntryForm.submit();"));


if( CRM.Mode == 2) {
  if(false){
	searchContainer.AddButton(CRM.Button("MergeToPDF", "MailMergePDF.gif", "javascript:document.EntryForm.TargetAction.value = 'NewPDFDocument'; document.EntryForm.submit();")); 
    if (CRM.SystemOption("AllowMailMergeToWord")=="Y" && CRM.GetContextInfo("selecteduser", "user_MailMergeToWord")=="Y"){
      searchContainer.AddButton(CRM.Button("MergeToWord", "MailMergeDOC.gif", "javascript:document.EntryForm.TargetAction.value = 'NewWordDocument'; document.EntryForm.submit();"));
    }  
  }  
//if(false){
//searchContainer.AddButton(CRM.Button("NewTask", "newtask.gif", //"javascript:document.EntryForm.TargetAction.value = 'NewCommunication'; document.EntryForm.submit
//();"));
//}
//if(false){
//searchContainer.AddButton(CRM.Button("Export", "list.gif", //"javascript:document.EntryForm.TargetAction.value = 'ExportToFile'; document.EntryForm.submit();"));
//} 
}

searchList.prevURL=sURL;
CRM.AddContent(searchContainer.Execute(searchEntry));

Response.Write(CRM.GetPage());

%>





