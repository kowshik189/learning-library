<%@page import="java.io.InputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page contentType="text/html"%>
<%@page import ="java.sql.*"%>
<%@page import ="java.util.*"%>
<%@page import ="oracle.jdbc.*"%>
<%
ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
InputStream propertiesFile = classLoader.getResourceAsStream("hr.properties");

if (propertiesFile == null) {
    throw new NullPointerException("Properties file 'hr.properties' is missing in classpath.");
}

Properties properties = new Properties();
properties.load(propertiesFile); // Handle IOException.

String oJDBCDriver = properties.getProperty("oJDBCDriver");
String oJDBCURL = properties.getProperty("oJDBCURL");
String oJDBCUser = properties.getProperty("oJDBCUser");
String oJDBCPassword = properties.getProperty("oJDBCPassword");

// Privileges
ArrayList oRoles = (ArrayList) session.getAttribute( "logged-user-privileges" );


// Get action from request
String oAction = request.getParameter( "action" ) != null ? (String) request.getParameter( "action" ) : "";

// Login
if ( oAction.equals( "login" ) )
{
 String oUsername = (String) request.getParameter( "username" );
 String oPassword = (String) request.getParameter( "password" );
 if ( !oUsername.equals( "" ) && !oPassword.equals( "" ) )
 {
 
  try
  {
//String oJDBCDriver   = application.getInitParameter( "jdbc.driver" )   != null ? application.getInitParameter( "jdbc.driver" )   : "oracle.jdbc.driver.OracleDriver";
//String oJDBCURL      = application.getInitParameter( "jdbc.url" )      != null ? application.getInitParameter( "jdbc.url" )      : "jdbc:oracle:thin:@localhost:1521:orcl";
//String oJDBCUser     = application.getInitParameter( "jdbc.user" )     != null ? application.getInitParameter( "jdbc.user" )     : "demoapps";
//String oJDBCPassword = application.getInitParameter( "jdbc.password" ) != null ? application.getInitParameter( "jdbc.password" ) : "abcd1234";

   Class.forName( oJDBCDriver );
   Connection conn = DriverManager.getConnection( oJDBCURL, oJDBCUser, oJDBCPassword );
  
   Statement stmt = conn.createStatement();
   ResultSet rs = stmt.executeQuery( 
      "select USERID,FIRSTNAME,LASTNAME from DEMO_HR_USERS " 
    + "where ( USERSTATUS is NULL or upper( USERSTATUS ) = 'ENABLE' ) and upper(USERID) = '" + oUsername.toUpperCase() + "' and password = '" + oPassword + "'" );
   if (rs.next())
   {
    session.setAttribute( "logged-user", rs.getString("USERID") );
    session.setAttribute( "logged-user-firstname", rs.getString("FIRSTNAME") );
    session.setAttribute( "logged-user-lastname", rs.getString("LASTNAME") );
    
    // Load privileges
    oRoles = new ArrayList();
    stmt = conn.createStatement();
    rs = stmt.executeQuery( "select ROLEID from DEMO_HR_ROLES where upper(USERID) = '" + oUsername.toUpperCase() + "'" );
    while ( rs.next() )
    {
     String oRole = rs.getString("ROLEID");
     oRoles.add( oRole );
    }
    session.setAttribute( "logged-user-privileges", oRoles );
    
    response.sendRedirect( "index.jsp" );
   }
   else
   {
    response.sendRedirect( "login.jsp?err=no_login" );
   }
  }
  catch( Exception e)
  {
   e.printStackTrace();
   response.sendRedirect( "login.jsp?err=server_error" );
  }
 }
 else
 {
  response.sendRedirect( "login.jsp?err=no_login" );
 }
}

// Logout
else if ( oAction.equals( "logout" ) )
{
 session.invalidate();
 response.sendRedirect( "index.jsp" );
}

// Modify Employee
else if ( oAction.equals( "employee_modify" ) && oRoles != null && oRoles.contains("UPDATE") )
{
 String oUserID = request.getParameter( "userid" ) != null ? (String) request.getParameter( "userid" ) : "";
 if ( !oUserID.equals( "" ) )
 {
 // Retrieve informations
 String oFirstName = request.getParameter( "firstname" ) != null ? (String) request.getParameter( "firstname" ) : "";
 String oLastName = request.getParameter( "lastname" ) != null ? (String) request.getParameter( "lastname" ) : "";
 String oDOB = request.getParameter( "dob" ) != null ? (String) request.getParameter( "dob" ) : "";
 String oEmail = request.getParameter( "email" ) != null ? (String) request.getParameter( "email" ) : "";
 String oSSN = request.getParameter( "ssn" ) != null ? (String) request.getParameter( "ssn" ) : "";
 String oSIN = request.getParameter( "sin" ) != null ? (String) request.getParameter( "sin" ) : "";
 String oNINO = request.getParameter( "nino" ) != null ? (String) request.getParameter( "nino" ) : "";
 String oAddress_1 = request.getParameter( "address_1" ) != null ? (String) request.getParameter( "address_1" ) : "";
 String oAddress_2 = request.getParameter( "address_2" ) != null ? (String) request.getParameter( "address_2" ) : "";
 String oCountry = request.getParameter( "country" ) != null ? (String) request.getParameter( "country" ) : "";
 String oPostalCode = request.getParameter( "postal_code" ) != null ? (String) request.getParameter( "postal_code" ) : "";
 String oMemberID = request.getParameter( "member_id" ) != null ? (String) request.getParameter( "member_id" ) : "";
 String oLast_Ins_Claim = request.getParameter( "last_ins_claim" ) != null ? (String) request.getParameter( "last_ins_claim" ) : "";
 String oBonus_Amount = request.getParameter( "bonus_amount" ) != null ? (String) request.getParameter( "bonus_amount" ) : "";
 String oPayment_Acct_No = request.getParameter( "payment_acct_no" ) != null ? (String) request.getParameter( "payment_acct_no" ) : "";
 String oRouting_Number = request.getParameter( "routing_number" ) != null ? (String) request.getParameter( "routing_number" ) : "";

 String oPhoneMobile = request.getParameter( "phonemobile" ) != null ? (String) request.getParameter( "phonemobile" ) : "";
 String oPhoneFix = request.getParameter( "phonefix" ) != null ? (String) request.getParameter( "phonefix" ) : "";
 String oPhoneFax = request.getParameter( "phonefax" ) != null ? (String) request.getParameter( "phonefax" ) : "";
 String oEmpType = request.getParameter( "emptype" ) != null ? (String) request.getParameter( "emptype" ) : "";
 String oPosition = request.getParameter( "position" ) != null ? (String) request.getParameter( "position" ) : "";
 String oLocation = request.getParameter( "location" ) != null ? (String) request.getParameter( "location" ) : "";
 String oIsManager = request.getParameter( "ismanager" ) != null ? (String) request.getParameter( "ismanager" ) : "";
 String oManagerID = request.getParameter( "managerid" ) != null ? (String) request.getParameter( "managerid" ) : "";
 String oCostCenter = request.getParameter( "costcenter" ) != null ? (String) request.getParameter( "costcenter" ) : "";
 String oDepartment = request.getParameter( "department" ) != null ? (String) request.getParameter( "department" ) : "";
 String oIsHeadOfDepartment = request.getParameter( "isheadofdepartment" ) != null ? (String) request.getParameter( "isheadofdepartment" ) : "";
 String oOrganization = request.getParameter( "organization" ) != null ? (String) request.getParameter( "organization" ) : "";
 String oStartDate = request.getParameter( "startdate" ) != null ? (String) request.getParameter( "startdate" ) : "";
 String oEndDate = request.getParameter( "enddate" ) != null ? (String) request.getParameter( "enddate" ) : "";
 String oActive = request.getParameter( "active" ) != null ? (String) request.getParameter( "active" ) : "";
  
  // out.println( oUserID + ":" + oFirstName + ":" + oLastName + ":" + oPhoneMobile + ":" + oPhoneFix + ":" + oPhoneFax + ":"
  // + oEmpType + ":" + oPosition + ":" + oLocation + ":" + oIsManager + ":" + oManagerID + ":"
  // + oDepartment + ":" + oOrganization + ":" + oStartDate + ":" + oEndDate + ":" + oActive );
  
  try
  {
//   String oJDBCDriver   = application.getInitParameter( "jdbc.driver" )   != null ? application.getInitParameter( "jdbc.driver" )   : "oracle.jdbc.OracleDriver";
//   String oJDBCURL      = application.getInitParameter( "jdbc.url" )      != null ? application.getInitParameter( "jdbc.url" )      : "jdbc:oracle:thin:@//dbserver.oracle.vm:1521/demo.oracle.vm";
//   String oJDBCUser     = application.getInitParameter( "jdbc.user" )     != null ? application.getInitParameter( "jdbc.user" )     : "demoapps";
//   String oJDBCPassword = application.getInitParameter( "jdbc.password" ) != null ? application.getInitParameter( "jdbc.password" ) : "Oracle_123";

   Class.forName( oJDBCDriver );
   Connection conn = DriverManager.getConnection( oJDBCURL, oJDBCUser, oJDBCPassword );

 System.out.println ("**** UPDATE DEMO_HR_EMPLOYEES ****");
 String oLoggedUser = (String) request.getParameter( "logged-user" );

 CallableStatement stmt2 = null;
 String sql = "{call employeesearch_prod.set_app_user_label ( ? )}";
 stmt2 = conn.prepareCall(sql);
 stmt2.setString (1, oLoggedUser);
 stmt2.executeQuery();

 System.out.println ("**** PRINT VARIABLES FOR UPDATE ****");
 System.out.println (oLoggedUser);
 System.out.println( sql );

   Statement stmt = conn.createStatement();

   String oQuery = "update DEMO_HR_EMPLOYEES set FIRSTNAME = '" + oFirstName + "', "
    + "LASTNAME = '" + oLastName + "', "
    + "PHONEMOBILE = '" + oPhoneMobile + "', "
    + "PHONEFIX = '" + oPhoneFix + "', "
    + "PHONEFAX = '" + oPhoneFax + "', "
    + "EMPTYPE = '" + oEmpType + "', "
    + "POSITION = '" + oPosition + "', "
    + "STARTDATE = To_date('" + oStartDate + "','YYYY-MM-dd'), "
    + "ENDDATE = To_date('" + oEndDate + "','YYYY-MM-dd'), "
    + "LOCATION = '" + oLocation + "', "
    + "ISMANAGER = " + oIsManager + ", "
    + "ISHEADOFDEPARTMENT = " + oIsHeadOfDepartment + ", "
    + "MANAGERID = " + oManagerID + ", "
    + "COSTCENTER = '" + oCostCenter + "', "
    + "DEPARTMENT = '" + oDepartment + "', "
    + "ORGANIZATION = '" + oOrganization + "', "
    + "ACTIVE = " + oActive + " where USERID = " + oUserID;
   
   // out.println( oQuery );

   ResultSet rs = stmt.executeQuery( oQuery );
   response.sendRedirect( "employee_view.jsp?userid=" + oUserID );
  }
  catch( Exception e )
  {
   e.printStackTrace();
   response.sendRedirect( "employee_view.jsp?err=error_while_updating&userid=" + oUserID );
  }
 }
 else
 {
  response.sendRedirect( "search.jsp?err=invalid_userid" );
 }
}

// Create Employee
else if ( oAction.equals( "employee_create" ) && oRoles != null && oRoles.contains("INSERT") )
{



 // Retrieve informations
 String oFirstName = request.getParameter( "firstname" ) != null ? (String) request.getParameter( "firstname" ) : "";
 String oLastName = request.getParameter( "lastname" ) != null ? (String) request.getParameter( "lastname" ) : "";
 String oDOB = request.getParameter( "dob" ) != null ? (String) request.getParameter( "dob" ) : "";
 String oEmail = request.getParameter( "email" ) != null ? (String) request.getParameter( "email" ) : "";
 String oSSN = request.getParameter( "ssn" ) != null ? (String) request.getParameter( "ssn" ) : "";
 String oSIN = request.getParameter( "sin" ) != null ? (String) request.getParameter( "sin" ) : "";
 String oNINO = request.getParameter( "nino" ) != null ? (String) request.getParameter( "nino" ) : "";
 String oAddress_1 = request.getParameter( "address_1" ) != null ? (String) request.getParameter( "address_1" ) : "";
 String oAddress_2 = request.getParameter( "address_2" ) != null ? (String) request.getParameter( "address_2" ) : "";
 String oCountry = request.getParameter( "country" ) != null ? (String) request.getParameter( "country" ) : "";
 String oPostalCode = request.getParameter( "postal_code" ) != null ? (String) request.getParameter( "postal_code" ) : "";
 String oMemberID = request.getParameter( "member_id" ) != null ? (String) request.getParameter( "member_id" ) : "";
 String oLast_Ins_Claim = request.getParameter( "last_ins_claim" ) != null ? (String) request.getParameter( "last_ins_claim" ) : "";
 String oBonus_Amount = request.getParameter( "bonus_amount" ) != null ? (String) request.getParameter( "bonus_amount" ) : "";
 String oPayment_Acct_No = request.getParameter( "payment_acct_no" ) != null ? (String) request.getParameter( "payment_acct_no" ) : "";
 String oRouting_Number = request.getParameter( "routing_number" ) != null ? (String) request.getParameter( "routing_number" ) : "";

 String oPhoneMobile = request.getParameter( "phonemobile" ) != null ? (String) request.getParameter( "phonemobile" ) : "";
 String oPhoneFix = request.getParameter( "phonefix" ) != null ? (String) request.getParameter( "phonefix" ) : "";
 String oPhoneFax = request.getParameter( "phonefax" ) != null ? (String) request.getParameter( "phonefax" ) : "";
 String oEmpType = request.getParameter( "emptype" ) != null ? (String) request.getParameter( "emptype" ) : "";
 String oPosition = request.getParameter( "position" ) != null ? (String) request.getParameter( "position" ) : "";
 String oLocation = request.getParameter( "location" ) != null ? (String) request.getParameter( "location" ) : "";
 String oIsManager = request.getParameter( "ismanager" ) != null ? (String) request.getParameter( "ismanager" ) : "";
 String oManagerID = request.getParameter( "managerid" ) != null ? (String) request.getParameter( "managerid" ) : "";
 String oCostCenter = request.getParameter( "costcenter" ) != null ? (String) request.getParameter( "costcenter" ) : "";
 String oDepartment = request.getParameter( "department" ) != null ? (String) request.getParameter( "department" ) : "";
 String oIsHeadOfDepartment = request.getParameter( "isheadofdepartment" ) != null ? (String) request.getParameter( "isheadofdepartment" ) : "";
 String oOrganization = request.getParameter( "organization" ) != null ? (String) request.getParameter( "organization" ) : "";
 String oStartDate = request.getParameter( "startdate" ) != null ? (String) request.getParameter( "startdate" ) : "";
 String oEndDate = request.getParameter( "enddate" ) != null ? (String) request.getParameter( "enddate" ) : "";
 String oActive = request.getParameter( "active" ) != null ? (String) request.getParameter( "active" ) : "";
 
 out.println( oFirstName + ":" + oLastName + ":" + oPhoneMobile + ":" + oPhoneFix + ":" + oPhoneFax + ":"
  + oEmpType + ":" + oPosition + ":" + oLocation + ":" + oIsManager + ":" + oManagerID + ":"
  + oDepartment + ":" + oOrganization + ":" + oStartDate + ":" + oEndDate + ":" + oActive );
 
 try
 {
//String oJDBCDriver   = application.getInitParameter( "jdbc.driver" )   != null ? application.getInitParameter( "jdbc.driver" )   : "oracle.jdbc.driver.OracleDriver";
//String oJDBCURL      = application.getInitParameter( "jdbc.url" )      != null ? application.getInitParameter( "jdbc.url" )      : "jdbc:oracle:thin:@localhost:1521:orcl";
//String oJDBCUser     = application.getInitParameter( "jdbc.user" )     != null ? application.getInitParameter( "jdbc.user" )     : "demoapps";
//String oJDBCPassword = application.getInitParameter( "jdbc.password" ) != null ? application.getInitParameter( "jdbc.password" ) : "abcd1234";

  Class.forName( oJDBCDriver );
  Connection conn = DriverManager.getConnection( oJDBCURL, oJDBCUser, oJDBCPassword );
  
 //String oLoggedUser = (String) request.getParameter( "logged-user" );
// String oLoggedUser = "can_candy";
 String oLoggedUser = (String) session.getAttribute( "logged-user" );

 System.out.println ("**** INSERT INTO DEMO_HR_EMPLOYEES ****");
 CallableStatement stmt2 = null;
 String sql = "{call employeesearch_prod.set_app_user_label ( ? )}";
 stmt2 = conn.prepareCall(sql);
 stmt2.setString (1, oLoggedUser);
 stmt2.executeQuery();

 System.out.println ("**** PRINT VARIABLES FOR INSERT ****");
 System.out.println (oLoggedUser);
 System.out.println( sql );

  Statement stmt = conn.createStatement();

// uncomment and use this to determine whether your query is totaled or not
//String oQuery = "select 1 from dual";

String oQuery = "insert into DEMO_HR_EMPLOYEES ( USERID, CREATIONDATE, FIRSTNAME, LASTNAME, PHONEMOBILE, PHONEFIX, DOB, EMAIL, SSN, SIN, NINO, ADDRESS_1, ADDRESS_2, COUNTRY, POSTAL_CODE, PHONEFAX, EMPTYPE, POSITION, LOCATION, ISMANAGER, MANAGERID, COSTCENTER, DEPARTMENT, ISHEADOFDEPARTMENT, ORGANIZATION, ACTIVE, STARTDATE, ENDDATE) values ( DEMO_HR_EMPLOYEES_SEQ.nextval , sysdate , '" + oFirstName + "' , '" + oLastName  + "' , '" + oPhoneMobile + "' , '" + oPhoneFix  + "' , TO_DATE('" + oDOB + "','YYYY-MM-dd') , '" + oEmail   + "' , '" + oSSN   + "' , '" + oSIN   + "' , '" + oNINO   + "' , '" + oAddress_1  + "' , '" + oAddress_2  + "' , '" + oCountry  + "' , '" + oPostalCode  + "' , '" + oPhoneFax  + "' , '" + oEmpType  + "' , '" + oPosition  + "' , '" + oLocation  + "' , " + oIsManager  + " , " + oManagerID  + " , '" + oCostCenter + "' , '" + oDepartment + "' , " + oIsHeadOfDepartment + " , '" + oOrganization + "' , " + oActive + " , TO_DATE('" + oStartDate + "','YYYY-MM-dd') , TO_DATE('" + oEndDate + "','YYYY-MM-dd'))"; 


System.out.println( oQuery );


  int rows = stmt.executeUpdate( oQuery );

  if (rows > 0)
  oQuery = "SELECT DEMO_HR_EMPLOYEES_SEQ.CURRVAL FROM DUAL";
  
  System.out.println( oQuery );

  ResultSet rs = stmt.executeQuery( oQuery );
  if (rs.next())
  {
   int    oUserID = rs.getInt(1);   
   response.sendRedirect( "employee_view.jsp?userid=" + oUserID );
  }
  else
  {
   response.sendRedirect( "employee_create.jsp?err=error_creating_employee" );
  }
 }
 catch( Exception e )
 {
  System.out.println("Got an SQL fout in : " + e.getMessage());
  response.sendRedirect( "employee_create.jsp?err=error_while_updating" );
 }
}
%>
<a href="index.jsp">Return to home page</a>
