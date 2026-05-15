<!-- #include file ="..\crmwizard.js" -->

<%

CurrentUser=CRM.GetContextInfo("selecteduser", "User_UserId");

var sURL=new String( Request.ServerVariables("URL")() + "?" + Request.QueryString );

List=CRM.GetBlock("AssignmentUserGrid");
List.prevURL=sURL;

container = CRM.GetBlock('container');
container.AddBlock(List);

container.DisplayButton(Button_Default) = false;

// new button
if( false )
{
  container.WorkflowTable = 'Assignment';
  container.ShowNewWorkflowButtons = true;
}
else {
  // remove this code to remove the standard new button
  NewButton = CRM.GetBlock("content");
  NewButton.contents = CRM.Button("New", "new.gif", CRM.URL("Assignment/AssignmentNew.asp")+"&E=Assignment", 'Assignment', 'insert');
  NewButton.NewLine = false;
  container.AddBlock( NewButton );
}


if( CurrentUser != null && CurrentUser != '' )
{
  CRM.AddContent(container.Execute("assi_UserId="+CurrentUser));
}
else
{
  CRM.AddContent(container.Execute("assi_UserId IS NULL"));
}

Response.Write(CRM.GetPage('User'));

%>






