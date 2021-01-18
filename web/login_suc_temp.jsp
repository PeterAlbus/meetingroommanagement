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
    <title>登录成功,跳转中</title>
</head>
<body>
登录成功,跳转中
<%
    response.sendRedirect("user_index.jsp");
%>
</body>
</html>
