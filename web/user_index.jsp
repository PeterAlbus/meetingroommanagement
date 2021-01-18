<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2020/12/30
  Time: 10:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>会议室预订系统</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/float.css" rel="stylesheet">
    <link href="css/bkg.css" rel="stylesheet">
</head>
<body>
<%
    response.setContentType("text/html;charset=utf-8");
    request.setCharacterEncoding("UTF-8");
    String username="000";
    String nickname = null,groupname = null;
    int groupid = 0,index=1;
    boolean flag=false;
    Cookie[] cookies=request.getCookies();
    for(int i=0;i<cookies.length;i++)
    {
        if(cookies[i].getName().equals("username"))
        {
            flag=true;
            username=cookies[i].getValue();
        }
    }
    if(!flag)
    {
        response.sendRedirect("login_index.jsp");
        return;
    }
    Connection conn;
    PreparedStatement ps;
    ResultSet result;
    try
    {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=UTC", "root", "1951123");
        ps=conn.prepareStatement("select * from meetingroommanagement.users where username=?");
        ps.setString(1,username);
        result=ps.executeQuery();
        if(result.next())
        {
            nickname=result.getString("nickname");
            groupid=result.getInt("groupid");
        }
    } catch (SQLException | ClassNotFoundException throwables) {
        throwables.printStackTrace();
    }
    if(groupid==1) groupname="用户";
    else if(groupid==2) groupname="管理员";
    else if(groupid==3) groupname="超级账户";
%>
<nav class="nav navbar-default navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">会议室预订系统</a>
        </div>
        <div>
            <ul class="nav navbar-nav">
                <li class="active"><a href="user_index.jsp">主页</a></li>
                <li><a href="user_rooms.jsp">查看会议室</a></li>
                <li><a href="user_order.jsp">我的预订</a></li>
            </ul>
        </div>
        <p class="navbar-text navbar-right">欢迎!<%=nickname%>,您的用户组为:<%=groupname%>,<a href="process_logout.jsp">登出</a></p>
    </div>
</nav>
<div class="container">
    <div class="row text-center">
        <img src="image/logoh220.png" alt="会议室管理系统" style="margin:auto">
    </div>
    <div class="row">
        <div class="col-md-4 col-md-offset-4">
            <h4>
                <br><br><br><br>
                欢迎来到会议室预订系统。<br><br>
                您可以通过查看会议室一栏查看所有会议室<br><br>
                在查看会议室一栏点击会议室的详细信息按钮可以查看会议室已有的预订<br><br>
                同时也可以预订该会议室<br><br>
                我的预订页面可以查看自己的所有预订及进行取消预订操作<br><br>
            </h4>
            <p class="text-center" style="float: bottom"><em>by 1951123吴鸿&1951133陈小飞</em></p>
        </div>
    </div>
<%
        if(groupid==2||groupid==3)
    {
%>
    <div style="z-index:999;display: block; position: fixed; right: 200px; bottom: 200px;">
        <div id="switchbutton">
            <a href="admin_index.jsp"><img src="image/toadmin.png" class="float"></a>
        </div>
    </div>
<%
    }
%>
</div>
</body>
</html>
