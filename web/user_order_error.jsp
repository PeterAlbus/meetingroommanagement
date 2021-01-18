<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/1/2
  Time: 23:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>error</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/float.css" rel="stylesheet">
    <link href="css/bkg.css" rel="stylesheet">
</head>
<body>
<%
    response.setContentType("text/html;charset=utf-8");
    request.setCharacterEncoding("UTF-8");
    String reason= (String) request.getAttribute("reason");
%>
<nav class="nav navbar-default navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">会议室预订系统</a>
        </div>
        <div>
            <ul class="nav navbar-nav">
                <li><a href="user_index.jsp">主页</a></li>
                <li><a href="user_rooms.jsp">查看会议室</a></li>
                <li><a href="user_order.jsp">我的预订</a></li>
                <li class="active"><a href="#">失败</a></li>
            </ul>
        </div>
    </div>
</nav>
<div class="container">
    <div class="page-header">
        <h1>失败！</h1>
    </div>
    <p><%=reason%><br/></p>
    <input type="button" onclick="javascript:history.go(-1)" class="btn btn-default" value="返回"/>
</div>
</body>
</html>
