<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2020/12/30
  Time: 10:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>失败</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/login.css" rel="stylesheet">
</head>
<body style="background-image: url('image/login2.jpg');background-size: cover">
<%
    response.setContentType("text/html;charset=utf-8");
    request.setCharacterEncoding("UTF-8");
    String reason= (String) request.getAttribute("reason");
%>
<div class="container">
    <div class="row" style="margin-top: 200px">
        <div class="col-md-6 col-md-offset-3">
            <form class="form-horizontal">
                <span class="heading">失败</span>
                <p class="text-center">
                    <%=reason%><br/><br/><br/><br/>
                    <input type="button" class="btn btn-default" value="重新登录" onclick="location.href='login_index.jsp'">
                </p>
            </form>
        </div>
    </div>
</div>

</body>
</html>
