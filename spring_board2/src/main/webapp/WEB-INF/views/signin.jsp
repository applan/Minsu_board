<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="/resources/vendor/bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet" href="/resources/vendor/bootstrap/css/signin.css" />
<script>
	
</script>
</head>
<body>
<form class="form-signin" method="post" action="/login">  
  <h1 class="h3 mb-3 font-weight-normal">Please sign in</h1>
  <label for="userid" class="sr-only">아이디</label>
  <input type="text" id="username" name="username" class="form-control" placeholder="아이디" required autofocus>
  <label for="inputPassword" class="sr-only">Password</label>
  <input type="password" id="password" name="password" 
  		class="form-control" placeholder="비밀번호" required>
  <div class="checkbox mb-3">
    <label>
      <input type="checkbox" value="remember-me"> Remember me
    </label>
  </div>
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
  <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
  <p class="mt-5 mb-3 text-muted">&copy; 2018-2019</p>
</form>
</body>
</html>















