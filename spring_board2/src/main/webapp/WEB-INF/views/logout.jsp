<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그아웃</title>
<link rel="stylesheet" href="/resources/vendor/bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet" href="/resources/vendor/bootstrap/css/signin.css" />
</head>
<body class="text-center">
   <form action="/logout" method="post" class="form-signin c">
        <!-- <h1 class="h3 mb-3 font-weight-nomal">Logout</h1>
        <button class="btn btn-lg btn-primary btn-block" type="submit">Logout</button> -->
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
   </form>
</body>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
 $(function() {
	 alert("로그아웃합니다.");
	$(".c").submit();
});
</script>
</html>
