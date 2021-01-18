<%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2020/12/29
  Time: 20:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户注册</title>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/login.css" rel="stylesheet">
</head>
<body style="background-image: url('image/login2.jpg');background-size: cover">
<div class="container">
    <div class="row" style="margin-top: 200px;">
        <div class="col-md-6 col-md-offset-3">
            <form action="register_result" method="post" class="form-horizontal">
                <span class="heading">会议室管理系统-注册</span>
                <div class="form-group">
                    <p class="text-left"><input type="text" name="username" id="username" class="form-control" placeholder="用户名"/><span class="glyphicon glyphicon-user"></span></p>
                </div>
                <div class="form-group">
                    <p class="text-left"><input type="text" name="nickname" id="nickname" class="form-control" placeholder="昵称"/><span class="glyphicon glyphicon-credit-card"></span></p>
                 </div>
                <div class="form-group">
                    <p class="text-left"><input type="password" name="password" id="password" class="form-control" placeholder="密码"/><span class="glyphicon glyphicon-lock"></span></p>
                </div>
                <p class="text-center"><input type="submit" value="注册" class="btn btn-default"><a href="login_index.jsp">返回登录</a></p>
            </form>
        </div>
    </div>
</div>
</body>
</html>
