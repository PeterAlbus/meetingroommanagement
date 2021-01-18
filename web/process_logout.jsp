<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2020/12/31
  Time: 9:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登出中</title>
</head>
<body>
<%
    Cookie[] cookies=request.getCookies();
    for(int i=0;i<cookies.length;i++)
    {
        if(cookies[i].getName().equals("username"))
        {
            cookies[i].setMaxAge(0);
            response.addCookie(cookies[i]);
        }
    }
    response.sendRedirect("login_index.jsp");
%>
</body>
</html>
