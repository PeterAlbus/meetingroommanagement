<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/1/3
  Time: 1:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>后台管理页面</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/float.css" rel="stylesheet">
    <link href="css/bkg.css" rel="stylesheet">
</head>
<body>
<%
    response.setContentType("text/html;charset=utf-8");
    request.setCharacterEncoding("UTF-8");
    String username="000";
    String nickname = null;
    int groupid = 0;
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
    if(groupid==1)
    {
        response.sendRedirect("admin_PermissionDenied.jsp");
    }
%>
<nav class="nav navbar-default navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">会议室预订系统-管理系统</a>
        </div>
        <div>
            <ul class="nav navbar-nav">
                <li class="active"><a href="admin_index.jsp">主页</a></li>
                <li><a href="admin_allorder.jsp">查看所有订单</a></li>
                <li><a href="admin_room.jsp">管理会议室</a></li>
                <%
                    if(groupid==3)
                    {
                %>
                <li><a href="admin_users.jsp">管理用户</a></li>
                <%
                    }
                %>
            </ul>
        </div>
        <p class="navbar-text navbar-right">欢迎!<%=nickname%>,<a href="process_logout.jsp">登出</a></p>
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
                欢迎来到会议室预订系统的管理界面。<br><br>
                作为系统管理员，请牢记你拥有权力时也拥有责任。<br><br>
                您可以通过查看所有订单一栏查看/取消订单<br><br>
                您可以通过管理会议室一栏添加/删除会议室<br><br>
                对用户及用户组的操作则需要超级账户来执行<br><br>
                请妥善进行每一步操作<br><br>
            </h4>
            <p class="text-center" style="float: bottom"><em>by 1951123吴鸿&1951133陈小飞</em></p>
        </div>
    </div>
    <div class="row">
        <p class="text-center">
            <a href="user_index.jsp">返回预订系统</a><br/>
        </p>
    </div>
    <div style="z-index:999;display: block; position: fixed; right: 200px; bottom: 200px;">
        <div id="switchbutton">
            <a href="user_index.jsp"><img src="image/touser.png" class="float"></a>
        </div>
    </div>
</div>
</body>
</html>
