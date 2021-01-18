<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: PeterAlbus
  Date: 2021/1/2
  Time: 19:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>详细信息</title>
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
        conn.close();
        ps.close();
        result.close();
    } catch (SQLException | ClassNotFoundException throwables) {
        throwables.printStackTrace();
    }
    if(groupid==1) groupname="用户";
    else if(groupid==2) groupname="管理员";
    else if(groupid==3) groupname="超级账户";
    String roomid=request.getParameter("roomid");
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
                <li class="active"><a href="#">会议室详情/发起预定</a></li>
            </ul>
        </div>
        <p class="navbar-text navbar-right">欢迎!<%=nickname%>,您的用户组为:<%=groupname%>,<a href="process_logout.jsp">登出</a></p>
    </div>
</nav>
<div class="container">
<%
    try
    {
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/meetingroommanagement?serverTimezone=Asia/Shanghai", "root", "1951123");
        ps=conn.prepareStatement("select * from meetingroommanagement.meetingrooms where room_id=?");
        ps.setString(1,roomid);
        result=ps.executeQuery();
        if(result.next())
        {
            %>
            <div class="row">
                <div class="col-md-4">
                    <div class="page-header">
                        <h1>会议室信息</h1>
                    </div>
                    <p>会议室房间号:<%=result.getString("room_number")%><br/>会议室类型:<%=result.getString("room_name")%></p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-4 form-group">
                    <div class="page-header">
                        <h1>预订该会议室</h1>
                    </div>
                    <form action="neworder">
                        <label>开始时间
                            <input type="datetime-local" name="time_s" value="2021-01-01T13:00" class="form-control">
                        </label><br>
                        <label>结束时间
                            <input type="datetime-local" name="time_e" value="2021-01-01T13:00" class="form-control">
                        </label>
                        <input type="text" style="display:none"  value=<%=roomid%> name="roomid"/>
                        <input type="text" style="display:none"  value=<%=username%> name="username"/>
                        <p class="text-left"><input type="submit" value="提交预订" class="btn btn-default"></p>
                    </form>
                </div>
            </div>
        <table class="table table-hover">
        <caption>
            <div class="page-header">
                <h1>该会议室的预订列表</h1>
            </div>
        </caption>
        <thead>
        <tr>
            <th>#</th>
            <th>预订时间</th>
        </tr>
        </thead>
        <tbody>
            <%
        }
        ps=conn.prepareStatement("select * from meetingroommanagement.orders where room_id=?");
        ps.setString(1,roomid);
        result=ps.executeQuery();
        while(result.next())
        {
            %>
        <tr>
            <td><%=index%></td>
            <td><%=result.getString("time_start")%>-<%=result.getString("time_end")%></td>
        </tr>
            <%
            index++;
        }
    } catch (SQLException throwables) {
        throwables.printStackTrace();
    }
%>
        </tbody>
    </table>
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
    <p class="text-right"><input type="button" onclick="javascript:history.go(-1)" class="btn btn-default" value="返回"/></p>
</div>
</body>
</html>
