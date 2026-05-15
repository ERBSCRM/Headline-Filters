<!-- #include file ="..\crmwizard.js" -->

<%

if( CRM.Mode != Save ){
  F=Request.QueryString("F");
  if( F == "AssignmentNew.asp" ) CRM.Mode=Edit;
}

Container=CRM.GetBlock("container");
Entry=CRM.GetBlock("AssignmentNewEntry");
Entry.Title="Assignment";
Container.AddBlock(Entry);
Container.DisplayButton(1)=false;

var Id = new String(Request.Querystring("assi_AssignmentID"));

if (Id.toString() == 'undefined') {
  Id = new String(Request.Querystring("Key58"));
  if (Id.toString() == 'undefined') {
    Id = new String(Request.Querystring("Key0"));
  }
}

var UseId = 0;

if (Id.indexOf(',') > 0) {
   var Idarr = Id.split(",");
   UseId = Idarr[0];
}
else if (Id != '') 
  UseId = Id;


if (UseId != 0) {

   var Idarr = Id.split(",");

   CRM.SetContext("Assignment", UseId);

   record = CRM.FindRecord("Assignment", "assi_AssignmentID="+UseId);

   //if were deleting
   if( Request.Querystring("em") == 3 )
   {
     record.DeleteRecord = true;
     record.SaveChanges();

     // need to redirect back to the place where we got to the summary from
     // -- but we cant refresh the top frame easily so just go back to find
     // -- every time
     PrevCustomURL = new String(Request.QueryString("F"));
     URLarr=PrevCustomURL.split(",");
     if(URLarr[0].toUpperCase() != "AssignmentNew.asp")
       Response.Redirect(CRM.URL("Assignment/AssignmentFind.asp?J=Assignment/AssignmentFind.asp&E=Assignment"));
     else
       Response.Redirect(CRM.URL("AssignmentNew.asp?J=AssignmentNew.asp&E=Assignment"));
   }
   else
   {
     if( false )
     {   
       Container.ShowWorkflowButtons = true;
       Container.WorkflowTable = "Assignment";
     }

     if(CRM.Mode == Edit)
     {
       Container.DisplayButton(Button_Continue) = true;
       Container.AddButton(CRM.Button("Delete", "delete.gif", "javascript:x=location.href;i=x.search('&em=');if (i >= 0) {   x=x.substr(0,i)+x.substr(i+2+3,x.length);}x=x+'&'+'em'+'='+'3';location.href=x", "Assignment", "DELETE"));
       Container.AddButton(CRM.Button("Save", "save.gif", "javascript:x=location.href;if (x.charAt(x.length-1)!='&')if (x.indexOf('?')>=0) x+='&'; else x+='?';x+='assi_AssignmentID="+UseId+"';document.EntryForm.action=x;document.EntryForm.submit();", "Assignment", "EDIT"));
     }
     else
     {
       Container.DisplayButton(Button_Continue) = true;
       Container.AddButton(CRM.Button("Change","edit.gif","javascript:x=location.href;if (x.charAt(x.length-1)!='&')if (x.indexOf('?')>=0) x+='&'; else x+='?';x+='assi_AssignmentID="+UseId+"&History=T';document.EntryForm.action=x;document.EntryForm.submit();", "Assignment", "EDIT"));
     }
	 
	 recObj = CRM.FindRecord("Custom_Tables","Bord_Name='"+Entry.Title+"'");
	 if ((true) && (recObj('Bord_HasCommunication') != undefined)) {
		recObjOAuth = CRM.FindRecord("UserSettings","USet_Key = 'EMC_AuthAccessToken' and USet_UserId='"+CRM.GetContextInfo('User', 'User_UserId')+"'");
		if ((true) && (recObjOAuth.RecordCount > 0)) {
		  Container.AddButton(CRM.Button("ImportEmails", "", CRM.URL(1362) + "&ImportMode=0&EntName=" + Entry.Title));
		}
	 }

     CRM.AddContent(Container.Execute(record));
  }
  CRM.SetContext("Assignment", UseId);
  CRM.GetCustomEntityTopFrame("Assignment");
  Response.Write(CRM.GetPage());
}

%>







